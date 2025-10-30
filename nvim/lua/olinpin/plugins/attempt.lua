return {
	"m-demare/attempt.nvim",
	config = function()
		local attempt = require("attempt")

		attempt.setup({
			initial_content = {
				php = "<?php\n\n",
				py = "",
			},
			ext_options = { "js", "py", "php", "" },
			format_opts = {
				js = "JavaScript",
				py = "Python",
				[""] = "[None]",
			},
		})

		local cmd_map = {
			py = "python3",
			js = "node",
			php = "php",
		}

		vim.keymap.set("n", "<leader>ss", attempt.new_select, { desc = "Attempt: Open Attempt" })
		vim.keymap.set("n", "<leader>si", attempt.new_input_ext, { desc = "Attempt: New Attempt with Input" })
		vim.keymap.set("n", "<leader>sr", function()
			local ext = vim.fn.expand("%:e")
			local cmd = cmd_map[ext] or 'echo "unsupported"'
			vim.cmd("split | terminal " .. cmd .. " %")
		end, { desc = "Attempt: Run Attempt" })
		vim.keymap.set("n", "<leader>sd", attempt.delete_buf, { desc = "Attempt: Delete Attempt from Current Buffer" })
		vim.keymap.set("n", "<leader>sc", attempt.rename_buf, { desc = "Attempt: Rename Attempt from Current Buffer" })
		vim.keymap.set("n", "<leader>sf", ":Telescope attempt<CR>", { desc = "Attempt: List Attempts with Telescope" })
	end,
}
