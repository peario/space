{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.hardware.yubikey;
in
{
  options.${namespace}.hardware.yubikey = {
    enable = mkEnableOption "Yubikey";
  };

  config = mkIf cfg.enable {
    hardware.gpgSmartcards.enable = true;

    environment.systemPackages = with pkgs; [
      # Yubico's official tools
      yubikey-manager # cli
      yubikey-manager-qt # gui
      yubikey-personalization # cli
      yubikey-personalization-gui # gui
      yubico-piv-tool # cli
      #yubioath-flutter # gui
    ];

    programs = {
      ssh.startAgent = false;
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };

    services = {
      pcscd.enable = true;
      udev.packages = [ pkgs.yubikey-personalization ];
      yubikey-agent.enable = true;
    };
  };
}
