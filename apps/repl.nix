{ pkgs, ... }:

let
  drv = pkgs.writeShellScriptBin "repl" ''
    nix repl --expr "builtins.getFlake (builtins.toString $(${pkgs.git}/bin/git rev-parse --show-toplevel))"
  '';
in
"${drv}/bin/${drv.name}"
