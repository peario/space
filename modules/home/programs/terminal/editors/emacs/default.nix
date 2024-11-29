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
    mkDefault
    lists
    getExe'
    ;
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.${namespace}) enabled;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (pkgs) fetchpatch;

  doomBinaries = # bash
    ''
      export PATH="$PATH:$HOME/.config/emacs/bin"
    '';

  cfg = config.${namespace}.programs.terminal.editors.emacs;
in
{
  options.${namespace}.programs.terminal.editors.emacs = {
    enable = mkEnableOption "Emacs";
    daemon.enable = mkEnableOption "Enable use of `emacsclient`";
    doom.enable = mkEnableOption "Enable Emacs framework; Doom Emacs";
    default = {
      editor = mkEnableOption "Set Emacs (or emacsclient) as the session ${lib.env}`EDITOR`.";
      visual = mkEnableOption "Set Emacs (or emacsclient) as the session ${lib.env}`VISUAL`.";
    };
  };

  config = mkIf cfg.enable {
    launchd = mkIf (cfg.daemon.enable && pkgs.stdenv.isDarwin) {
      enable = true;
      agents = {
        emacs = {
          enable = true;
          config = {
            ProgramArguments = [
              "${getExe' pkgs.emacs29-pgtk "emacs"}"
              "--daemon"
            ];
            # ServiceDescription = "GNU Emacs Daemon";
            KeepAlive = false;
            RunAtLoad = true;
            # ProcessType = "Interactive";
          };
        };
      };
    };

    services.emacs = mkIf (cfg.daemon.enable && !pkgs.stdenv.isDarwin) {
      enable = true;
      package = pkgs.emacs;
      client = enabled;
    };

    programs = mkIf cfg.doom.enable {
      bash.initExtra = doomBinaries;
      fish.shellInit = doomBinaries;
      zsh.initExtra = doomBinaries;
    };

    home = {
      shellAliases = mkIf cfg.daemon.enable {
        # emacs = mkDefault "${
        #   if pkgs.stdenv.isDarwin then
        #     (getExe' pkgs.emacs29-pgtk "emacsclient")
        #   else
        #     (getExe' pkgs.emacs "emacsclient")
        # } -nc -a ''";
        emacs = mkDefault "${
          if pkgs.stdenv.isDarwin then
            (getExe' pkgs.emacs29-pgtk "emacsclient")
          else
            (getExe' pkgs.emacs "emacsclient")
        } -nc -a ''";
      };

      sessionVariables =
        { }
        // optionalAttrs pkgs.stdenv.isDarwin {
          EDITOR = mkIf cfg.default.editor "${
            if cfg.daemon.enable then
              (getExe' pkgs.emacs29-pgtk "emacsclient")
            else
              (getExe' pkgs.emacs29-pgtk "emacs")
          } -t";
          VISUAL = mkIf cfg.default.visual "${
            if cfg.daemon.enable then
              (getExe' pkgs.emacs29-pgtk "emacsclient")
            else
              (getExe' pkgs.emacs29-pgtk "emacs")
          } -nc -a ''";
        }
        // optionalAttrs (!pkgs.stdenv.isDarwin) {
          EDITOR = mkIf cfg.default.editor "${
            if cfg.daemon.enable then (getExe' pkgs.emacs "emacsclient") else (getExe' pkgs.emacs "emacs")
          } -t";
          VISUAL = mkIf cfg.default.visual "${
            if cfg.daemon.enable then (getExe' pkgs.emacs "emacsclient") else (getExe' pkgs.emacs "emacs")
          } -nc -a ''";
        };

      packages =
        with pkgs;
        [
          shellcheck
          pandoc
        ]
        ++ lists.optionals pkgs.stdenv.isLinux [ pkgs.emacs ]
        ++ lists.optionals pkgs.stdenv.isDarwin [
          (pkgs.emacs29-pgtk.overrideAttrs (oa: {
            patches = (oa.patches or [ ]) ++ [
              # Fix OS window role (needed for window managers like yabai)
              (fetchpatch {
                url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/fix-window-role.patch";
                sha256 = "sha256-+z/KfsBm1lvZTZNiMbxzXQGRTjkCFO4QPlEK35upjsE=";
              })
              # Use poll instead of select to get file descriptors
              (fetchpatch {
                url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-29/poll.patch";
                sha256 = "sha256-jN9MlD8/ZrnLuP2/HUXXEVVd6A+aRZNYFdZF8ReJGfY=";
              })
              # Enable rounded window with no decoration
              (fetchpatch {
                url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-29/round-undecorated-frame.patch";
                sha256 = "sha256-uYIxNTyfbprx5mCqMNFVrBcLeo+8e21qmBE3lpcnd+4=";
              })
              # Make Emacs aware of OS-level light/dark mode
              (fetchpatch {
                url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/system-appearance.patch";
                sha256 = "sha256-oM6fXdXCWVcBnNrzXmF0ZMdp8j0pzkLE66WteeCutv8=";
              })
            ];
          }))
        ];
    };

    # NOTE: Use `xdg.configFile` for files at `$HOME/.config`
    xdg.configFile =
      { }
      // optionalAttrs (!cfg.doom.enable) {
        "emacs".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${namespace}/.config/.emacs";
      }
      # Depending on if Doom Emacs is enabled, change symlinks for emacs config
      // optionalAttrs cfg.doom.enable {
        "emacs".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${namespace}/.config/emacs.doom";
        "doom".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${namespace}/.config/doom";
      };
  };
}
