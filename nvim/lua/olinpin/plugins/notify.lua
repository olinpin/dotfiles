return {
	"rcarriga/nvim-notify",
	event = "VeryLazy",
	config = function(_, opts)
		require("notify").setup(opts)
		vim.notify = require("notify")
		vim.opt.termguicolors = true
	end,
}
