return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      endwise = {
        enable = true,
      },
      matchup = {
        enable = true,
        disable = {},
      },
      autotag = {
        enable = true,
      },
    },
    dependencies = {
      "RRethy/nvim-treesitter-endwise",
      "andymass/vim-matchup",
    },
  },
}
