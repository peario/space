{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.terminal.editors.helix;
in
{
  imports = lib.snowfall.fs.get-non-default-nix-files ./.;

  options.${namespace}.programs.terminal.editors.helix = {
    enable = mkEnableOption "Helix";
    default = {
      editor = mkEnableOption "Set Helix as the session ${lib.env}`EDITOR`.";
      visual = mkEnableOption "Set Helix as the session ${lib.env}`VISUAL`.";
    };
  };

  config = mkIf cfg.enable {
    programs.helix = {
      enable = true;
      package = pkgs.helix.overrideAttrs (self: {
        makeWrapperArgs =
          with pkgs;
          self.makeWrapperArgs or [ ]
          ++ [
            "--suffix"
            "PATH"
            ":"
            (lib.makeBinPath [
              clang-tools
              marksman
              nil
              nixfmt-rfc-style
              bash-language-server
              vscode-langservers-extracted
              nodePackages.prettier
              rustfmt
              rust-analyzer
              shellcheck
            ])
          ];
      });

      settings = {
        editor = {
          bufferline = "multiple";
          color-modes = true;
          completion-replace = true;
          cursorline = true;

          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "block";
          };

          gutters = [
            "diagnostics"
            "line-numbers"
            "spacer"
            "diff"
          ];

          idle-timeout = 1;

          indent-guides = {
            render = true;
            rainbow-option = "dim";
          };

          line-number = "relative";

          lsp = {
            display-messages = true;
            display-inlay-hints = true;
          };

          mouse = true;
          rulers = [ 80 ];
          scrolloff = 5;

          statusline = {
            separator = "";
            left = [
              "mode"
              "selections"
              "spinner"
              "file-name"
              "total-line-numbers"
            ];
            center = [ ];
            right = [
              "diagnostics"
              "file-encoding"
              "file-line-ending"
              "file-type"
              "position-percentage"
              "position"
            ];
            mode = {
              normal = "NORMAL";
              insert = "INSERT";
              select = "SELECT";
            };
          };

          whitespace.characters = {
            space = "·";
            nbsp = "⍽";
            tab = "→";
            newline = "⤶";
          };

          soft-wrap.enable = true;
          true-color = true;
        };

        keys.normal = {
          esc = [
            "collapse_selection"
            "keep_primary_selection"
          ];
          space.u = {
            f = ":format"; # format using LSP formatter
            w = ":set whitespace.render all";
            W = ":set whitespace.render none";
          };
        };
      };
    };

    home.sessionVariables = {
      EDITOR = mkIf cfg.default.editor "hx";
      VISUAL = mkIf cfg.default.visual "hx";
    };
  };
}
