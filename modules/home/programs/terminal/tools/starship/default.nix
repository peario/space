{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.terminal.tools.starship;
in
{
  options.${namespace}.programs.terminal.tools.starship = {
    enable = mkBoolOpt false "Enable starship.";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      package = pkgs.starship;

      settings = {
        add_newline = true;

        format = ''
          $directory
          $character
        '';

        palette = "bamboo";
        palettes = {
          bamboo = {
            black = "#3a3d37";
            red = "#f08080"; # coral
            green = "#8fb573";
            yellow = "#e2c792"; # bg yellow
            blue = "#68aee8"; # bg blue
            magenta = "#aaaaff";
            cyan = "#70c2be";
            white = "#f1e9dc";
          };
          onenord = {
            black = "#3B4252";
            red = "#BF616A";
            green = "#A3BE8C";
            yellow = "#EBCB8B";
            blue = "#81A1C1";
            magenta = "#B988B0";
            cyan = "#88C0D0";
            white = "#E5E9F0";
            orange = "#D08F70";
          };
          catppuccin_frappe = {
            black = "#414559";
            red = "#e78284";
            green = "#a6d189";
            yellow = "#e5c890";
            blue = "#8caaee";
            magenta = "#ca9ee6";
            cyan = "#85c1dc";
            white = "#c6d0f5";
            orange = "#ef9f76";
          };
        };

        character = {
          success_symbol = "[ ](green)";
          error_symbol = "[ ](red)";
          vimcmd_symbol = "[ ](green)";
          vimcmd_replace_one_symbol = "[ ](magenta)";
          vimcmd_replace_symbol = "[ ](magenta)";
          vimcmd_visual_symbol = "[ ](yellow)";
        };

        directory = {
          truncation_length = 4;
          style = "magenta";
        };

        # directory = {
        #   style = "cyan";
        #   read_only_style = "red";
        #   read_only = "";
        # };
        #
        # git_branch = {
        #   format = "[$symbol$branch(:$remote_branch)]($style)";
        #   symbol = " ";
        #   style = "magenta";
        # };
        #
        # git_status = {
        #   format = "( \\([$all_status$ahead_behind]($style)\\))";
        #   style = "red";
        # };

        package = {
          disabled = true;
        };
      };
    };
  };
}
