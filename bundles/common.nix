# Common package bundle

{
  lib,
  baremetal,
  target,
  release,
  ...
}:

[
  "iptables-nft"
  "ip6tables-nft"

  "kmod-br-netfilter"
  "kmod-nf-nat"
  "kmod-nf-nat6"
  "kmod-nf-nathelper"
  "kmod-nf-nathelper-extra"
  "kmod-nfnetlink"
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
  "kmod-ipt-tproxy"
  "kmod-ipt-nat6"
  "kmod-ipt-nat-extra"
  "kmod-ipt-offload"
  "kmod-ipt-conntrack"
  "kmod-ipt-conntrack-extra"
  "kmod-ipt-conntrack-label"
  "kmod-ipt-nathelper-rtsp"
  "iptables-mod-nflog"
  "iptables-mod-nfqueue"
  "kmod-mdio-netlink"

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
]
++ (lib.optionals baremetal [
  "lm-sensors-detect"
  "lm-sensors"
  "losetup"

  "kmod-hwmon-drivetemp"
  "kmod-hwmon-pwmfan"
  "kmod-hwmon-gpiofan"
  "kmod-hwmon-vid"

  "kmod-nvme"
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
