# Bundle for USB storage support

{ ... }:

[
  "kmod-usb2"
  "kmod-usb3"
  "usbutils"
  "uhubctl"
  "kmod-fs-ntfs3"
  "ntfs3-mount"
  "exfat-fsck"
  "exfat-mkfs"
  "kmod-fs-exfat"

  "kmod-usb-storage"
  "kmod-usb-storage-extras"
  "kmod-usb-storage-uas"
  "kmod-usb-serial"

  "kmod-usb-acm"
  "kmod-usb-core"
  "kmod-usb-hid"
  "kmod-usb-ehci"
  "kmod-usb-ohci"
  "kmod-usb-uhci"
  "kmod-usb-wdm"

  "kmod-usb-net"
  "kmod-usb-net-ipheth"
  "kmod-usb-net-rndis"
]
