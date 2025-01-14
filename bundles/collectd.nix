{ lib, baremetal, ... }:

[
  "luci-app-statistics"
  "luci-i18n-statistics-zh-cn"
  "collectd-mod-netlink"
  "collectd-mod-irq"
  "collectd-mod-disk"
  "collectd-mod-cpu"
  "collectd-mod-cpufreq"
  "collectd-mod-df"
  "collectd-mod-interface"
  "collectd-mod-processes"
  "collectd-mod-uptime"
  "collectd-mod-vmem"
  "collectd-mod-email"
  "collectd-mod-ethstat"
  "collectd-mod-conntrack"
  "collectd-mod-dhcpleases"
  "collectd-mod-syslog"
  "collectd-mod-write-http"
  "collectd-mod-ping"
  "collectd-mod-dns"
  "collectd-mod-memory"
]
++ (lib.optionals baremetal [
  "collectd-mod-thermal"
  "collectd-mod-sensors"
  "collectd-mod-smart"
  "smartmontools"
  "smartmontools-drivedb"
])
