return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	opts = {
		lsp_fallback = true,

		formatters_by_ft = {
			lua = { "stylua" },

			javascript = { "prettier" },
			css = { "prettier" },
			html = { "prettier" },

			sh = { "shfmt" },

			go = { "goimports", "gofumpt" },
		},

		-- format_on_save = function(bufnr)
		-- 	local filetype = vim.bo[bufnr].filetype
		-- 	if filetype == "javascript" then
		-- 		return nil
		-- 	end
		-- 	if filetype == "vue" then
		-- 		return nil
		-- 	end
		-- 	if filetype == "less" then
		-- 		return nil
		-- 	end
		-- 	if filetype == "php" then
		-- 		return nil
		-- 	end
		--
		-- 	return {
		-- 		timeout_ms = 500,
		-- 		lsp_fallback = true,
		-- 	}
		-- end,
	},
}
