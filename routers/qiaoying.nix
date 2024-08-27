# NanoPi R4SE
{ name, pkgs, lib, build, bundles, ... }:

let
  baremetal = true;
  target = "rockchip";
  variant = "armv8";
  release = "23.05.3";
  packageLists = builtins.mapAttrs
    (k: v: v { inherit lib release target variant baremetal; })
    bundles;
in
build {
  inherit release target variant;
  extraImageName = name;
  profile = "friendlyarm_nanopi-r4se";
  packages = with packageLists;
    apps ++ common ++ collectd ++ nas ++ proxy ++ tools ++ usb ++ [
      "-libustream-openssl"
      "luci-ssl"
    ];

  files = pkgs.runCommand "image-files" { } ''
    mkdir -p $out/etc/uci-defaults
    cat > $out/etc/uci-defaults/99-custom <<EOF
    uci -q batch << EOI
    set network.lan.ipaddr=192.168.6.1
    commit
    EOI
    EOF
  '';
}
