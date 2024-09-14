{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.suites.development;
in
{
  options.${namespace}.suites.development = {
    enable = mkBoolOpt false "Enable common development configuration.";
    azure.enable = mkBoolOpt false "Enable azure development configuration.";
    docker.enable = mkBoolOpt false "Enable docker development configuration.";
    game.enable = mkBoolOpt false "Enable game development configuration.";
    kubernetes.enable = mkBoolOpt false "Enable kubernetes development configuration.";
    nix.enable = mkBoolOpt false "Enable nix development configuration.";
    sql.enable = mkBoolOpt false "Enable sql development configuration.";
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
          nix-init
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
            enable = false;

            other = enabled;
          };
          nodejs = {
            enable = true;

            LSP = enabled;
            other = enabled;
          };
          python = {
            enable = false;

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
          };
        };
      };
    };
  };
}
