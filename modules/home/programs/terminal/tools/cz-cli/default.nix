{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption lists;

  commitizenConf = # json
    ''
      {
        "path": "cz-conventional-changelog"
      }
    '';

  cfg = config.${namespace}.programs.terminal.tools.commitizen;
in
{
  options.${namespace}.programs.terminal.tools.commitizen = {
    enable = mkEnableOption "Commitizen CLI";
  };

  config = mkIf cfg.enable {
    home.file = {
      ".czrc".text = commitizenConf;
    };

    ${namespace}.programs.development.nodejs.npmPackages =
      lists.optionals config.${namespace}.programs.development.nodejs.enable
        [
          "commitizen"
          "cz-conventional-changelog"
        ];
  };
}
