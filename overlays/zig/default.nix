_:
(_final: prev: {
  zig = prev.zig.overrideAttrs (oldAttrs: {
    src = prev.fetchFromGitHub {
      owner = "ziglang";
      repo = "zig";
      rev = "0.13.0";
      hash = "sha256-5qSiTq+UWGOwjDVZMIrAt2cDKHkyNPBSAEjpRQUByFM=";
    };

    buildInputs =
      oldAttrs.buildInputs
      ++ (
        with prev;
        [
          libxml2
          zlib
          libclang
          lld

          (prev.llvm.overrideAttrs (_oa: {
            version = "19.0.0-git";
          }))
        ]
        ++ prev.lib.optional prev.stdenv.isDarwin [ prev.apple-sdk_15 ]
      );

    nativeBuildInputs =
      oldAttrs.nativeBuildInputs
      ++ (with prev; [
        (llvm.overrideAttrs (_oa: {
          version = "19.0.0-git";
        })).dev

        (cmake.overrideAttrs (oa: {
          version = "3.30.4";

          src = fetchurl {
            url = "https://cmake.org/files/v${prev.lib.versions.majorMinor oa.version}/cmake-${oa.version}.tar.gz";
            hash = "sha256-x1nJcnTx56qq/LHw0mH53pvzpdbst+LfYWMkpG/nBLI=";
          };
        }))
      ]);
  });
})
