{
  inputs,
  lib,
  namespace,
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
      actionlint.enable = true;
      clang-format.enable = true;
      # FIX: clang-tidy doesn't work on macOS.
      # Currently disabled on macOS but functional on other OS/architectures.
      clang-tidy.enable = if pkgs.stdenv.isDarwin && pkgs.stdenv.isAarch64 then false else true;

      # conform.enable = true;

      deadnix = {
        enable = true;

        settings = {
          edit = true;
        };
      };

      eslint = {
        enable = true;
        package = pkgs.eslint_d;
      };

      git-cliff = {
        enable = false;
        inherit excludes fail_fast verbose;

        always_run = true;
        description = "pre-push hook for git-cliff";
        entry = "${lib.getExe pkgs.${namespace}.git-cliff}";
        language = "system";
        stages = [ "pre-push" ];
      };

      luacheck.enable = true;

      nixfmt-rfc-style.enable = true;

      pre-commit-hook-ensure-sops.enable = true;

      prettier = {
        enable = true;
        inherit excludes fail_fast verbose;

        description = "pre-commit hook for prettier";
        settings = {
          binPath = "${lib.getExe pkgs.prettierd}";
          write = true;
        };
      };

      shfmt = {
        enable = true;

        excludes = [ ".*.p10k.zsh$" ];
      };

      statix.enable = true;
      # treefmt.enable = true;
    };
}
