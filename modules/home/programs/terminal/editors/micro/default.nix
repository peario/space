{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.terminal.editors.micro;
in
{
  options.${namespace}.programs.terminal.editors.micro = {
    enable = mkEnableOption "micro";
    default = {
      editor = mkEnableOption "Set micro as the session ${lib.env}`EDITOR`.";
      visual = mkEnableOption "Set micro as the session ${lib.env}`VISUAL`.";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      micro = {
        enable = true;

        settings = {
          colorscheme = "catppuccin-macchiato";
        };
      };

      bash.shellAliases.vimdiff = mkIf cfg.default "micro -d";
      fish.shellAliases.vimdiff = mkIf cfg.default "micro -d";
      zsh.shellAliases.vimdiff = mkIf cfg.default "micro -d";
    };

    home.sessionVariables = {
      EDITOR = mkIf cfg.default.editor "micro";
      VISUAL = mkIf cfg.default.visual "micro";
    };

    xdg.configFile."micro/colorschemes" = {
      source = lib.cleanSourceWith {
        filter =
          name: _type:
          let
            baseName = baseNameOf (toString name);
          in
          lib.hasSuffix ".micro" baseName;
        src = lib.cleanSource ./.;
      };

      recursive = true;
    };
  };
}
