{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.suites.photo;
in
{
  options.${namespace}.suites.photo = {
    enable = mkBoolOpt false "Enable photo configuration.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [ "digikam" ];
    };
  };
}
