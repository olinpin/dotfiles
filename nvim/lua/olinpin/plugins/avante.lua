return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	lazy = false,
	config = function(_, opts)
		require("avante").setup(opts)
		-- Then remove the default mappings
		vim.schedule(function()
			vim.keymap.del({ "n", "v" }, "<leader>aa")
			vim.keymap.del("n", "<leader>ar")
			vim.keymap.del("v", "<leader>ae")
			vim.keymap.del("n", "<leader>ah")
			vim.keymap.del("n", "<leader>ad")
			vim.keymap.del("n", "<leader>af")
			vim.keymap.del("n", "<leader>aR")
			vim.keymap.del("n", "<leader>as")
			vim.keymap.del("n", "<leader>at")
			vim.keymap.del("n", "<leader>a?")
			vim.keymap.del("n", "<leader>aB")
			vim.keymap.del("n", "<leader>aS")
			vim.keymap.del("n", "<leader>an")
			vim.keymap.del("n", "<leader>aC")
			vim.keymap.del("n", "<leader>az")
		end)
	end,
	opts = {
		-- add any opts here
		provider = "copilot",
		providers = {
			copilot = {
				model = "claude-sonnet-4",
				-- max_tokens = 4096,
			},
		},
		system_prompt = function()
			local hub = require("mcphub").get_hub_instance()
			return hub and hub:get_active_servers_prompt() or ""
		end,
		-- Using function prevents requiring mcphub before it's loaded
		custom_tools = function()
			return {
				require("mcphub.extensions.avante").mcp_tool(),
			}
		end,
	},
	build = "make",
	keys = {
		{
			"<leader>ca",
			function()
				require("avante.api").ask()
			end,
			desc = "avante: ask",
			mode = { "n", "v" },
		},
		{
			"<leader>cr",
			function()
				require("avante.api").refresh()
			end,
			desc = "avante: refresh",
		},
		{
			"<leader>ce",
			function()
				require("avante.api").edit()
			end,
			desc = "avante: edit",
			mode = "v",
		},
		{
			"<leader>ch",
			function()
				require("avante.api").hint()
			end,
			desc = "avante: hint",
			mode = "n",
		},
		{
			"<leader>cd",
			function()
				require("avante.api").debug()
			end,
			desc = "avante: debug",
			mode = "n",
		},
	},
	dependencies = {
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		-- "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		{
			-- Make sure to setup it properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			-- "zbirenbaum/copilot.lua", -- for providers='copilot'
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}
