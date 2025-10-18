{ lib, release, ... }:

[
  "luci-app-autoreboot"
  "luci-i18n-autoreboot-zh-cn"
  "luci-app-acl"
  "luci-i18n-acl-zh-cn"
  "miniupnpd-nftables"
  "luci-app-upnp"
  "luci-i18n-upnp-zh-cn"
  "luci-app-acme"
  "luci-i18n-acme-zh-cn"
  "acme-acmesh-dnsapi"
  "luci-app-ddns"
  "luci-i18n-ddns-zh-cn"
  "ddns-scripts-cloudflare"
  "bind-host"
  "luci-app-natmap"
  "luci-i18n-natmap-zh-cn"
  "natmap"
  "luci-app-wol"
  "luci-i18n-wol-zh-cn"
  "luci-app-banip"
  "luci-i18n-banip-zh-cn"
  "luci-app-watchcat"
  "luci-i18n-watchcat-zh-cn"
  "luci-app-uhttpd"
  "luci-i18n-uhttpd-zh-cn"

  "aria2"
  "libopenssl-legacy"
  "screen"
  "wget-ssl"
]
++ (lib.optionals (release == "snapshot" || lib.versionAtLeast release "24.00") [
  "luci-app-irqbalance"
  "luci-i18n-irqbalance-zh-cn"
])
