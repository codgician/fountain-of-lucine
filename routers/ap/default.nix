# Gemtek / Brightspeed XR1710G, OpenWrt U-Boot UBI layout
{
  name,
  pkgs,
  lib,
  bundles,
  channels,
  ...
}:

let
  # naoki66's fork; upstream ImmortalWrt has no XR1710G support
  channel = channels.gemtek;
  baremetal = true;
  target = "airoha";
  variant = "an7581";
  release = if lib.hasSuffix "SNAPSHOT" channel.version then "snapshot" else channel.version;
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
{
  inherit channel;
  target = "${target}/${variant}";
  # Wi-Fi, NPU and PHY firmware come with the device profile
  profile = "gemtek_xr1710g-ubi";
  packages =
    with packageLists;
    common
    ++ collectd
    ++ tools
    ++ [
      # upstream ImmortalWrt targets add these by default; the fork's airoha target does not
      "luci"
      "default-settings-chn"

      "-libustream-openssl"
      "luci-ssl"
    ];

  files = pkgs.runCommand "image-files" { } ''
    mkdir -p $out/etc/uci-defaults
    cat > $out/etc/uci-defaults/99-custom <<EOF
    uci -q batch << EOI
    set system.hostname='${name}'
    set network.lan.ipaddr=192.168.50.1
    commit
    EOI
    EOF
  '';
}
