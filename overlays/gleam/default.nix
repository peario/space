_:
(_final: prev: {
  gleam = prev.gleam.overrideAttrs (oa: rec {
    # NOTE: Updating version requires updating the hash of src and cargoHash
    version = "1.6.2";

    src = prev.fetchFromGitHub {
      owner = "gleam-lang";
      repo = oa.pname;
      rev = "refs/tag/v${version}";
      # For updating hash, leave empty and rebuild config (eg. `flake switch`).
      hash = "sha256-r+iN6eLmy6qnrhvHKUQufd/4mvZL9TCVaqLqEPcLu1E=";
    };

    cargoDeps = oa.cargoDeps.overrideAttrs (
      prev.lib.const {
        name = "${oa.pname}-vendor.tar.gz";
        inherit src;
        # Same here as in `src.hash`
        outputHash = "sha256-btpefSzC7HCPqdtKIkjFaZ6rYVgqqVpQYZaDcImAs9w=";
      }
    );
  });
})
