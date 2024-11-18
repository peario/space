{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.suites.common;
in
{
  imports = [ (lib.snowfall.fs.get-file "modules/shared/suites/common/default.nix") ];

  config = mkIf cfg.enable {
    programs.zsh.enable = true;

    homebrew = {
      brews = [
        "bashdb"
        "gnu-sed"
      ];
    };

    environment = {
      # NOTE: DEPRECATED, keep in case of change
      # loginShell = pkgs.zsh;

      systemPackages = with pkgs; [
        bash-completion
        cask
        # FIX: broken package
        # duti
        fasd
        gawk
        gnugrep
        gnupg
        gnused
        gnutls
        haskellPackages.sfnt2woff
        intltool
        keychain
        pkgs.${namespace}.trace-symlink
        pkgs.${namespace}.trace-which
        pkgs.${namespace}.bunnyfetch
        mas
        moreutils
        # FIXME: broken nixpkgs
        # ncdu
        pigz
        rename
        spice-gtk
        terminal-notifier
        trash-cli
        tree
        wtf
      ];
    };

    space = {
      nix = enabled;

      tools = {
        homebrew = enabled;
      };

      system = {
        fonts = enabled;
        input = enabled;
        interface = enabled;
        networking = enabled;
      };
    };
  };
}
