return {
-- 	"akinsho/git-conflict.nvim",
-- 	version = "*",
--     lazy = true,
-- 	config = function()
-- 		require("git-conflict").setup({
-- 			default_mappings = false,
-- 			default_commands = true, -- disable commands created by this plugin
-- 			disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
-- 			list_opener = "copen", -- command or function to open the conflicts list
-- 			-- highlights = { -- They must have background color, otherwise the default color will be used
-- 			-- 	incoming = "DiffAdd",
-- 			-- 	current = "DiffText",
-- 			-- 	ancestor = "DiffChange",
-- 			-- },
-- 		})
--
-- 		local function conflict_choose(choice)
-- 			return function()
-- 				vim.cmd("GitConflictChoose" .. choice)
-- 				vim.cmd("AvanteConflictChoose" .. choice)
-- 			end
-- 		end
--
-- 		local function resolve_conflict(action)
-- 			if vim.fn.exists(":GitConflict") == 2 and vim.fn["git_conflict#is_conflicted"]() then
-- 				if action == "ours" then
-- 					return vim.cmd("GitConflictChooseOurs")
-- 				elseif action == "theirs" then
-- 					return vim.cmd("GitConflictChooseTheirs")
-- 				elseif action == "both" then
-- 					return vim.cmd("GitConflictChooseBoth")
-- 				elseif action == "none" then
-- 					return vim.cmd("GitConflictChooseNone")
-- 				end
-- 			elseif vim.fn.exists(":Avante") == 2 then
-- 				if action == "ours" then
-- 					return vim.cmd("AvanteChooseOurs")
-- 				elseif action == "theirs" then
-- 					return vim.cmd("AvanteChooseTheirs")
-- 				elseif action == "both" then
-- 					return vim.cmd("AvanteChooseBoth")
-- 				elseif action == "none" then
-- 					return vim.cmd("AvanteChooseNone")
-- 				end
-- 			else
--                 return ""
-- 			end
-- 		end
--
-- 		vim.keymap.set("n", "<leader>co", resolve_conflict("ours"), { desc = "Choose Ours (Avante & Git Conflict)" })
-- 		vim.keymap.set("n", "<leader>ct", resolve_conflict("theirs"), { desc = "Choose Theirs (Avante & Git Conflict)"})
-- 		vim.keymap.set("n", "<leader>cb", resolve_conflict("both"), { desc = "Choose Both (Avante & Git Conflict)" })
-- 		vim.keymap.set("n", "<leader>cn", resolve_conflict("none"), { desc = "Choose None (Avante & Git Conflict)" })
-- 	end,
}
