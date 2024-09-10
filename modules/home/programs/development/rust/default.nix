{ config, lib, pkgs, namespace, ... }:
let
  inherit (lib) mkIf mkOption mkEnableOption mkPackageOption types;

  cfg = config.${namespace}.programs.development.rust;
in {
  options.${namespace}.programs.development.rust = {
    enable = mkEnableOption "Enable Rust.";

    package = mkPackageOption pkgs "rustup" { };

    # TODO(rust): Implement nested options
    other = {
      enable = mkEnableOption "Enable other tooling for Rust.";
      packages = mkOption {
        type = with types; listOf package;
        default = with pkgs; [ ];
        description = "Other packages for Rust.";
      };
    };

    cargoHome = mkOption {
      type = types.str;
      default = ".cargo";
      description = ''
        Sets {env}`CARGO_HOME` relative to {env}`HOME`.
      '';
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = [ cfg.package ];

      sessionVariables = {
        CARGO_HOME = "${config.home.homeDirectory}/${cfg.cargoHome}";
        PATH = builtins.concatStringsSep ":" [
          "$PATH"
          "${config.home.homeDirectory}/${cfg.cargoHome}/bin"
        ];
      };
    };
  };
}
