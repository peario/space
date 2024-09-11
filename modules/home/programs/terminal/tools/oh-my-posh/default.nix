{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.terminal.tools.oh-my-posh;
in
{
  # TODO(oh-my-posh): Is this needed?
  options.${namespace}.programs.terminal.tools.oh-my-posh = {
    enable = mkEnableOption "oh-my-posh";
  };

  config = mkIf cfg.enable {
    programs.oh-my-posh = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      package = pkgs.oh-my-posh;
      settings = builtins.fromJSON (
        builtins.unsafeDiscardStringContext (builtins.readFile ./config.json)
      );
    };
  };
}
