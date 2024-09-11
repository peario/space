{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.suites.social;
in
{
  options.${namespace}.suites.social = {
    enable = mkBoolOpt false "Enable social configuration.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        # NOTE: Currently I don't use any of these
        # "element"
        # "slack"
      ];
    };
  };
}
