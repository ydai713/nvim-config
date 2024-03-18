local options = {
	lsp_fallback = true,

	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		javascript = { { "prettierd", "prettier" } },
		typescript = { { "prettierd", "prettier" } },
		javascriptreact = { { "prettierd", "prettier" } },
		typescriptreact = { { "prettierd", "prettier" } },
		terraform = { "terraform_fmt" },
	},
}

require("conform").setup(options)
