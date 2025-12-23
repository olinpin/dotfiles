return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		require("copilot").setup({
			suggestion = {
				enabled = true,
				auto_trigger = true,
				debounce = 150, -- Add debounce to reduce API calls
				keymap = {
					accept = "…",
				},
			},
			panel = {
				enabled = false,
			},
			filetypes = {
				["."] = false,
			},
			server_opts_overrides = {
				-- Reduce timeout-related errors
				settings = {
					advanced = {
						inlineSuggestCount = 3,
					},
				},
			},
		})
	end,
}
