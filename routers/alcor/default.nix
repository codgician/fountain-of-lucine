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
{
  inherit channel;
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
      "kmod-mt7915-firmware"

      # battery monitoring (battery/)
      "coreutils-stty"
    ];

  # sms_led.sh (luci-app-sms-tool-js LED notifier) polls every second; SMS itself does not need it
  disabledServices = [ "my_new_sms" ];

  files = pkgs.runCommand "image-files" { } ''
    mkdir -p $out/etc
    cp ${./rc.local} $out/etc/rc.local
    cp -r ${./sysctl.d}/. $out/etc/sysctl.d
    cp -r ${./hotplug.d}/. $out/etc/hotplug.d

    # Battery: MCU poller, ubus object (rpcd plugin), enabled service, LuCI status card
    install -Dm755 ${./battery/battery-monitor} $out/usr/sbin/battery-monitor
    install -Dm755 ${./battery/rpcd} $out/usr/libexec/rpcd/battery
    install -Dm755 ${./battery/battery.init} $out/etc/init.d/battery
    mkdir -p $out/etc/rc.d
    ln -s ../init.d/battery $out/etc/rc.d/S99battery
    install -Dm644 ${./battery/15_battery.js} $out/www/luci-static/resources/view/status/include/15_battery.js
    install -Dm644 ${./battery/acl.json} $out/usr/share/rpcd/acl.d/luci-mod-status-index-battery.json

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
