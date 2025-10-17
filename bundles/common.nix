# Common package bundle

{
  lib,
  baremetal,
  target,
  release,
  selinux ? false,
  ...
}:

[
  "arptables-nft"
  "iptables-nft"
  "ip6tables-nft"

  "kmod-arptables"
  "kmod-br-netfilter"
  "kmod-mdio-netlink"
  "kmod-nf-nat"
  "kmod-nf-nat6"
  "kmod-nf-nathelper"
  "kmod-nf-nathelper-extra"
  "kmod-nfnetlink"
  "kmod-nfnetlink-cthelper"
  "kmod-nfnetlink-cttimeout"
  "kmod-nfnetlink-log"
  "kmod-nfnetlink-queue"
  "kmod-nf-ipvs"
  "kmod-nf-ipvs-ftp"
  "kmod-nf-ipvs-sip"
  "kmod-nlmon"
  "kmod-nft-arp"
  "kmod-nft-bridge"
  "kmod-nft-compat"
  "kmod-nft-connlimit"
  "kmod-nft-dup-inet"
  "kmod-nft-netdev"
  "kmod-nft-queue"
  "kmod-nft-socket"
  "kmod-nft-tproxy"
  "kmod-nft-xfrm"
  "kmod-nft-offload"

  "kmod-tls"
  "kmod-sched-mqprio"
  "kmod-sched-connmark"
  "kmod-tcp-bbr"

  "luci-i18n-base-zh-cn"
  "luci-i18n-firewall-zh-cn"
  "luci-proto-wireguard"

  "ca-bundle"
  "htop"
  "minicom"

  "avahi-daemon-service-ssh"
  "avahi-daemon-service-http"
  "avahi-utils"
  "wsdd2"

  "dosfstools"
  "f2fs-tools"
  "f2fsck"
]
++ (lib.optionals selinux [
  "-busybox"
  "busybox-selinux"

  "-procd"
  "procd-selinux"

  "-mkf2fs"
  "mkf2fs-selinux"
  "-f2fs-tools"
  "f2fs-tools-selinux"
  "-f2fsck"
  "f2fsck-selinux"

  "selinux-policy"
  "policycoreutils"
  "policycoreutils-fixfiles"
  "policycoreutils-load_policy"
  "policycoreutils-semodule"
  "policycoreutils-sestatus"
])
++ (lib.optionals baremetal [
  "lm-sensors-detect"
  "lm-sensors"
  "losetup"
  "fdisk"

  "kmod-hwmon-drivetemp"
  "kmod-hwmon-pwmfan"
  "kmod-hwmon-gpiofan"
  "kmod-hwmon-vid"

  "kmod-nvme"
  "nvme-cli"
  "pciutils"
])
++ (lib.optionals (!baremetal) [
  "qemu-ga"
  "virtio-console-helper"
  "kmod-i6300esb-wdt"
  "kmod-itco-wdt"
  "kmod-softdog"
])
++ (lib.optionals (target == "rockchip") [
  "kmod-drm-rockchip"
  "kmod-saradc-rockchip"
])
++ (lib.optionals (release != "snapshot" && !(lib.versionAtLeast release "24.00")) [
  "luci-i18n-opkg-zh-cn"
])
++ (lib.optionals (release == "snapshot" || (lib.versionAtLeast release "24.00")) [
  "luci-i18n-package-manager-zh-cn"
])
