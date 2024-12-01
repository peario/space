{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (inputs) pre-commit-hooks;

  # Shorthand enable/disable.
  # Cleaner syntax.
  enabled = {
    enable = true;
  };
  disabled = {
    enable = false;
  };
in
pre-commit-hooks.lib.${pkgs.system}.run {
  src = ./.;
  hooks =
    let
      excludes = [
        "flake.lock"
        "CHANGELOG.md"
      ];
      fail_fast = true;
      verbose = true;
    in
    {
      # ==> C and C++ <==
      # formatter
      clang-format = enabled;

      # linter
      # FIX: clang-tidy doesn't work on macOS.
      # clang-tidy.enable = if pkgs.stdenv.isDarwin && pkgs.stdenv.isAarch64 then false else true;
      clang-tidy.enable = mkIf (!pkgs.stdenv.isDarwin && !pkgs.stdenv.isAarch64) true;

      # ==> GitHub and other <==
      # Linter for GitHub Workflows
      actionlint = enabled;

      # Warns about submodules in commits
      forbid-new-submodules = enabled;

      # Make sure unencrypted files aren't accidentally commited that are related to sops
      pre-commit-hook-ensure-sops = enabled;

      # ==> JSON <==
      # formatter
      pretty-format-json = disabled;

      # linter
      check-json = {
        enable = true;

        excludes = [ "emacs\\.doom.*\\.json" ];
      };

      # ==> Lua <==
      # formatter
      stylua = {
        enable = true;

        files = "\\.lua$";

        # NOTE: Relative path from `flake.nix` or project root
        excludes = [ "emacs\\.doom.*\\.lua" ];
      };

      # ==> Nix <==
      # remove unused vars
      deadnix = {
        enable = true;

        settings = {
          # yes alert about unused vars, don't modify them
          edit = false;
        };
      };

      # formatter
      nixfmt-rfc-style = {
        enable = true;

        excludes = [ "emacs\\.doom.*\\.nix" ];
      };

      # linter
      statix = {
        # FIX: statix command ignores `excludes` and `settings.ignore` values.
        enable = false;

        # excludes = [ "emacs\\.doom.*\\.nix" ];

        settings = {
          ignore = [ ".config/emacs.doom" ];
        };
      };

      # ==> Shells; Bash, ZSH, etc. <==
      # formatter
      beautysh = {
        enable = true;

        excludes = [ "emacs\\.doom\/bin\/.*" ];
      };

      # ==> TOML <==
      # formatter
      taplo_fmt = disabled;

      # linter
      check-toml = {
        enable = true;

        excludes = [ "emacs\\.doom.*\\.toml" ];
      };

      # ==> YAML <==
      # formatter
      yamlfmt = disabled;

      # linter
      yamllint = {
        enable = true;

        excludes = [
          "\\.sops\\.yaml"
          "secrets.*\\.yaml"
          "secrets.*\\.yml"
        ];
      };

      # ==> Web development <==
      # linter
      # FIX: currently doesn't work
      eslint = {
        enable = false;

        description = "pre-commit hook for eslint";
        settings = {
          binPath = "${lib.getExe pkgs.eslint_d}";
        };
      };

      # formatter
      prettier = {
        enable = true;
        inherit excludes fail_fast verbose;

        description = "pre-commit hook for prettier";
        settings = {
          binPath = "${lib.getExe pkgs.prettierd}";
          single-attribute-per-line = true;
          trailing-comma = "es5";
          write = true;
        };
      };

      # ==> Other

      # TODO: Figure out what this is for
      # INFO: Conform is used for formatting in neovim, maybe related?
      # conform.enable = true;
    };
}
