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

  cfg = config.${namespace}.programs.terminal.tools.go;
in
{
  # TODO(languages): Consider extracting programming languages into it's own category.
  options.${namespace}.programs.terminal.tools.go = {
    enable = mkBoolOpt false "Enable Go support.";
  };

  config = mkIf cfg.enable {
    home = {
      # TODO(go): Figure out if LSP, formatters, linters, etc. fit in here as well.
      # Maybe add as an option (`cfg.linters`, `cfg.formatters`, etc.)?
      packages = with pkgs; [
        go
        gopls
      ];

      sessionVariables = {
        GOPATH = "$HOME/work/go";
      };
    };
  };
}
