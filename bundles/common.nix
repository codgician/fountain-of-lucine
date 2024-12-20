# Common package bundle

{ lib, baremetal, target, release, ... }:

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
  "kmod-tls"
  "kmod-sched-mqprio"
  "kmod-tcp-bbr"

  "htop"
  "minicom"
  "ca-bundle"
  "bind-host"
  "bind-dig"
  "wget-ssl"
  "iperf3"
  "telnet-bsd"
  "lscpu"
  "lsblk"

  "luci-i18n-base-zh-cn"
  "luci-i18n-firewall-zh-cn"
  "luci-proto-wireguard"

  "avahi-daemon-service-ssh"
  "avahi-daemon-service-http"
] ++ (lib.optionals baremetal [
  "lm-sensors-detect"
  "lm-sensors"
  "losetup"
]) ++ (lib.optionals (!baremetal) [
  "qemu-ga"
  "virtio-console-helper"
  "kmod-i6300esb-wdt"
]) ++ (lib.optionals (target == "rockchip") [
  "kmod-drm-rockchip"
  "kmod-saradc-rockchip"
]) ++ (lib.optionals (release != "snapshot" && !(lib.versionAtLeast release "24.00")) [
  "luci-i18n-opkg-zh-cn"
])
