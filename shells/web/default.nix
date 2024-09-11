{ mkShell, pkgs, ... }:
mkShell {
  packages = with pkgs; [
    nodejs_20
    typescript
    nodePackages.prettier
    nodePackages.eslint
    nodePackages.ts-node
    yarn
    bun
  ];

  shellHook = # bash
    ''
      echo 🔨 DevShell for Web development
    '';
}
