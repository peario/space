{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.suites.vm;
in
{
  options.${namespace}.suites.vm = {
    enable = mkEnableOption "VM suite";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # qemu
      vte
      # FIX: broken nixpkg on darwin
      # libvirt
    ];

    homebrew = {
      taps = [ "arthurk/virt-manager" ];

      casks = [ "utm" ];
    };
  };
}
