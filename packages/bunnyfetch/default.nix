{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "bunnyfetch";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Rosettea";
    repo = "bunnyfetch";
    rev = "v${version}";
    hash = "sha256-6MnjCXc9/8twdf8PHKsVJY1yWYwUf5R01vtQFJbyy7M=";
  };

  vendorHash = "sha256-w+O1dU8t7uNvdlFnYhCdJCDixpWWZAnj9GrtsCbu9SM=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tiny system info fetch utility";
    homepage = "https://github.com/Rosettea/bunnyfetch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "bunnyfetch";
  };
}
