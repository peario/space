{
  description = "A Nix-flake-based LaTex development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    with flake-utils.lib;
    eachSystem allSystems (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        tex = pkgs.texlive.combine {
          inherit (pkgs.texlive)
            scheme-basic
            latexmk
            pgf
            nicematrix
            fontspec
            ;
        };
        # make variables more visible to defining them here
        vars = [
          "sender"
          "receiver"
        ];
        # expands to definitions like |def|sender{$1}, i.e. each variable
        # will be set to the command line argument at the variable's position.
        texvars = toString (pkgs.lib.imap1 (i: n: ''\def\${n}{${"$" + (toString i)}}'') vars);
      in
      rec {
        shell = ./shell.nix;
        packages = {
          document = pkgs.stdenvNoCC.mkDerivation rec {
            name = "latex-demo-document";
            src = self;
            propagatedBuildInputs = with pkgs; [
              coreutils
              fira-code
              tex
            ];
            phases = [
              "unpackPhase"
              "buildPhase"
              "installPhase"
            ];
            SCRIPT = # bash
              ''
                #!/bin/bash
                prefix=${builtins.placeholder "out"}
                export PATH="${pkgs.lib.makeBinPath propagatedBuildInputs}"
                DIR=$(mktemp -d)
                RES=$(pwd)/document.pdf
                cd $prefix/share
                mkdir -p "$DIR/.texcache/texmf-var"
                env TEXMFHOME="$DIR/.cache" \
                    TEXMFVAR="$DIR/.cache/texmf-var" \
                    OSFONTDIR=${pkgs.fira-code}/share/fonts \
                    latexmk -interaction=nonstopmode -pdf -lualatex \
                    -output-directory="$DIR" \
                    -pretex="\pdfvariable suppressoptionalinfo 512\relax${texvars}" \
                    -usepretex document.tex
                mv "$DIR/document.pdf" $RES
                rm -rf "$DIR"
              '';

            buildPhase = # bash
              ''
                printenv SCRIPT >latex-demo-document
              '';

            installPhase = # bash
              ''
                mkdir -p $out/{bin,share}
                cp document.tex $out/share/document.tex
                cp latex-demo-document $out/bin/latex-demo-document
                chmod u+x $out/bin/latex-demo-document
              '';
          };
        };
        defaultPackage = packages.document;
      }
    );
  # {
  #   devShells = forEachSupportedSystem (
  #     { pkgs }:
  #     {
  #       default = pkgs.mkShell {
  #         packages = with pkgs; [
  #           texlive.combined.scheme-full
  #           texlab
  #           tectonic
  #         ];
  #       };
  #     }
  #   );
  # };
}
