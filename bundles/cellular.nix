{
  lib,
  mbim ? false,
  mhi ? false,
  ncm ? false,
  qmi ? false,
  quectel ? false,
  ...
}:

[
  "luci-app-sms-tool-js"
  "luci-i18n-sms-tool-js-zh-cn"
  "luci-app-travelmate"
  "luci-i18n-travelmate-zh-cn"
  "qrencode"

  "luci-proto-modemmanager"
  "luci-proto-3g"

  "kmod-usb3"
  "kmod-usb-net-cdc-ether"
  "kmod-usb-serial-option"
  "kmod-wwan"
]
++ (lib.optionals mbim [
  "luci-proto-mbim"
  "mbim-utils"
  "kmod-usb-net-cdc-mbim"
])
++ (lib.optionals mhi [
  "kmod-mhi-bus"
  "kmod-mhi-net"
  "kmod-mhi-pci-generic"
  "kmod-mhi-wwan-ctrl"
  "kmod-mhi-wwan-mbim"
])
++ (lib.optionals ncm [
  "comgt-ncm"
  "kmod-usb-net-cdc-ncm"
  "kmod-usb-net-huawei-cdc-ncm"
])
++ (lib.optionals qmi [
  "luci-proto-qmi"
  "qmi-utils"
  "kmod-usb-net-qmi-wwan"
])
++ (lib.optionals quectel [
  "luci-proto-quectel"
  "kmod-usb-net-qmi-wwan-quectel"
  "quectel-cm"
])
