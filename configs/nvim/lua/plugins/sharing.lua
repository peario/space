return {
  -- Screenshot tool
  {
    "michaelrommel/nvim-silicon",
    lazy = true,
    cmd = "Silicon",
    opts = {
      -- For handling "WSL2" environment
      wslclipboard = "auto",
      -- Title of code window
      window_title = function()
        local api = vim.api
        local buf_name = api.nvim_buf_get_name(api.nvim_get_current_buf())

        return vim.fn.fnamemodify(buf_name, ":t")
      end,
      -- Syntax highlighting
      language = function()
        local api = vim.api
        local buf_ft = vim.bo.filetype
        local buf_name = api.nvim_buf_get_name(api.nvim_get_current_buf())

        return buf_ft ~= nil and buf_ft or vim.fn.fnamemodify(buf_name, ":e")
      end,
      -- Colors
      background = "#7289DA",
      -- font = "Victor Mono",
      -- theme = "OneNord",
      -- Other styling options
      tab_width = 2,
    },
    config = function(_, opts)
      require("nvim-silicon").setup(opts)
    end,
    keys = {
      { "<leader>S", "", desc = "Screenshot", mode = "v" },
      {
        "<leader>Sd",
        function()
          require("nvim-silicon").shoot()
          vim.cmd([[delmark h]]) -- if a `h` mark is set (for highlight), delete it
        end,
        desc = "Take screenshot",
        mode = "v",
      },
      {
        "<leader>Ss",
        function()
          require("nvim-silicon").file()
          vim.cmd([[delmark h]]) -- if a `h` mark is set (for highlight), delete it
        end,
        desc = "Save screenshot as file",
        mode = "v",
      },
      {
        "<leader>SS",
        function()
          require("nvim-silicon").clip()
          vim.cmd([[delmark h]]) -- if a `h` mark is set (for highlight), delete it
        end,
        desc = "Save screenshot to clipboard",
        mode = "v",
      },
      -- This keymap sets the mark `h` on the cursors current row which Silicon then registers as a highlighted line.
      { "<leader>S", "<cmd>normal mh<cr>", desc = "Create highlight for screenshot", mode = "n" },
    },
  },
}
