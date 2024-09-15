{ lib, namespace, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.${namespace}.hardware.cpu = {
    enable = mkEnableOption "No-op used for setting up hierarchy";
  };
}
