{
  config,
  inputs,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkBoolOpt mkOpt;

  cfg = config.${namespace}.nix;
in
{
  options.${namespace}.nix = {
    enable = mkBoolOpt true "Manage nix configuration.";
    package = mkOpt lib.types.package pkgs.nixVersions.latest "Which nix package to use.";
  };

  config = lib.mkIf cfg.enable {
    # faster rebuilding
    documentation = {
      doc.enable = false;
      info.enable = false;
      man.enable = lib.mkDefault true;
    };

    environment = {
      etc = with inputs; {
        # set channels (backwards compatibility)
        "nix/flake-channels/system".source = self;
        "nix/flake-channels/nixpkgs".source = nixpkgs;
        "nix/flake-channels/home-manager".source = home-manager;

        # preserve current flake in /etc
        "nixos/flake".source = lib.mkIf pkgs.stdenv.isLinux self;
      };

      systemPackages = with pkgs; [
        cachix
        deploy-rs
        git
        nix-prefetch-git
      ];
    };

    nix =
      let
        mappedRegistry = lib.pipe inputs [
          (lib.filterAttrs (_: lib.isType "flake"))
          (lib.mapAttrs (_: flake: { inherit flake; }))
          (
            x:
            x
            // {
              nixpkgs.flake = if pkgs.stdenv.isLinux then inputs.nixpkgs else inputs.nixpkgs-unstable;
            }
          )
          (x: if pkgs.stdenv.isDarwin then lib.removeAttrs x [ "nixpkgs-unstable" ] else x)
        ];

        users = [
          "root"
          "@wheel"
          "nix-builder"
          config.${namespace}.user.name
        ];
      in
      {
        inherit (cfg) package;

        distributedBuilds = true;

        gc = {
          automatic = true;
          options = "--delete-older-than 7d";
        };

        # This will additionally add your inputs to the system's legacy channels
        # Making legacy nix commands consistent as well
        nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

        optimise.automatic = true;

        # pin the registry to avoid downloading and evaluating a new nixpkgs version every time
        # this will add each flake input as a registry to make nix3 commands consistent with your flake
        registry = mappedRegistry;

        settings = {
          allowed-users = users;
          auto-optimise-store = pkgs.stdenv.isLinux;
          builders-use-substitutes = true;
          # TODO: pipe-operators throws annoying warnings
          experimental-features = [
            "nix-command "
            " flakes"
          ];
          flake-registry = "/etc/nix/registry.json";
          http-connections = 50;
          keep-derivations = true;
          keep-going = true;
          keep-outputs = true;
          log-lines = 50;
          sandbox = true;
          trusted-users = users;
          warn-dirty = false;

          substituters = [
            "https://cache.nixos.org"
            "https://space.cachix.org"
            "https://nix-community.cachix.org"
            "https://nixpkgs-unfree.cachix.org"
            "https://numtide.cachix.org"
          ];

          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "space.cachix.org-1:3mthjI+T4B8dAu6Q2fn4/2Lqcywg4F0n12m9K2y3PlU="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
            "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
          ];

          use-xdg-base-directories = true;
        };
      };

    programs.ssh.knownHosts = {
      "aarch64.nixos.community".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMUTz5i9u5H2FHNAmZJyoJfIGyUm/HfGhfwnc142L3ds";
      "darwin-build-box.nix-community.org".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFz8FXSVEdf8FvDMfboxhB5VjSe7y2WgSa09q1L4t099";
    };
  };
}
