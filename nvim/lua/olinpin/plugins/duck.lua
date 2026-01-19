return {
	"tamton-aquib/duck.nvim",
	keys = {
		{ "<leader>dd", function() require("duck").hatch() end, desc = "Duck hatch" },
		{ "<leader>dc", function() require("duck").hatch("🐿️", 20) end, desc = "Duck squirrel" },
		{ "<leader>dk", function() require("duck").cook() end, desc = "Duck cook" },
	},
}
