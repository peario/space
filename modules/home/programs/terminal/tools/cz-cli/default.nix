{
  config,
  lib,
  pkgs,
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
    home = {
      # NOTE: Testing to install via `development/nodejs/default.nix` with a conditional like `mkIf cfg.enable`.
      # packages = with pkgs; [ cz-cli ];

      file = mkIf pkgs.stdenv.isDarwin { ".czrc".text = commitizenConf; };
    };

    xdg.configFile = mkIf pkgs.stdenv.isLinux { ".czrc".text = commitizenConf; };

    ${namespace}.programs.development.nodejs.npmPackages =
      lists.optionals config.${namespace}.programs.development.nodejs.enable
        [
          "commitizen"
          "cz-conventional-changelog"
        ];
  };
}
