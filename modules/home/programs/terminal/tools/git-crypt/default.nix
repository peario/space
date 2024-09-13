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

  cfg = config.${namespace}.programs.terminal.tools.git-crypt;
in
{
  options.${namespace}.programs.terminal.tools.git-crypt = {
    enable = mkBoolOpt false "Enable git-crypt.";
  };

  config = mkIf cfg.enable { home.packages = with pkgs; [ git-crypt ]; };
}
