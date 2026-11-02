{
  inputs = {
    immortalwrt.url = "github:codgician/immortalwrt.nix";
    nixpkgs.follows = "immortalwrt/nixpkgs";
  };

  nixConfig = {
    extra-substituters = [ "https://cache.codgician.me/immortalwrt" ];
    extra-trusted-public-keys = [ "immortalwrt:t17gIHmdp6G9DpukeaW0LCB32Lg+mPRvN0SNdGW1r90=" ];
  };

  outputs =
    {
      self,
      nixpkgs,
      immortalwrt,
    }:
    let
      lib = nixpkgs.lib.extend (
        self: super: {
          fountaine-of-lucine = import ./lib.nix { lib = self; };
        }
      );
      foreachArch = func: lib.genAttrs [ "x86_64-linux" ] (system: func nixpkgs.legacyPackages.${system});
      inherit (lib.fountaine-of-lucine) getNixFileNamesWithoutExt getFolderNames;
      appNames = getNixFileNamesWithoutExt ./apps;
      mkApp = pkgs: name: {
        type = "app";
        program = import ./apps/${name}.nix { inherit self pkgs lib; };
      };
      bundleNames = getNixFileNamesWithoutExt ./bundles;
      bundles = lib.genAttrs bundleNames (name: import ./bundles/${name}.nix);
      routerNames = getFolderNames ./routers;

      # Each router names its channel, target, device profile, packages and files.
      mkRouters =
        pkgs:
        lib.genAttrs routerNames (
          name:
          import ./routers/${name} {
            inherit
              pkgs
              lib
              bundles
              self
              name
              ;
            inherit (immortalwrt.legacyPackages.${pkgs.stdenv.hostPlatform.system}) channels;
          }
        );

      # Routers on the same channel and target share one ImageBuilder, built from source with
      # the union of their packages: { "<channel>-<target>" = { channel; target; routers; }; }
      mkGroups =
        routers:
        lib.mapAttrs' (
          _: names:
          let
            router = routers.${lib.head names};
          in
          lib.nameValuePair "${router.channel.name}-${lib.replaceStrings [ "/" ] [ "-" ] router.target}" {
            inherit (router) channel target;
            routers = names;
          }
        ) (lib.groupBy (n: "${routers.${n}.channel.name} ${routers.${n}.target}") routerNames);

      mkImages =
        routers:
        lib.concatMapAttrs (
          _: group:
          lib.mapAttrs (n: image: (routers.${n}.overrideImage or lib.id) image) (
            group.channel.mkImages (
              lib.genAttrs group.routers (
                n:
                removeAttrs routers.${n} [
                  "channel"
                  "overrideImage"
                ]
              )
            )
          )
        ) (mkGroups routers);
    in
    {
      apps = foreachArch (pkgs: (lib.genAttrs appNames (mkApp pkgs)));

      formatter = foreachArch (
        pkgs:
        pkgs.writeShellApplication {
          name = "formatter";
          runtimeInputs = with pkgs; [
            treefmt
            nixfmt-rfc-style
          ];
          text = lib.getExe pkgs.treefmt;
        }
      );

      packages = foreachArch (pkgs: mkImages (mkRouters pkgs));

      # Build stages per group, so CI can build (and cache) them in separate jobs
      legacyPackages = foreachArch (
        pkgs:
        let
          routers = mkRouters pkgs;
          images = self.packages.${pkgs.stdenv.hostPlatform.system};
        in
        {
          groups = lib.mapAttrs (_: group: {
            inherit (group) routers;
            toolchain = group.channel.toolchain.${group.target};
            imagebuilder = images.${lib.head group.routers}.imagebuilder;
          }) (mkGroups routers);
        }
      );
    };
}
