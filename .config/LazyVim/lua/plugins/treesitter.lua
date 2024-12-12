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
      --- WARN: Use `metiulekm` (fork) until `RRethy` (original) is fixed
      "metiulekm/nvim-treesitter-endwise",
      -- "RRethy/nvim-treesitter-endwise",
      "andymass/vim-matchup",
    },
  },
  {
    "calops/hmts.nvim",
    version = "*",
  },
}
