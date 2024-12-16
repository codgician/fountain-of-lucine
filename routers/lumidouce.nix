# x86_64 router
{ name, pkgs, lib, build, bundles, ... }:

let
  baremetal = false;
  target = "x86";
  variant = "64";
  release = "24.10.0-rc1";
  packageLists = builtins.mapAttrs
    (k: v: v { inherit lib release target variant baremetal; })
    bundles;
in
(build {
  inherit release target variant pkgs;
  extraImageName = name;
  profile = "generic";
  rootFsPartSize = 896;
  packages = with packageLists;
    apps ++ common ++ collectd ++ proxy ++ tools ++ usb ++ [      
      "-libustream-openssl"
      "luci-ssl"

      "coturn"

      "intel-microcode"
      "iucode-tool"
      "kmod-igc"
      "kmod-kvm-intel"
      "kmod-i2c-i801"
      "kmod-itco-wdt"
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
}).overrideAttrs (selfAttrs: superAttrs: {
  # Skip generating unneeded image formats
  postConfigure = ''
    sed -i "s/CONFIG_TARGET_ROOTFS_EXT4FS=y/CONFIG_TARGET_ROOTFS_EXT4FS=n/g" ./.config
    sed -i "s/CONFIG_VHDX_IMAGES=y/CONFIG_VHDX_IMAGES=n/g" ./.config
    sed -i "s/CONFIG_QCOW2_IMAGES=y/CONFIG_QCOW2_IMAGES=n/g" ./.config
    sed -i "s/CONFIG_ISO_IMAGES=y/CONFIG_ISO_IMAGES=n/g" ./.config
    sed -i "s/CONFIG_VMDK_IMAGES=y/CONFIG_VMDK_IMAGES=n/g" ./.config
    sed -i "s/CONFIG_VDI_IMAGES=y/CONFIG_VDI_IMAGES=n/g" ./.config
  '';
})
