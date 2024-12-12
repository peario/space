{
  inputs,
  mkShell,
  pkgs,
  system,
  namespace,
  ...
}:
let
  inherit (inputs) snowfall-flake;
in
mkShell {
  packages = with pkgs; [
    # Development tools
    neovim-unwrapped
    direnv
    git
    gh

    # Searching
    ripgrep
    fd
    fzf

    # Editor
    neovim

    # Security
    age
    ssh-to-age
    gnupg
    sops

    # Nix related tools
    hydra-check
    nix-inspect
    nix-bisect
    nix-diff
    nix-health
    nix-index
    # FIX: broken nixpkgs
    # nix-melt
    nix-prefetch-git
    nix-search-cli
    nix-tree
    nixfmt-rfc-style
    nixpkgs-hammering
    nixpkgs-lint
    snowfall-flake.packages.${system}.flake

    # Adds all the packages required for the pre-commit checks
    inputs.self.checks.${system}.pre-commit-hooks.enabledPackages
  ];

  shellHook = # bash
    ''
      # Setup direnv
      eval "$(direnv hook bash)"
      eval "$(direnv allow)"

      # The other stuff
      ${inputs.self.checks.${system}.pre-commit-hooks.shellHook}
      echo "Welcome to ${namespace}!"
    '';
}
