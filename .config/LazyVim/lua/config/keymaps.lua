local map = require("util.map")

-- From my experience, use `<cmd>` instead of `:` for commands.
-- Some commands using `:` very briefly shows cmd input/line

-- If using multiple commands in one keybind, then either use:
--  `\|` (escaped bar/pipe symbol) or `<bar>`.
--
-- It's also possible to use multiple commands as how the
--  keybind "<leader>I" ( Fix indentation (buffer) ) has done it.
--
-- see `:help map_bar` for more info.

-- QoL
map.set("i", "jj", "<Esc>", "Enter Normal mode")

map.set("n", "<leader>fs", "<cmd>w<cr>", "Save file")
map.set("n", "U", "<cmd>redo<cr>", "Redo")

map.set("n", "<leader>T", "<cmd>normal! gcc<cr>", "Toggle comment (line)")
map.set("v", "<leader>T", "<cmd>normal! gc<cr>", "Toggle comment (selection)")

map.set({ "n", "x" }, "<C-c>", "<cmd>normal! ciw<cr>", "Change Word")
map.set({ "n", "x" }, "<C-a>", "<cmd>normal! ggVG<cr>", "Select All")

-- Utility
map.set("n", "<leader>cT", "", "Treesitter")
map.set("n", "<leader>cTH", "<cmd>Inspect<cr>", "Highlight group (cursor)")
map.set("n", "<leader>cTT", "<cmd>InspectTree<cr>", "TSPlayground")
