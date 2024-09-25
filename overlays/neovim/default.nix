{ inputs, ... }:
_final: prev: {
  neovim = prev.neovim.overrideAttrs (_oa: {
    version = "0.10.1";

    src = inputs.neovim-src;
  });
}
