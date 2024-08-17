{
  inputs = {
    immortalwrt-imagebuilder.url = "github:codgician/nix-immortalwrt-imagebuilder";
  };

  outputs = { self, nixpkgs, immortalwrt-imagebuilder }:
    let
      lib = nixpkgs.lib.extend (self: super: {
        fountaine-of-lucine = import ./lib.nix { lib = self; };
      });
      foreachArch = func: lib.genAttrs [ "x86_64-linux" ] (system: func nixpkgs.legacyPackages.${system});
      getNixFileNamesWithoutExt = lib.fountaine-of-lucine.getNixFileNamesWithoutExt;
      bundleNames = getNixFileNamesWithoutExt ./bundles;
      bundles = lib.genAttrs bundleNames (name: import ./bundles/${name}.nix);
      routerNames = getNixFileNamesWithoutExt ./routers;
      mkPackage = pkgs: name: import ./routers/${name}.nix {
        inherit pkgs lib bundles;
        inherit (immortalwrt-imagebuilder) profiles;
        inherit (immortalwrt-imagebuilder.lib) build;
      };
    in
    {
      formatter = foreachArch (pkgs: pkgs.nixpkgs-fmt);
      packages = foreachArch (pkgs: lib.genAttrs routerNames (mkPackage pkgs));
    };
}
