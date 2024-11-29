{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.suites.business;
in
{
  options.${namespace}.suites.business = {
    enable = mkEnableOption "Business suite";
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        calcurse
        # FIXME: package broken because of dependency textual being broken because of a dependency
        # on tree-sitter-languages being broken because of a dependency on tree-sitter0_21 which is
        # marked as incompatible with python3.12
        dooit
        jrnl
        np
        zathura # PDF viewer
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        libreoffice
        teams-for-linux
      ];

    space = {
      programs = {
        terminal = {
          tools = {
            _1password-cli = enabled;
          };
        };
      };
    };
  };
}
