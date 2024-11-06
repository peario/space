_:
(_final: prev: {
  gleam = prev.gleam.overrideAttrs (_oa: rec {
    # NOTE: Updating version requires updating the hash of src and cargoHash
    version = "1.5.1";

    src = prev.fetchFromGitHub {
      owner = "gleam-lang";
      repo = "gleam";
      rev = "v${version}";
      # For updating hash, leave empty and rebuild config (eg. `flake switch`).
      hash = "sha256-4/NDZGq62M0tdWerIkmoYS0WHC06AV8c9vlo/6FhsAo=";
    };
  });
})
