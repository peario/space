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
    direnv
    git
    gh
    ripgrep
    fd
    fzf
    silicon
    node2nix
    treefmt2

    # Security
    age
    ssh-to-age
    gnupg
    sops

    # Neovim
    inputs.neovim-nightly-overlay.packages.${pkgs.system}.default

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
    nixpkgs-hammering
    nixpkgs-lint
    snowfall-flake.packages.${system}.flake

    # Adds all the packages required for the pre-commit checks
    inputs.self.checks.${system}.pre-commit-hooks.enabledPackages

    # Formatters used in `treefmt.toml`
    # - cbfmt, clang-format, deadnix, fixjson, gofumpt, goimports-reviser, stylua, markdownlint-cli2,
    # nixfmt-rfc-style, prettierd, ruff, rustfmt, taplo, yamlfmt
    cbfmt
    # clang-format is part of a larger collection of tools
    deadnix
    nodePackages.fixjson
    gofumpt
    goimports-reviser
    stylua
    markdownlint-cli2
    nixfmt-rfc-style
    prettierd
    ruff
    rustfmt
    taplo
    yamlfmt
  ];

  shellHook = # zsh
    ''
      # Setup direnv
      eval "$(direnv hook bash)"
      eval "$(direnv allow)"

      # The other stuff
      ${inputs.self.checks.${system}.pre-commit-hooks.shellHook}
      echo "Welcome to ${namespace}!"
    '';
}
