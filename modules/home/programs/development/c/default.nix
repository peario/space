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
    mkOption
    types
    lists
    ;
  inherit (lib.${namespace}) mkBoolOpt;

  llvmPkgs = pkgs.llvmPackages_12;

  cfg = config.${namespace}.programs.development.c;
in
{
  options.${namespace}.programs.development.c = {
    enable = mkBoolOpt false "Enable C/C++.";

    # package = mkPackageOption pkgs "clang" { };
    package = mkOption {
      type = types.package;
      default = pkgs.clang;
      description = "Package to use for C/C++.";
    };

    LSP = {
      enable = mkBoolOpt false "Enable LSP (and formatter) support for C/C++.";
      packages = mkOption {
        type = types.package;
        default = llvmPkgs.libstdcxxClang;
        description = "Package for C/C++ LSP.";
      };
    };

    linter = {
      enable = mkBoolOpt false "Enable linters for C/C++.";
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
      enable = mkBoolOpt false "Enable DAP for C/C++.";
      packages = mkOption {
        type = types.package;
        default = llvmPkgs.lldb;
        description = "Packages for C/C++ debugging.";
      };
    };

    other = {
      enable = mkBoolOpt false "Enable other tooling for C/C++.";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = with pkgs; [
          # build tools
          gnumake
          cmake
          bear
          meson
          bison
          ninja
          # libpkgconf
          pkg-config
          openssl
          # TODO(sqlite): Create a separate "dev"-module for datastores (with caches like redis-ish included?)
          sqlite

          # fix headers not found
          # WARN: Uncommenting this may cause RUST installs to fail!
          # clang-tools

          # other tools
          llvmPkgs.libllvm
          # WARN: Uncommenting this may cause RUST installs to fail!
          # llvmPkgs.bintools

          # man pages
          # llvm-manpages
          # clang-manpages

          # stdlib for cpp
          llvmPkgs.libcxx
          # llvm.libcxxStdenv

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
        lists.optional cfg.LSP.enable cfg.LSP.packages
        ++ lists.optionals cfg.linter.enable cfg.linter.packages
        ++ lists.optional cfg.DAP.enable cfg.DAP.packages
        ++ lists.optionals cfg.other.enable cfg.other.packages
        ++ lists.optionals pkgs.stdenv.isLinux [
          pkgs.gdb
          pkgs.valgrind
        ];

      sessionVariables = {
        # https://github.com/rust-lang/rust-bindgen#environment-variables
        LIBCLANG_PATH = pkgs.lib.makeLibraryPath [ llvmPkgs.libclang.lib ];
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
