return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			json = { "prettier" },
			css = { "prettier" },
			html = { "prettier" },
			sh = { "shfmt" },
			go = { "goimports", "gofumpt" },
			php = { "php-cs-fixer" },
			python = { "black" },
		},

		format_on_save = false,

		default_format_opts = { lsp_fallback = true },
	},

	config = function(_, opts)
		require("conform").setup(opts)

		-- manual formatting keymap
		vim.keymap.set({ "n", "x" }, "=", function()
			require("conform").format({
				async = true,
				lsp_fallback = true,
			})
		end, { desc = "Format file or range" })
	end,
}
