require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })

map("n", "<leader>fm", function()
	require("conform").format()
end, { desc = "File Format with conform" })

map("i", "fd", "<ESC>", { desc = "Escape insert mode" })
map("v", "fd", "<ESC>", { desc = "Escape insert mode" })

map("n", "<C-f>", "<cmd>:w<CR>", { desc = "󱕾 Save" })
map("i", "<C-f>", "<cmd>:w<CR>", { desc = "󱕾 Save" })

map("n", "<leader>lg",function() vim.cmd("LazyGit") end, { desc = "LazyGit" })


map("n", "<leader>mp",function() vim.cmd("MarkdownPreview") end, { desc = "MarkdownPreview" })

map("n", "<C-d>","<C-d>zz", { desc = "move down" })
map("n", "<C-u>","<C-u>zz", { desc = "move up" })

map("n", "<C-a>",function() local harpoon = require "harpoon" harpoon:list():append() end, { desc = "󱡁 Harpoon Add file" })
map("n", "<C-t>",function() local harpoon = require "harpoon" harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "󱠿 Harpoon Menu" })
map("n", "<leader>1",function() local harpoon = require "harpoon" harpoon:list():select(1) end, { desc = "󱪼 Navigate to file 1" })
map("n", "<leader>2",function() local harpoon = require "harpoon" harpoon:list():select(2) end, { desc = "󱪼 Navigate to file 2" })
map("n", "<leader>3",function() local harpoon = require "harpoon" harpoon:list():select(3) end, { desc = "󱪼 Navigate to file 3" })
map("n", "<leader>4",function() local harpoon = require "harpoon" harpoon:list():select(4) end, { desc = "󱪼 Navigate to file 4" })
map("n", "<leader>5",function() local harpoon = require "harpoon" harpoon:list():select(5) end, { desc = "󱪼 Navigate to file 5" })
