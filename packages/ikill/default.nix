{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "ikill";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "pombadev";
    repo = "ikill";
    rev = "v${version}";
    hash = "sha256-hOQBBwxkVnTkAZJi84qArwAo54fMC0zS+IeYMV04kUs=";
  };

  cargoHash = "sha256-zKa2FP0lBS2XjgPWfyPZ60aHyeAe0uNIFbmuX4Uo1rA=";

  meta = {
    description = "Interactively kill running processes";
    homepage = "https://github.com/pombadev/ikill.git";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "ikill";
  };
}
