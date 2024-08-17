# x86_64 router
{ pkgs, lib, build, bundles, ... }:

let
  baremetal = false;
  target = "x86";
  variant = "64";
  release = "snapshot";
  packageLists = builtins.mapAttrs
    (k: v: v { inherit lib release target variant baremetal; })
    bundles;
in
build {
  inherit release target variant;
  profile = "generic";
  rootFsPartSize = 896;
  packages = with packageLists;
    apps ++ common ++ collectd ++ proxy ++ usb ++ [
      "kmod-igc" # Intel I-225V/LM
      "coturn"
      "-libustream-openssl"
      "luci-ssl"
    ];

  files = pkgs.runCommand "image-files" { } ''
    mkdir -p $out/etc/uci-defaults
    cat > $out/etc/uci-defaults/99-custom <<EOF
    uci -q batch << EOI
    set network.lan.ipaddr=192.168.0.1
    commit
    EOI
    EOF
  '';
}
