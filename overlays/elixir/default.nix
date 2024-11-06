_:
(_final: prev: {
  elixir = prev.elixir.overrideAttrs (_oa: rec {
    # NOTE: Updating version requires updating the hash of src and cargoHash
    version = "1.17.3";

    # URL: https://github.com/elixir-lang/elixir/releases/tag/v1.17.3
    src = prev.fetchFromGitHub {
      owner = "elixir-lang";
      repo = "elixir";
      rev = "v${version}";
      # For updating hash, leave empty and rebuild config (eg. `flake switch`).
      hash = "sha256-7Qo6y0KAQ9lwD4oH+7wQ4W5i6INHIBDN9IQAAsYzNJw=";
    };
  });
})
