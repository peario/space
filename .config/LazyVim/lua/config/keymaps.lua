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

-- Technically, this command can be split into multiple parts;
-- "normal!", "mz", "gg=G", "`z" and "delmarks z".
--
--   1. "normal!"     Makes nvim register the command as if a user pressed each keys
--   2. "mz"          Creates mark with id "z" (like bookmark for that row and col)
--   3. "gg=G"        Re-indents the entire buffer (gg first line, = reindent, G last line)
--   4. "`z"          Jump to position of mark "z"
--   5. "delmarks z"  Deletes mark "z"
map.set(
  "n",
  "<leader>I",
  "<cmd>normal! mzgg=G`z<cr><cmd>delmarks z<cr>",
  "Fix indentation (buffer)"
)

map.set("n", "<leader>C", "<cmd>normal! zz<cr>", "Center window around cursor")

-- Utility
map.set("n", "<leader>cT", "", "Treesitter")
map.set("n", "<leader>cTH", "<cmd>Inspect<cr>", "Highlight group (cursor)")
map.set("n", "<leader>cTT", "<cmd>InspectTree<cr>", "TSPlayground")
