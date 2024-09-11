{
  description = "Rust Project Template";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell.url = "github:numtide/devshell";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      perSystem =
        { config, pkgs, ... }:
        {
          packages = {
            # INFO: `rust-app` can be changed to whatever you wish
            default = config.packages.rust-app;
            rust-app = pkgs.callPackage ./default.nix { };
          };

          devShells.default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [ pkg-config ];

            buildInputs =
              with pkgs;
              [
                rustup
                glib
              ]
              ++ lib.optionals stdenv.isDarwin [
                darwin.apple_sdk.frameworks.CoreFoundation
                darwin.apple_sdk.frameworks.CoreServices
              ];
          };
        };
    };
  # let
  #   systems = [
  #     "x86_64-linux"
  #     "aarch64-linux"
  #   ];
  #   forEachSystem = nixpkgs.lib.genAttrs systems;
  #
  #   pkgsForEach = nixpkgs.legacyPackages;
  # in
  # rec {
  #   packages = forEachSystem (system: {
  #     default = pkgsForEach.${system}.callPackage ./default.nix { };
  #   });
  #
  #   devShells = forEachSystem (system: {
  #     default = pkgsForEach.${system}.callPackage ./shell.nix { };
  #   });
  #
  #   hydraJobs = packages;
  # };
}
