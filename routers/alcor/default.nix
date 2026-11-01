# GL.iNet XE3000
{
  name,
  pkgs,
  lib,
  bundles,
  channels,
  ...
}:

let
  channel = channels."immortalwrt-25.12";
  baremetal = true;
  target = "mediatek";
  variant = "filogic";
  release = channel.version;
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
      qmi = true;
      mhi = true;
    }
  ) bundles;
in
channel.mkImage {
  inherit name;
  target = "${target}/${variant}";
  profile = "glinet_gl-xe3000";
  packages =
    with packageLists;
    apps
    ++ cellular
    ++ common
    ++ mwan
    ++ collectd
    ++ proxy
    ++ qos
    ++ tools
    ++ usb
    ++ [
      "-libustream-openssl"
      "luci-ssl"
      "kmod-mtd-rw"
      "mt7981-wo-firmware"
      "kmod-mt76-sdio"
      "kmod-mt7915-firmware"
    ];

  files = pkgs.runCommand "image-files" { } ''
    mkdir -p $out/etc
    cp ${./rc.local} $out/etc/rc.local
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
