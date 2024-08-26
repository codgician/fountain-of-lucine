# GL.iNet MiFi
{ name, pkgs, lib, build, bundles, ... }:

let
  baremetal = true;
  target = "ath79";
  variant = "generic";
  release = "23.05.3";
  packageLists = builtins.mapAttrs
    (k: v: v { inherit lib release target variant baremetal; })
    bundles;
in
build {
  inherit release target variant;
  extraImageName = name;
  profile = "glinet_gl-mifi";
  packages = with packageLists;
    apps ++ celluar ++ common ++ collectd ++ usb;

  files = pkgs.runCommand "image-files" { } ''
    mkdir -p $out/etc/uci-defaults
    cat > $out/etc/uci-defaults/99-custom <<EOF
    uci -q batch << EOI
    set network.lan.ipaddr=192.168.4.1
    commit
    EOI
    EOF
  '';
}