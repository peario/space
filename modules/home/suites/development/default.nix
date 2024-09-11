{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.suites.development;
in
{
  options.${namespace}.suites.development = {
    enable = mkEnableOption "Common dev suite";
    azure.enable = mkEnableOption "Azure development suite";
    docker.enable = mkEnableOption "Docker development suite";
    game.enable = mkEnableOption "Game development suite";
    go.enable = mkEnableOption "Go development suite";
    kubernetes.enable = mkEnableOption "Kubernetes development suite";
    nix.enable = mkEnableOption "Nix development suite";
    sql.enable = mkEnableOption "SQL development suite";
  };

  config = mkIf cfg.enable {
    home = {
      packages =
        with pkgs;
        [
          jqp
          neovide
          onefetch
          postman
          vscode
        ]
        ++ lib.optionals pkgs.stdenv.isLinux [
          github-desktop
          qtcreator
        ]
        ++ lib.optionals cfg.nix.enable [
          nixpkgs-hammering
          nixpkgs-lint-community
          nixpkgs-review
          nix-update
        ]
        ++ lib.optionals cfg.game.enable [
          godot_4
          # NOTE: removed from nixpkgs
          # ue4
          unityhub
        ]
        ++ lib.optionals cfg.sql.enable [
          dbeaver-bin
          mysql-workbench
        ];

      shellAliases = {
        prefetch-sri = "nix store prefetch-file $1";
      };
    };

    space = {
      programs = {
        development = {
          c = {
            enable = true;

            LSP = enabled;
            # DAP = enabled;
            other = enabled;
          };
          erlang = {
            enable = true;

            other = enabled;
          };
          go = enabled;
          lua = {
            enable = true;

            other = enabled;
          };
          nodejs = {
            enable = true;

            LSP = enabled;
            other = enabled;
          };
          python = {
            enable = true;

            other = enabled;
          };
          rust = {
            enable = true;

            other = enabled;
          };
        };

        graphical = {
          editors = {
            vscode = enabled;
          };
        };

        terminal = {
          editors = {
            # helix = enabled;
            neovim = {
              enable = true;
              defaultEditor = true;
              defaultVisual = true;
            };
          };

          tools = {
            azure.enable = cfg.azure.enable;
            git-crypt = enabled;
            k9s.enable = cfg.kubernetes.enable;
            lazydocker.enable = cfg.docker.enable;
            lazygit = enabled;
            # oh-my-posh = enabled;
            # FIXME: broken nixpkg
            # prisma = enabled;
          };
        };
      };
    };
  };
}
