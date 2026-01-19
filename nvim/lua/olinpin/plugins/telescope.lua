local _bad = { ".*%.min.css", ".*%.min.js" } -- remove minified results crashing the previewer
local bad_files = function(filepath)
	for _, v in ipairs(_bad) do
		if filepath:match(v) then
			return false
		end
	end

	return true
end

local new_maker = function(filepath, bufnr, opts)
	local previewers = require("telescope.previewers")
	opts = opts or {}
	if opts.use_ft_detect == nil then
		opts.use_ft_detect = true
	end
	opts.use_ft_detect = opts.use_ft_detect == false and false or bad_files(filepath)
	previewers.buffer_previewer_maker(filepath, bufnr, opts)
end

local function grepInFiles()
	local builtin = require("telescope.builtin")
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	builtin.filetypes({
		attach_mappings = function(prompt_bufnr, _)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				local filetype = selection.value

				builtin.live_grep({
					additional_args = function()
						return { "--glob", "*." .. filetype }
					end,
				})
			end)
			return true
		end,
	})
end

return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	tag = "0.1.8",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>ft", grepInFiles, desc = "Live grep by filetype" },
		{ "<leader>*", function() require("telescope.builtin").grep_string() end, desc = "Grep current string" },
		{ "<leader>fs", function() require("telescope.builtin").find_files() end, desc = "Find files" },
		{ "<leader>fg", function() require("telescope.builtin").git_branches() end, desc = "Find Git branches" },
		{ "<leader>fc", function() require("telescope.builtin").git_commits() end, desc = "Find Commits" },
		{ "<leader>fw", function() require("telescope.builtin").live_grep() end, desc = "Find Words" },
	},
	config = function()
		local telescope = require("telescope")

		telescope.setup({
			extensions = {
				smart_open = {
					cwd_only = true,
					mappings = {
						i = {
							-- works around smart_open overriding ctrl-w keybind for deleting
							-- word. should be able to remove this once this issue is resolved:
							-- https://github.com/danielfalk/smart-open.nvim/issues/71
							["<C-w>"] = function()
								vim.api.nvim_input("<c-s-w>")
							end,
						},
					},
				},
			},
			defaults = {
				buffer_previewer_maker = new_maker,
			},
			pickers = {
				find_files = {
					-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
					find_command = {
						"rg",
						"--files",
						"--hidden",
						"--no-ignore",
						"--glob",
						"!**/.git/*",
						"--glob",
						"!**/venv/*",
						"--glob",
						"!**/.venv/*",
						"--glob",
						"!**/node_modules/*",
						"--glob",
						"!**/vendor/*",
						"--glob",
						"!**/var/cache/*",
						"--glob",
						"!**/.next/*",
						"--glob",
						"!**/out/*",
						"--glob",
						"!**/dist/*",
						"--glob",
						"!**.min.js",
					},
				},
			},
			preview = {
				filesize_limit = 0.5, -- MB
			},
		})
	end,
}
