{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.terminal.tools.fzf;
in
{
  options.${namespace}.programs.terminal.tools.fzf = {
    enable = mkEnableOption "fzf";
  };

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;

      defaultCommand = "${lib.getExe pkgs.fd} --type=f --hidden --exclude=.git";
      defaultOptions = [
        "--layout=reverse" # Top-first.
        "--exact" # Substring matching by default, `'`-quote for subsequence matching.
        "--bind=alt-p:toggle-preview,alt-a:select-all"
        "--multi"
        "--no-mouse"
        "--info=inline"

        # Style and widget layout
        "--ansi"
        "--with-nth=1.."
        "--pointer='> '"
        "--header-first"
        "--border=rounded"

        # Colors - Rose Pine Moon
        # "--color=fg:#908caa,bg:#232136,hl:#ea9a97"
        # "--color=fg+:#e0def4,bg+:#393552,hl+:#ea9a97"
        "--color=border:#44415a,header:#3e8fb0,gutter:#232136"
        "--color=spinner:#f6c177,info:#9ccfd8"
        "--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"
      ];

      # TODO(zsh): Research why ZSH integration might be disabled.
      enableBashIntegration = true;
      enableZshIntegration = false;
      enableFishIntegration = true;

      tmux = {
        enableShellIntegration = true;
      };
    };
  };
}
