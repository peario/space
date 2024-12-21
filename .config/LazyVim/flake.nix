{
  description = "A Nix-flake-based Python development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { flake-parts, nixpkgs, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        {
          self,
          config,
          self',
          inputs',
          pkgs,
          system,
          lib,
          ...
        }:
        {
          # use fenix overlay
          _module.args.pkgs = import nixpkgs {
            inherit system;
            overlays = [ inputs.fenix.overlays.default ];
          };

          # define the default dev environment
          devShells.default = pkgs.mkShell {
            name = "LazyVim";
            venvDir = ".venv";
            packages =
              with pkgs;
              [
                gcc
                fenix.complete.toolchain
                rust-analyzer-nightly
                nix-update
              ]
              ++ (with python312Packages; [
                python
                pip
                sympy
                venvShellHook
              ]);
          };
        };
    };
}
