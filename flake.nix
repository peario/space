{
  description = "Peario's Space";

  inputs = {
    # A customizable runner
    anyrun.url = "github:anyrun-org/anyrun";
    anyrun-nixos-options.url = "github:n3oney/anyrun-nixos-options";

    # Theme - Catppuccin
    catppuccin-cursors.url = "github:catppuccin/cursors";
    catppuccin.url = "github:catppuccin/nix";

    # macOS Support (master)
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disk Management via Nix
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # System Deployment
    deploy-rs = {
      url = "github:serokell/deploy-rs";
    };

    # GPG default configuration
    gpg-base-conf = {
      url = "github:drduh/config";
      flake = false;
    };

    # Home Manager (master)
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## ==> Hyprland
    aquamarine = {
      url = "github:hyprwm/aquamarine";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

      inputs = {
        # url = "git+https://github.com/khaneliman/Hyprland?ref=windows&submodules=1";
        nixpkgs.follows = "nixpkgs";
        aquamarine.follows = "aquamarine";
        xdph.follows = "xdg-desktop-portal-hyprland";
        hyprwayland-scanner.follows = "hyprwayland-scanner";
        hyprlang.follows = "hyprlang";
        hyprutils.follows = "hyprutils";
      };
    };

    xdg-desktop-portal-hyprland = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hypridle = {
      url = "github:hyprwm/Hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprlang = {
      url = "github:hyprwm/hyprlang";

      inputs = {
        nixpkgs.follows = "hyprland/nixpkgs";
        hyprutils.follows = "hyprutils";
      };
    };

    hyprlock = {
      # url = "git+file:///home/khaneliman/Documents/github/hypridle";
      url = "github:hyprwm/Hyprlock";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprutils = {
      url = "github:hyprwm/hyprutils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprwayland-scanner = {
      url = "github:hyprwm/hyprwayland-scanner";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland socket watcher
    hypr-socket-watch = {
      url = "github:khaneliman/hypr-socket-watch";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim Nightly (overlay)
    # neovim-nightly-overlay = {
    #   url = "github:nix-community/neovim-nightly-overlay";
    # };

    # Neovim source code (for overlay)
    neovim-src = {
      url = "github:neovim/neovim";
      flake = false;
    };

    # Secure boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Weekly updating nix-index database
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixPkgs (nixos-unstable)
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    # NixPkgs (nixpkgs-unstable)
    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };

    # Build system images and artifacts supported by nixos-generators.
    # nixos-generators = {
    #   url = "github:nix-community/nixos-generators";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # NixOS WSL Support
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Run unpatched dynamically compiled binaries
    nix-ld-rs = {
      url = "github:nix-community/nix-ld-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix User Repository (master)
    nur = {
      url = "github:nix-community/NUR";
    };

    # Pre commit hooks
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
    };

    # Snowfall lib
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Snowfall flakes
    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Sops (Secrets)
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Spicetify
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    waybar = {
      url = "github:Alexays/Waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Yubikey Guide
    yubikey-guide = {
      url = "github:drduh/YubiKey-Guide";
      flake = false;
    };

    wezterm = {
      url = "github:wez/wezterm?dir=nix";
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
            name = "space";
            title = "Space";
          };

          namespace = "space";
        };
      };
    in
    lib.mkFlake {
      channels-config = {
        allowBroken = true; # for 1Password
        allowUnfree = true;

        permittedInsecurePackages = [ ];
      };

      overlays = with inputs; [
        # Use the overlay provided by this flake.
        snowfall-flake.overlays."package/flake"
      ];

      homes.modules = with inputs; [
        anyrun.homeManagerModules.default
        catppuccin.homeManagerModules.catppuccin
        hypr-socket-watch.homeManagerModules.default
        nix-index-database.hmModules.nix-index
        nur.hmModules.nur
        sops-nix.homeManagerModules.sops
        spicetify-nix.homeManagerModules.default
      ];

      systems = {
        modules = {
          nixos = with inputs; [
            lanzaboote.nixosModules.lanzaboote
            sops-nix.nixosModules.sops
          ];
        };
      };

      templates = {
        rust.description = "Rust template";
        snowfall.description = "Snowfall-lib template";
      };

      deploy = lib.mkDeploy { inherit (inputs) self; };

      outputs-builder = channels: { formatter = channels.nixpkgs.nixfmt-rfc-style; };
    };
}
