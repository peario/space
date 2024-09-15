{ lib, namespace, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.${namespace}.hardware.gpu = {
    enable = mkEnableOption "No-op for setting up hierarchy";
  };
}
