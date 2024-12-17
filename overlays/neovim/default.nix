{ inputs, ... }:
_final: prev:
let
  inherit (prev) lib;

  src = inputs.neovim-src;

  # wasmtime = prev.wasmtime.overrideAttrs (oa: rec {
  #   pname = "wasmtime";
  #   version = "25.0.2";
  #
  #   src = prev.fetchFromGitHub {
  #     owner = "bytecodealliance";
  #     repo = pname;
  #     rev = "v${version}";
  #     hash = "sha256-5Wu5gK3g7nkMDwUGkwnx400PRkb0jknX/GKeEAJ9Vgg=";
  #     fetchSubmodules = true;
  #   };
  #
  #   cargoDeps = oa.cargoDeps.overrideAttrs (
  #     lib.const {
  #       name = "${oa.pname}-vendor.tar.gz";
  #       inherit src;
  #       # Same here as in `src.hash`
  #       outputHash = "sha256-haGEyc67e/nDVC2YA5FPNkarrZX/r69fHM+qRF9avrM=";
  #     }
  #   );
  # });

  deps = lib.pipe "${src}/cmake.deps/deps.txt" [
    builtins.readFile
    (lib.splitString "\n")
    (map (builtins.match "([A-Z0-9_]+)_(URL|SHA256)[[:space:]]+([^[:space:]]+)[[:space:]]*"))
    (lib.remove null)
    (lib.flip builtins.foldl' { } (
      acc: matches:
      let
        name = lib.toLower (builtins.elemAt matches 0);
        key = lib.toLower (builtins.elemAt matches 1);
        value = lib.toLower (builtins.elemAt matches 2);
      in
      acc
      // {
        ${name} = acc.${name} or { } // {
          ${key} = value;
        };
      }
    ))
    (builtins.mapAttrs (lib.const prev.fetchurl))
  ];

  # The following overrides will only take effect for linux hosts
  linuxOnlyOverrides = lib.optionalAttrs (!prev.stdenv.isDarwin) {
    gettext = prev.gettext.overrideAttrs {
      src = deps.gettext;
    };
  };

  overrides = {
    # FIXME: this has been causing problems, see;
    # https://github.com/nix-community/neovim-nightly-overlay/issues/538
    # libuv = prev.libuv.overrideAttrs {
    #   src = deps.libuv;
    # };
    lua = prev.luajit;
    tree-sitter =
      (prev.tree-sitter.override {
        # webUISupport = true;
        rustPlatform = prev.rustPlatform // {
          buildRustPackage =
            args:
            prev.rustPlatform.buildRustPackage (
              args
              // {
                version = "bundled";
                src = deps.treesitter;
                cargoHash = "sha256-i2/VTf/QEWUhFFpDJi94Eui9wFW4J3ziUoIcxVQN+PI=";
              }
            );
        };
      }).overrideAttrs
        (oa: {
          postPatch = ''
            ${oa.postPatch}
            sed -e 's/playground::serve(.*$/println!("ERROR: web-ui is not available in this nixpkgs build; enable the webUISupport"); std::process::exit(1);/' \
                -i cli/src/main.rs
          '';
        });

    treesitter-parsers =
      let
        grammars = lib.filterAttrs (name: _: lib.hasPrefix "treesitter_" name) deps;
      in
      lib.mapAttrs' (
        name: value: lib.nameValuePair (lib.removePrefix "treesitter_" name) { src = value; }
      ) grammars;
  } // linuxOnlyOverrides;
in
{
  neovim-unwrapped = (prev.neovim-unwrapped.override overrides).overrideAttrs (oa: {
    version = "nightly";
    inherit src;

    preConfigure = ''
      ${oa.preConfigure}
      substituteAll cmake.config/versiondef.h.in \
        --replace-fail '@NVIM_VERSION_PRERELEASE@' '-nightly+${inputs.neovim-src.shortRev or "dirty"}'
    '';

    # cmakeFlags = oa.cmakeFlags ++ [
    #   "-DENABLE_WASMTIME=ON"
    #   "-DUSE_BUNDLED_WASMTIME=ON"
    #   "-DUSE_BUNDLED_LIBVTERM=ON"
    #   "-DUSE_BUNDLED_TS=ON"
    # ];

    patches = "";

    # nativeBuildInputs = [ wasmtime ] ++ oa.nativeBuildInputs;
    buildInputs =
      with prev;
      [
        # TODO: remove once upstream nixpkgs updates the base drv
        (utf8proc.overrideAttrs (_: {
          src = deps.utf8proc;
        }))
        # Add for WASM parser support (tree-sitter)
        # wasmer
        # wasmtime
        # wasmtime.dev
      ]
      ++ oa.buildInputs;
  });
}
