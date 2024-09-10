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
    azureEnable = mkBoolOpt false "Enable azure development configuration.";
    dockerEnable = mkBoolOpt false "Enable docker development configuration.";
    gameEnable = mkBoolOpt false "Enable game development configuration.";
    goEnable = mkBoolOpt false "Enable go development configuration.";
    kubernetesEnable = mkBoolOpt false "Enable kubernetes development configuration.";
    nixEnable = mkBoolOpt false "Enable nix development configuration.";
    sqlEnable = mkBoolOpt false "Enable sql development configuration.";
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
        ++ lib.optionals cfg.nixEnable [
          nixpkgs-hammering
          nixpkgs-lint-community
          nixpkgs-review
          nix-update
        ]
        ++ lib.optionals cfg.gameEnable [
          godot_4
          # NOTE: removed from nixpkgs
          # ue4
          unityhub
        ]
        ++ lib.optionals cfg.sqlEnable [
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
            azure.enable = cfg.azureEnable;
            git-crypt = enabled;
            # go.enable = cfg.goEnable;
            k9s.enable = cfg.kubernetesEnable;
            lazydocker.enable = cfg.dockerEnable;
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
