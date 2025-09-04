return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	requires = { "nvim-tree/nvim-web-devicons", opt = true },
	init = function()
		local lualine = require("lualine")
		local custom_ayu_mirage = require("lualine.themes.ayu_mirage")
		custom_ayu_mirage.normal.c.bg = "#172c35"
		lualine.setup({
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
			options = {
				theme = custom_ayu_mirage,
			},
		})
	end,
}
