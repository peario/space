{
  pkgs ? import <nixpkgs> { },
}:
let
  inherit (pkgs) mkShell;
in
mkShell {
  packages = with pkgs; [
    texlive.combined.scheme-full
    texlab
    tectonic
  ];
}
