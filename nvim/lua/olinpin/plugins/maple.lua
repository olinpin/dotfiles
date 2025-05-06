return {
	"forest-nvim/maple.nvim",
	config = function()
		require("maple").setup({
			keymaps = {
				toggle = "<leader>m",
				close = "q",
				switch_mode = "m",
			}
		})
	end,
}
