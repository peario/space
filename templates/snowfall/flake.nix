{
  description = "Globe";

  inputs = {
    # NixPkgs (nixos-unstable)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Integrate Git Hooks into Nix
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";

    # Snowfall Lib
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Snowfall Flake
    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      inherit (inputs) snowfall-lib;

      lib = snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;

        snowfall = {
          meta = {
            name = "globe";
            title = "Globe";
          };

          namespace = "globe";
        };
      };
    in
    lib.mkFlake {
      alias = {
        packages = {
          default = "globe";
          nvim = "globe";
        };
      };

      channels-config = {
        allowUnfree = true;
      };

      outputs-builder = channels: { formatter = channels.nixpkgs.nixfmt-rfc-style; };
    };
}
