{
  lib,
  quectel ? false,
  mhi ? true,
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
  "luci-proto-mbim"
  "luci-proto-qmi"

  "comgt-ncm"
  "qmi-utils"
  "mbim-utils"

  "kmod-usb3"
  "kmod-usb-net-cdc-mbim"
  "kmod-usb-net-cdc-ether"
  "kmod-usb-net-cdc-mbim"
  "kmod-usb-net-cdc-ncm"
  "kmod-usb-net-huawei-cdc-ncm"
  "kmod-usb-net-qmi-wwan"
  "kmod-usb-serial-option"
]
++ (lib.optionals quectel [
  "luci-proto-quectel"
  "kmod-usb-net-qmi-wwan-quectel"
  "quectel-cm"
])
++ (lib.optionals mhi [
  "kmod-mhi-bus"
  "kmod-mhi-net"
  "kmod-mhi-pci-generic"
  "kmod-mhi-wwan-ctrl"
  "kmod-mhi-wwan-mbim"
])