# BananaPi R3-Mini
{
  name,
  pkgs,
  lib,
  build,
  bundles,
  ...
}:

let
  baremetal = true;
  target = "mediatek";
  variant = "filogic";
  release = "24.10.0";
  packageLists = builtins.mapAttrs (
    k: v:
    v {
      inherit
        lib
        release
        target
        variant
        baremetal
        ;
    }
  ) bundles;
in
build {
  inherit
    release
    target
    variant
    pkgs
    ;
  extraImageName = name;
  profile = "bananapi_bpi-r3-mini";
  packages =
    with packageLists;
    apps
    ++ common
    ++ collectd
    ++ nas
    ++ proxy
    ++ tools
    ++ usb
    ++ [
      "-libustream-openssl"
      "luci-ssl"
      "kmod-mtd-rw"
      "kmod-sound-soc-mt7986"
      "kmod-sound-soc-mt7986-wm8960"
      "kmod-mt76-sdio"
    ];

  files = pkgs.runCommand "image-files" { } ''
    mkdir -p $out/etc
    cp -r ${./sysctl.d}/. $out/etc/sysctl.d
    cp ${./rc.local} $out/etc/rc.local

    mkdir -p $out/etc/uci-defaults
    cat > $out/etc/uci-defaults/99-custom <<EOF
    uci -q batch << EOI
    set system.hostname='${name}'
    set network.lan.ipaddr=192.168.6.1
    commit
    EOI
    EOF
  '';
}
