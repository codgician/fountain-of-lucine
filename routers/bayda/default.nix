# GL.iNet MiFi
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
  target = "ath79";
  variant = "generic";
  release = "24.10.0-rc3";
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
  profile = "glinet_gl-mifi";
  packages =
    with packageLists;
    celluar
    ++ common
    ++ usb
    ++ [
      "luci-app-wol"
      "luci-i18n-wol-zh-cn"
      "luci-app-banip"
      "luci-i18n-banip-zh-cn"
      "luci-app-watchcat"
      "luci-i18n-watchcat-zh-cn"
      "luci-app-uhttpd"
      "luci-i18n-uhttpd-zh-cn"
    ];

  files = pkgs.runCommand "image-files" { } ''
    mkdir -p $out/etc/uci-defaults
    cat > $out/etc/uci-defaults/99-custom << EOF
    uci -q batch << EOI
    set network.lan.ipaddr=192.168.4.1
    commit
    EOI
    EOF
  '';
}
