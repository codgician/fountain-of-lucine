# GL.iNet XE3000
{ pkgs, lib, build, bundles, ... }:

let
  baremetal = true;
  target = "mediatek";
  variant = "filogic";
  release = "snapshot";
  packageLists = builtins.mapAttrs
    (k: v: v { inherit lib release target variant baremetal; })
    bundles;
in
build {
  inherit release target variant;
  profile = "glinet_gl-xe3000";
  packages = with packageLists;
    apps ++ celluar ++ common ++ mwan ++ collectd ++ proxy ++ usb ++ [
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
