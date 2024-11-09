{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    types
    getExe'
    ;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.security.gpg;

  gpgAgentConf = ''
    enable-ssh-support
    default-cache-ttl 60
    max-cache-ttl 120
    pinentry-program ${getExe' pkgs.pinentry-gnome3 "pinentry-gnome3"}
  '';

  reload-yubikey =
    pkgs.writeShellScriptBin "reload-yubikey" # bash
      ''
        ${getExe' pkgs.gnupg "gpg-connect-agent"} "scd serialno" "learn --force" /bye
      '';
in
{
  options.${namespace}.security.gpg = with types; {
    enable = mkEnableOption "GPG";
    agentTimeout = mkOpt int 5 "Amount of time to wait before continuing with shell init.";
  };

  config = mkIf cfg.enable {
    environment.shellInit = # bash
      ''
        ${getExe' pkgs.coreutils "timeout"} ${builtins.toString cfg.agentTimeout} ${getExe' pkgs.gnupg "gpgconf"} --launch gpg-agent
        gpg_agent_timeout_status=$?

        if [ "$gpg_agent_timeout_status" = 124 ]; then
          # Command timed out...
          echo "GPG Agent timed out..."
          echo 'Run "gpgconf --launch gpg-agent" to try and launch it again.'
        fi
      '';

    environment.systemPackages = with pkgs; [
      cryptsetup
      gnupg
      paperkey
      pinentry-curses
      pinentry-qt
      reload-yubikey
    ];

    space = {
      home.file = {
        ".gnupg/gpg-agent.conf".text = gpgAgentConf;
      };
    };

    programs = {
      ssh.startAgent = false;

      gnupg.agent = {
        enable = true;
        enableExtraSocket = true;
        enableSSHSupport = true;
        pinentryPackage = pkgs.pinentry-gnome3;
      };
    };

    services = {
      pcscd.enable = true;
      udev.packages = with pkgs; [ yubikey-personalization ];
    };
  };
}
