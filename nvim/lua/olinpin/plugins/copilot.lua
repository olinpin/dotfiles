return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		require("copilot").setup({
            -- get the node path from env variable $NODE_PATH if it's set
            -- copilot_node_command = "/Users/oliverhnat/.nvm/versions/node/v22.21.1/bin/node",
            copilot_node_command = os.getenv("NODE_PATH"),
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
