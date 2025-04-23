return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	requires = { "nvim-tree/nvim-web-devicons", opt = true },
	opts = {
		options = {
			theme = "ayu_mirage",
		},
		section_separators = { left = "", right = "" },
		component_separators = { left = "", right = "" },
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff", "diagnostics" },
			lualine_c = {
				{
					"filename",
					file_status = true,
					path = 1,
					shorting_target = 40,
				},
			},
			lualine_x = { "filetype" },
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
	},
}
