{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) types mkIf;
  inherit (lib.${namespace}) mkBoolOpt mkOpt;

  cfg = config.${namespace}.system.fonts;
in
{
  options.${namespace}.system.fonts = with types; {
    enable = mkBoolOpt false "Manage fonts.";
    fonts =
      with pkgs;
      mkOpt (listOf package) [
        # Desktop Fonts
        corefonts # MS fonts
        b612 # high legibility
        material-icons
        material-design-icons
        work-sans
        comic-neue
        source-sans
        inter
        lexend

        # Main fonts
        # cascadia-code
        fira-code
        fira-code-symbols
        iosevka
        jetbrains-mono
        # monaspace
        victor-mono

        # Emojis
        noto-fonts-color-emoji
        twemoji-color-font

        # Nerd Fonts
        # See https://github.com/NixOS/nixpkgs/issues/359731
        nerd-fonts.caskaydia-cove
        nerd-fonts.hasklug
        nerd-fonts.lilex
        nerd-fonts.monaspace
        nerd-fonts.symbols-only
      ] "Custom font packages to install.";
    default = mkOpt types.str "Hasklug Nerd Font" "Default font name";
  };

  config = mkIf cfg.enable {
    environment.variables = {
      # Enable icons in tooling since we have nerdfonts.
      LOG_ICONS = "true";
    };
  };
}
