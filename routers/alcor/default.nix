# GL.iNet XE3000
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
  profile = "glinet_gl-xe3000";
  packages =
    with packageLists;
    apps
    ++ celluar
    ++ common
    ++ mwan
    ++ collectd
    ++ proxy
    ++ tools
    ++ usb
    ++ [
      "-libustream-openssl"
      "luci-ssl"
    ];

  files = pkgs.runCommand "image-files" { } ''
    mkdir -p $out/etc
    cp -r ${./sysctl.d}/. $out/etc/sysctl.d

    mkdir -p $out/etc/uci-defaults
    cat > $out/etc/uci-defaults/99-custom <<EOF
    uci -q batch << EOI
    set system.hostname='${name}'
    set network.lan.ipaddr=192.168.5.1
    commit
    EOI
    EOF
  '';
}
