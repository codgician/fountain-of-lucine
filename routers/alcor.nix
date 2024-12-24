# GL.iNet XE3000
{ name, pkgs, lib, build, bundles, ... }:

let
  baremetal = true;
  target = "mediatek";
  variant = "filogic";
  release = "24.10.0-rc2";
  packageLists = builtins.mapAttrs
    (k: v: v { inherit lib release target variant baremetal; })
    bundles;
in
build {
  inherit release target variant pkgs;
  extraImageName = name;
  profile = "glinet_gl-xe3000";
  packages = with packageLists;
    apps ++ celluar ++ common ++ mwan ++ collectd ++ proxy ++ tools ++ usb ++ [
      # No longer exist in snapshot
      "-ipv6helper"
      
      "-libustream-openssl"
      "luci-ssl"

      "mt7981-wo-firmware"
    ];

  files = pkgs.runCommand "image-files" { } ''
    mkdir -p $out/etc/uci-defaults
    cat > $out/etc/uci-defaults/99-custom <<EOF
    uci -q batch << EOI
    set network.lan.ipaddr=192.168.5.1
    commit
    EOI
    EOF
  '';
}
