{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    lists
    ;
  inherit (lib.strings) concatStringsSep;

  npmrcConf = ''
    prefix=~/.npm-packages
  '';

  cfg = config.${namespace}.programs.development.nodejs;
in
{
  options.${namespace}.programs.development.nodejs = {
    enable = mkEnableOption "Node.js (JS and TS)";

    package = mkOption {
      type = types.package;
      default = pkgs.nodejs_20;
      description = "Package to use for Node.js.";
    };

    LSP = {
      enable = mkEnableOption "LSP for Node.js";
      package = mkOption {
        type = types.package;
        default = pkgs.typescript;
        description = "Package for Node.js LSP.";
      };
    };

    formatter = {
      enable = mkEnableOption "Formatters for Node.js";
      package = mkOption {
        type = types.package;
        default = pkgs.nodePackages.prettier;
        description = "Packages for Node.js formatting.";
      };
    };

    linter = {
      enable = mkEnableOption "Linters for Node.js";
      package = mkOption {
        type = types.package;
        default = pkgs.nodePackages.eslint;
        description = "Packages for Node.js linting.";
      };
    };

    other = {
      enable = mkEnableOption "Other tooling for Node.js";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = with pkgs; [
          bun
          yarn
          nodePackages.ts-node
        ];
        description = "Other packages for Node.js.";
      };
    };

    npmPackages = mkOption {
      type = with types; listOf (uniq str);
      default = [ ];
      example = [
        "lite-server"
        "tailwindcss"
      ];
      description = "Packages to install via NPM.";
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages =
        [ cfg.package ]
        ++ lists.optional cfg.LSP.enable cfg.LSP.package
        ++ lists.optional cfg.formatter.enable cfg.formatter.package
        ++ lists.optional cfg.linter.enable cfg.linter.package
        ++ lists.optionals cfg.other.enable cfg.other.packages
        ++ lists.optionals pkgs.stdenv.isLinux (
          with pkgs.jetbrains;
          [
            webstorm
            phpstorm
          ]
        );

      file = {
        ".npmrc".text = npmrcConf;
      };
    };

    programs = mkIf ((builtins.length cfg.npmPackages) > 0) {
      # TODO: Check if this script works
      bash.initExtra = # bash
        ''
          # Add npm packages to path
          export PATH="$HOME/.npm-packages/bin:$PATH"

          # Array to hold missing commands
          missing_commands=()

          # Loop through commands array
          for cmd in ${concatStringsSep " " cfg.npmPackages}; do
            if ! command -v "$cmd" &> /dev/null; then
              # If command doesn't exist, add to missing_commands
              missing_commands+=("$cmd")
            fi
          done

          # Print missing commands
          if [ ''${#missing_commands[@]} -gt 0 ]; then
            # INFO: This installs the missing packages, hides output, pushes errors to a log file
            # and runs it all as a background process
            (npm i -g "''${missing_commands[@]}" >/dev/null 2> ~/.npm-packages/install-errors.log &)
          fi
        '';
      # TODO: Check if this script works
      fish.shellInit = # fish
        ''
          # Add npm packages to path
          fish_add_path -g $HOME/.npm-packages/bin

          # Array of commands to check
          set commands ${concatStringsSep " " cfg.npmPackages}

          # Array to hold missing commands
          set missing_commands

          # Loop through commands array
          for cmd in $commands
              if not command -v $cmd > /dev/null
                  # If command doesn't exist, add to missing_commands
                  set missing_commands $missing_commands $cmd
              end
          end

          # Print missing commands
          if test (count $missing_commands) -gt 0
            # INFO: This installs the missing packages, hides output, pushes errors to a log file
            # and runs it all as a background process
              npm i -g $missing_commands >/dev/null 2> ~/.npm-install-errors.log &
          end
        '';
      zsh.initExtra = # bash
        ''
          # Add npm packages to path
          export PATH="$HOME/.npm-packages/bin:$PATH"

          # Array to hold missing commands
          declare -a missing_commands=()

          # Loop through commands array
          for cmd in ${concatStringsSep " " cfg.npmPackages}; do
            if ! command -v "$cmd" &> /dev/null; then
              # If command doesn't exist, add to missing_commands
              missing_commands+=("$cmd")
            fi
          done

          # Print missing commands
          if [ ''${#missing_commands[@]} -gt 0 ]; then
            # INFO: This installs the missing packages, hides output, pushes errors to a log file
            # and runs it all as a background process
            (npm i -g "''${missing_commands[@]}" >/dev/null 2> ~/.npm-packages/install-errors.log &)
          fi
        '';
    };
  };
}
