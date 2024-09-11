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

  cfg = config.${namespace}.programs.terminal.tools.fzf;
in
{
  options.${namespace}.programs.terminal.tools.fzf = {
    enable = mkBoolOpt false "Enable fzf.";
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
        "--pointer=' '"
        "--pointer=' '"
        "--header-first"
        "--border=rounded"
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
