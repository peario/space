{ mkShell, pkgs, ... }:
mkShell {
  packages = with pkgs; [
    go
    revive
    gopls
    delve
    gotools
    gofumpt
  ];

  shellHook = # bash
    ''
      echo 🔨 DevShell for Go
    '';
}
