require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })

map("n", "<leader>fm", function()
	require("conform").format()
end, { desc = "File Format with conform" })

map("n", "<C-f>", "<cmd>:w<CR>", { desc = "󱕾 Save" })
map("i", "<C-f>", "<cmd>:w<CR>", { desc = "󱕾 Save" })

map("n", "<leader>lg", function()
	vim.cmd("LazyGit")
end, { desc = "LazyGit" })

map("n", "<leader>mp", function()
	vim.cmd("MarkdownPreview")
end, { desc = "MarkdownPreview" })

map("n", "<C-d>", "<C-d>zz", { desc = "move down" })
map("n", "<C-u>", "<C-u>zz", { desc = "move up" })

map("n", "<C-a>", function()
	local harpoon = require("harpoon")
	harpoon:list():append()
end, { desc = "󱡁 Harpoon Add file" })
map("n", "<C-t>", function()
	local harpoon = require("harpoon")
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "󱠿 Harpoon Menu" })
map("n", "<leader>1", function()
	local harpoon = require("harpoon")
	harpoon:list():select(1)
end, { desc = "󱪼 Navigate to file 1" })
map("n", "<leader>2", function()
	local harpoon = require("harpoon")
	harpoon:list():select(2)
end, { desc = "󱪼 Navigate to file 2" })
map("n", "<leader>3", function()
	local harpoon = require("harpoon")
	harpoon:list():select(3)
end, { desc = "󱪼 Navigate to file 3" })
map("n", "<leader>4", function()
	local harpoon = require("harpoon")
	harpoon:list():select(4)
end, { desc = "󱪼 Navigate to file 4" })
map("n", "<leader>5", function()
	local harpoon = require("harpoon")
	harpoon:list():select(5)
end, { desc = "󱪼 Navigate to file 5" })

map("n", "<leader>x", "<cmd>:q<CR>", { desc = "quit" })

map("n", "<leader>bc", "<cmd>:vs<CR>", { desc = "clone window" })
map("n", "<leader>bw", require("functions.window").swap_windows, { desc = "Swap windows" })

-- override
map("n", "<leader>b", "", { desc = "override" })
map("n", "<tab>", "", { desc = "override" })

map("n", "<leader>dc", require("functions.dbt").dbt_compile, { desc = "dbt compile" })
map("n", "<leader>df", require("functions.dbt").dbt_format, { desc = "dbt format" })
map("n", "<leader>dl", require("functions.dbt").dbt_lineage, { desc = " dbt lineage" })
map("n", "<leader>dr", require("functions.dbt").dbt_run, { desc = " dbt run" })
map("n", "<leader>dt", require("functions.dbt").dbt_show_table, { desc = " dbt show table" })
map("n", "<leader>dj", require("functions.dbt").dbt_show_json, { desc = " dbt show json" })
map("n", "<leader>de", require("functions.dbt").dbt_run_full_refresh, { desc = " dbt run full refresh" })
