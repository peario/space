_:
(_final: prev: {
  kitty = prev.kitty.overrideAttrs (_oa: rec {
    version = "0.37.0";

    src = prev.fetchFromGitHub {
      owner = "kovidgoyal";
      repo = "kitty";
      rev = "refs/tags/v${version}";
      hash = "sha256-xxM5nqEr7avtJUlcsrA/KXOTxSajIg7kDQM6Q4V+6WM=";
    };

    inherit
      (prev.buildGo123Module {
        pname = "kitty-go-modules";
        inherit src version;
        vendorHash = "sha256-d5jRhOm53HDGnsU5Lg5tVGU/9z8RGqORzS53hOyIKBk=";
      })
      goModules
      ;

    # INFO: Kitty nix-shell
    buildInputs =
      with prev;
      (
        [
          (harfbuzz.override { withCoreText = stdenv.isDarwin; })
          python3Packages.matplotlib
          ncurses
          lcms2
          xxHash
          simde
          go_1_23
          (nerdfonts.override {
            fonts = [ "NerdFontsSymbolsOnly" ];
          })
        ]
        ++ lib.optionals stdenv.isDarwin (
          with darwin.apple_sdk.frameworks;
          [
            Cocoa
            CoreGraphics
            Foundation
            IOKit
            Kernel
            OpenGL
            UniformTypeIdentifiers
            libpng
            python3
            zlib
          ]
        )
        ++
          lib.optionals
            (stdenv.isDarwin && (builtins.hasAttr "UserNotifications" darwin.apple_sdk.frameworks))
            [
              darwin.apple_sdk.frameworks.UserNotifications
            ]
        ++ lib.optionals stdenv.isLinux [
          fontconfig
          libunistring
          libcanberra
          libX11
          libXrandr
          libXinerama
          libXcursor
          libxkbcommon
          libXi
          libXext
          wayland-protocols
          wayland
          openssl
          dbus
        ]
        ++ checkInputs
      );

    nativeBuildInputs =
      with prev;
      [
        installShellFiles
        ncurses
        pkg-config
        go_1_23
        fontconfig
        makeBinaryWrapper
      ]
      ++ (with python3Packages; [
        furo
        sphinx
        sphinx-copybutton
        sphinxext-opengraph
        sphinx-inline-tabs
        wrapPython
      ])
      ++ lib.optionals stdenv.isDarwin [
        imagemagick
        libicns # For the png2icns tool.
        darwin.autoSignDarwinBinariesHook
      ];

    propagatedBuildInputs = with prev; lib.optional stdenv.isLinux libGL;

    preCheck = null;

    checkInputs = with prev; [ python3Packages.pillow ];

    nativeCheckInputs =
      with prev;
      [
        python3Packages.pillow

        # Shells needed for shell integration tests
        bashInteractive
        zsh
        fish
      ]
      ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
        # integration tests need sudo
        sudo
      ];

    # Causes build failure due to warning when using Clang
    hardeningDisable = [ "strictoverflow" ];
  });
})

# { pkgs ? import <nixpkgs> { } }:
# with pkgs; let
#   inherit (lib) optional optionals;
#   inherit (xorg) libX11 libXrandr libXinerama libXcursor libXi libXext;
#   inherit (darwin.apple_sdk.frameworks) Cocoa CoreGraphics Foundation IOKit Kernel OpenGL UniformTypeIdentifiers;
#   harfbuzzWithCoreText = harfbuzz.override { withCoreText = stdenv.isDarwin; };
# in
# with python3Packages;
# mkShell rec {
#   buildInputs =
#     [
#       harfbuzzWithCoreText
#       ncurses
#       lcms2
#       xxHash
#       simde
#       matplotlib
#       go_1_23
#       (nerdfonts.override {
#         fonts = [ "NerdFontsSymbolsOnly" ];
#       })
#     ]
#     ++ optionals stdenv.isDarwin [
#       Cocoa
#       CoreGraphics
#       Foundation
#       IOKit
#       Kernel
#       OpenGL
#       UniformTypeIdentifiers
#       libpng
#       python3
#       zlib
#     ]
#     ++ lib.optionals (stdenv.isDarwin && (builtins.hasAttr "UserNotifications" darwin.apple_sdk.frameworks)) [
#       darwin.apple_sdk.frameworks.UserNotifications
#     ]
#     ++ optionals stdenv.isLinux [
#       fontconfig
#       libunistring
#       libcanberra
#       libX11
#       libXrandr
#       libXinerama
#       libXcursor
#       libxkbcommon
#       libXi
#       libXext
#       wayland-protocols
#       wayland
#       openssl
#       dbus
#     ]
#     ++ checkInputs;
#
#   nativeBuildInputs =
#     [
#       installShellFiles
#       ncurses
#       pkg-config
#       sphinx
#       furo
#       sphinx-copybutton
#       sphinxext-opengraph
#       sphinx-inline-tabs
#       go_1_23
#       fontconfig
#       makeBinaryWrapper
#     ]
#     ++ optionals stdenv.isDarwin [
#       imagemagick
#       libicns # For the png2icns tool.
#       darwin.autoSignDarwinBinariesHook
#     ];
#
#   shellHook =
#     if stdenv.isDarwin
#     then ''
#       export KITTY_NO_LTO=
#     ''
#     else ''
#       export KITTY_EGL_LIBRARY='${lib.getLib libGL}/lib/libEGL.so.1'
#       export KITTY_STARTUP_NOTIFICATION_LIBRARY='${libstartup_notification}/lib/libstartup-notification-1.so'
#       export KITTY_CANBERRA_LIBRARY='${libcanberra}/lib/libcanberra.so'
#     '';
# }
#
