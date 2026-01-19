return {
	"danielfalk/smart-open.nvim",
	branch = "0.2.x",
	lazy = true,
	keys = {
		{
			"<leader>ff",
			function()
				require("telescope").load_extension("smart_open")
				require("telescope").extensions.smart_open.smart_open()
			end,
			desc = "Smart Open",
		},
	},
	dependencies = {
		"kkharji/sqlite.lua",
		"nvim-telescope/telescope.nvim",
	},
}
