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

return {
	"nvim-telescope/telescope.nvim",
	event = "VeryLazy",
	tag = "0.1.8",
	dependencies = { "nvim-lua/plenary.nvim" },
	init = function()
		local builtin = require("telescope.builtin")
		local telescope = require("telescope")

		telescope.setup({
			defaults = {
				buffer_previewer_maker = new_maker,
			},
			pickers = {
                find_files = {
                    -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
                    find_command = { "rg", "--files", "--hidden", "--no-ignore",
                        "--glob", "!**/.git/*", "--glob", "!**/venv/*", "--glob", "!**/.venv/*", "--glob",
                        "!**/node_modules/*",
                        "--glob", "!**/vendor/*", "--glob", "!**/var/cache/*",
                        "--glob", "!**/.next/*", "--glob", "!**/out/*", "--glob", "!**/dist/*", "--glob", "!**.min.js"
                    },
                },
			},
			preview = {
				filesize_limit = 0.5, -- MB
			},
		})

        local function grepInFiles()
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
        vim.keymap.set("n", "<leader>ft", grepInFiles, { desc = "Live grep by filetype" })
        vim.keymap.set('n', '<leader>*', builtin.grep_string, {desc = "Grep current string"})
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {desc = "Find files"})
        vim.keymap.set('n', '<leader>fg', builtin.git_branches, {desc = "Find Git branches" })
        vim.keymap.set('n', '<leader>fc', builtin.git_commits, {desc = "Find Commits" })
        vim.keymap.set('n', '<leader>fw', builtin.live_grep, {desc = "Find Words" })

	end,
}
