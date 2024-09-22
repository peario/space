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

  llvmPkgs = pkgs.llvmPackages_17;

  cfg = config.${namespace}.programs.development.c;
in
{
  options.${namespace}.programs.development.c = {
    enable = mkEnableOption "C/C++";

    package = mkOption {
      type = types.package;
      default = llvmPkgs.clang; # v17.0.6
      description = "Package to use for C/C++.";
    };

    LSP = {
      enable = mkEnableOption "LSP (and formatter) for C/C++";
      packages = mkOption {
        type = types.package;
        default = llvmPkgs.libclang;
        description = "Package for C/C++ LSP.";
      };
    };

    linter = {
      enable = mkEnableOption "Linters for C/C++";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = with pkgs; [
          cppcheck
          cpplint
        ];
        description = "Packages for C/C++ linting.";
      };
    };

    DAP = {
      enable = mkEnableOption "DAP for C/C++";
      packages = mkOption {
        type = types.package;
        default = pkgs.lldb;
        description = "Packages for C/C++ debugging.";
      };
    };

    buildTools = {
      enable = mkEnableOption "Build tools for C/C++";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = with pkgs; [
          gnumake
          cmake
          bear
          meson
          bison
          ninja
          libpkgconf
          pkg-config
        ];
        description = "Packages for C/C++ compiling and such.";
      };
    };

    docs.enable = mkEnableOption "Man pages for C/C++";

    other = {
      enable = mkEnableOption "Other tooling for C/C++";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = with pkgs; [
          # TODO(sqlite): Create a separate "dev"-module for datastores
          # (with caches like redis-ish included?)
          sqlite

          # other tools
          libllvm

          # C++
          # Clangd from clang-tools must come first.
          # (hiPrio llvmPkgs.clang-tools.override {
          #   # llvmPackages = llvmPkgs;
          #   enableLibcxx = false;
          # })
          # Do note use the clangd from this package as it does not work correctly with
          # stdlib headers.
          # llvmPkgs.libstdcxxClang

          # libs
          glm
          SDL2
          SDL2_gfx
        ];
        description = "Other packages for C/C++.";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages =
        [ cfg.package ]
        ++ lists.optional cfg.LSP.enable cfg.LSP.packages
        ++ lists.optionals cfg.linter.enable cfg.linter.packages
        ++ lists.optional cfg.DAP.enable cfg.DAP.packages
        ++ lists.optionals cfg.docs.enable [ pkgs.clang-manpages ]
        ++ lists.optionals cfg.buildTools.enable cfg.buildTools.packages
        ++ lists.optionals cfg.other.enable cfg.other.packages
        ++ lists.optionals pkgs.stdenv.isLinux (
          with pkgs;
          [
            gdb
            valgrind
            jetbrains.clion
          ]
        );

      sessionVariables = {
        # https://github.com/rust-lang/rust-bindgen#environment-variables
        # LIBCLANG_PATH = lib.makeLibraryPath [ llvmPkgs.libclang.lib ];
        LIBCLANG_PATH = "${llvmPkgs.libclang.lib}/lib";

        # Add glibc, clang, glib, and other headers to bindgen search path
        BINDGEN_EXTRA_CLANG_ARGS = builtins.concatStringsSep " " (
          # Includes normal include path
          (builtins.map (a: ''-I"${a}/include"'') [
            # add dev libraries here (e.g. pkgs.libvmi.dev)
            # pkgs.glibc.dev
          ])
          # Includes with special directory paths
          ++ [
            ''-I"${llvmPkgs.libclang.lib}/lib/clang/${llvmPkgs.libclang.version}/include"''
            ''-I"${pkgs.glib.dev}/include/glib-2.0"''
            ''-I${pkgs.glib.out}/lib/glib-2.0/include/''
          ]
        );
      };
    };
  };
}
