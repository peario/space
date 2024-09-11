{ mkShell, pkgs, ... }:
mkShell {
  packages = with pkgs; [
    cargo
    clippy
    rust-analyzer
    rustc
    rustfmt
  ];

  shellHook = # bash
    ''
      echo 🔨 DevShell for Rust
    '';
}
