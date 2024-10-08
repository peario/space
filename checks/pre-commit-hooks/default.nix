{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (inputs) pre-commit-hooks;
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
      clang-format.enable = true;

      # linter
      # FIX: clang-tidy doesn't work on macOS.
      # Currently disabled on macOS but functional on other OS/architectures.
      clang-tidy.enable = if pkgs.stdenv.isDarwin && pkgs.stdenv.isAarch64 then false else true;

      # ==> GitHub and other <==
      # Linter for GitHub Workflows
      actionlint.enable = true;

      # Warns about submodules in commits
      forbid-new-submodules.enable = true;

      # Make sure unencrypted files aren't accidentally commited that are related to sops
      pre-commit-hook-ensure-sops.enable = true;

      # ==> JSON <==
      # formatter
      pretty-format-json.enable = false;

      # linter
      check-json.enable = true;

      # ==> Lua <==
      # formatter
      stylua.enable = true;

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
      nixfmt-rfc-style.enable = true;

      # linter
      statix.enable = true;

      # ==> Shells; Bash, ZSH, etc. <==
      # formatter
      beautysh.enable = true;

      # ==> TOML <==
      # formatter
      taplo_fmt.enable = false;

      # linter
      check-toml.enable = true;

      # ==> YAML <==
      # formatter
      yamlfmt.enable = false;

      # linter
      yamllint.enable = true;

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
      # conform.enable = true;
    };
}
