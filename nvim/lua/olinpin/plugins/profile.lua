return {
	{
		"Kurama622/profile.nvim",
		config = function()
			local comp = require("profile.components")

			require("profile").setup({
				avatar_opts = {
					force_blank = false,
				},
				disable_keys = {},
				cursor_pos = { 17, 48 },
				format = function()
					local header = {
						[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣴⣶⣶⣶⣶⣦⣤⡀⠀⠀⠀⠀]],
						[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⠟⠉⠉⠉⠉⠉⠛⠻⢿⣷⣄⠀⠀]],
						[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⠟⠁⠀⠀⢠⣤⣄⠀⠀⠀⠀⠙⣿⣷⠀]],
						[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⠏⠀⠀⠀⠀⠘⠻⠋⠀⠀⠀⠀⠀⢸⣿⡇]],
						[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⡏⠀⠀⣀⣀⣀⣠⣤⣤⣤⣤⣿⣄⠀⢠⣿⣧]],
						[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⠀⠀⠀⠈⠻⣿⣶⠶⣶⣤⣤⣜⣿⣦⡈⢿⣿]],
						[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠀⠀⠀⠀⠀⠈⠙⠻⢶⣤⣭⣛⣿⣿⣷⣼⣿]],
						[[⠀⠀⠀⠀⠀⣰⣶⣾⠿⠿⢿⣷⣶⣄⠀⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠛⠛⢛⣿⣿]],
						[[⠀⠀⠀⠀⠀⢹⣿⣆⠀⠀⠀⠈⠻⢿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⡏]],
						[[⠀⠀⠀⠀⠀⣸⣿⣿⠀⠀⠀⠀⠀⠀⢀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠀]],
						[[⠀⠀⠀⢀⣾⣿⣿⡇⠀⠀⠀⠀⠀⠀⢸⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⡇⠀]],
						[[⠀⠀⠀⣼⣿⠃⠹⣿⣷⣄⠀⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠇⠀]],
						[[⠀⠀⠀⣿⡿⠀⠀⠈⠻⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀]],
						[[⠀⠀⢸⣿⣧⠀⠀⠀⠀⠸⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡷⠀⠀]],
						[[⠀⠀⠈⣿⣿⡄⠀⠀⠀⠀⢻⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⡀⠀]],
						[[⠀⠀⠀⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣧⠀]],
						[[⠀⠀⠀⢻⣿⡟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⡇]],
						[[⠀⠀⠀⠘⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⡿]],
						[[⠀⠀⠀⣤⣸⣿⣿⡷⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠃]],
						[[⠀⠀⠘⣿⡿⠿⣿⣿⣿⣷⡶⢶⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⠏⠀]],
						[[⠀⠀⢀⣿⡟⠀⠀⠀⠀⠀⠀⠈⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡿⠟⠉⠀⠀]],
						[[⠀⠀⣼⣿⠇⠀⣴⣄⠀⠀⠀⠀⢹⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣶⣿⠟⠁⠀⠀⠀⠀]],
						[[⢀⣼⣿⠋⠀⠀⠘⣿⣧⠀⠀⠀⢸⣿⣧⣄⣀⠀⠀⠀⢀⣀⣤⣶⣿⣿⠋⠁⠀⠀⠀⠀⠀⠀]],
						[[⢾⣯⣁⠀⠀⠀⠀⠈⢿⡄⠀⠀⣸⡿⠉⠙⠛⠛⠛⠛⢻⣿⡏⢹⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀]],
						[[⠀⠛⢿⣷⣦⣤⣀⡀⠀⠀⠀⣠⣿⣷⣶⣶⣶⣶⣶⣦⣤⣿⣿⡜⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀]],
						[[⠀⠀⠀⠈⠙⠛⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⢻⡿⣷⣶⣤⣀⠀⠀⠀⠀]],
						[[⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣏⣁⡸⠟⠈⣩⣿⣿⣿⠶⠀⠀]],
						[[⠀⠀⠀⣠⣴⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣿⠟⠋⠁⠀⠀⠀⠀]],
						[[⠀⠀⠀⠙⠿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀]],
						[[⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
						[[       WADDLE WADDLE WADDLE       ]],
					}
					for _, line in ipairs(header) do
						comp:text_component_render({ comp:text_component(line, "center", "ProfileBlue") })
					end

					comp:separator_render()
					comp:text_component_render({
						comp:text_component("Neovim Tip of the Day:", "center", "ProfileGreen"),
						comp:text_component("Loading...", "center", "ProfileGreen"),
					})
				end,
			})

			-- Fetch tip asynchronously and update the buffer
			vim.fn.jobstart({ "curl", "-s", "-m", "3", "https://vtip.43z.one" }, {
				stdout_buffered = true,
				on_stdout = function(_, data)
					if data and data[1] and data[1] ~= "" then
						local tip = table.concat(data, "")
						vim.schedule(function()
							-- Find the profile buffer
							for _, buf in ipairs(vim.api.nvim_list_bufs()) do
								if vim.api.nvim_buf_is_loaded(buf) then
									local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
									for i, line in ipairs(lines) do
										if line:match("Loading%.%.%.") then
											-- Replace "Loading..." with the actual tip
											local width = vim.api.nvim_win_get_width(0)
											local padding = math.floor((width - #tip) / 2)
											local centered_tip = string.rep(" ", math.max(0, padding)) .. tip
											vim.api.nvim_buf_set_option(buf, "modifiable", true)
											vim.api.nvim_buf_set_lines(buf, i - 1, i, false, { centered_tip })
											vim.api.nvim_buf_set_option(buf, "modifiable", false)
											vim.api.nvim_buf_set_option(buf, "modified", false)
											return
										end
									end
								end
							end
						end)
					end
				end,
			})

			vim.api.nvim_set_keymap("n", "<leader>p", "<cmd>Profile<cr>", { silent = true })
		end,
	},
}
