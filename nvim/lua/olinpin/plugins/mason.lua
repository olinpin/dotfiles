-- Install LSP servers and 3rd-party tools
-- source: https://github.com/ruicsh/nvim-config/blob/main/lua/plugins/mason.lua
-- sauce: https://github.com/ruicsh/nvim-config/blob/main/lua/plugins/mason.lua
-- https://github.com/williamboman/mason.nvim

-- https://mason-registry.dev/registry/list
local PACKAGES = {
	-- LSP
	"angular-language-server",
	"ansible-language-server",
	"css-lsp",
	"cssmodules-language-server",
	"css-variables-language-server",
	"dockerfile-language-server",
	"harper-ls",
	"html-lsp",
	"json-lsp",
	"lua-language-server",
	"pyright",
	"typescript-language-server",
	"yaml-language-server",
	"vue-language-server",
	"ts_ls",
	"typescript-tools",
	-- Format
	"black",
	"flake8",
	"prettierd",
	"stylua",
	-- Lint
	"eslint-lsp",
	"pylint",
	"jq",
	"php-cs-fixer",
	"intelephense",
	"prettier",
}

local function install(pack, version)
	local notifyOpts = { title = "Mason", icon = "", id = "mason.install" }

	local msg = version and ("[%s] updating to %s…"):format(pack.name, version)
		or ("[%s] installing…"):format(pack.name)
	vim.defer_fn(function()
		vim.notify(msg, nil, notifyOpts)
	end, 0)

	pack:once("install:success", function()
		local msg2 = ("[%s] %s"):format(pack.name, version and "updated." or "installed.")
		notifyOpts.icon = " "
		vim.defer_fn(function()
			vim.notify(msg2, nil, notifyOpts)
		end, 0)
	end)

	pack:once("install:failed", function()
		local error = "Failed to install [" .. pack.name .. "]"
		vim.defer_fn(function()
			vim.notify(error, vim.log.levels.ERROR, notifyOpts)
		end, 0)
	end)

	pack:install({ version = version })
end

local function syncPackages(ensurePacks)
	local masonReg = require("mason-registry")

	local function refreshCallback()
		-- Auto-install missing packages & auto-update installed ones
		vim.iter(ensurePacks):each(function(packName)
			-- Extract package name and pinned version if specified
			local name, pinnedVersion = packName:match("([^@]+)@?(.*)")
			if not masonReg.has_package(name) then
				return
			end
			local pack = masonReg.get_package(name)
			if pack:is_installed() then
				-- Only check for updates if no version was pinned
				if pinnedVersion == "" then
					local latest_version = pack:get_latest_version()
					-- Check if the latest version is different from the installed one
					if latest_version and latest_version ~= pack:get_installed_version() then
						local msg = ("[%s] updating to %s…"):format(pack.name, latest_version)
						vim.defer_fn(function()
							vim.notify(msg, nil, { title = "Mason", icon = "󰅗" })
						end, 0)
						-- Install the latest version
						pack:install({ version = latest_version })
					end
				end
			else
				-- Install with pinned version if specified
				install(pack, pinnedVersion ~= "" and pinnedVersion or nil)
			end
		end)

		-- Auto-clean unused packages
		-- local installedPackages = masonReg.get_installed_package_names()
		-- vim.iter(installedPackages):each(function(packName)
		-- 	-- Check if installed package is in our ensure list (without version suffix)
		-- 	local isEnsured = vim.iter(ensurePacks):any(function(ensurePack)
		-- 		local name = ensurePack:match("([^@]+)")
		-- 		return name == packName
		-- 	end)
		--
		-- 	if not isEnsured then
		-- 		masonReg.get_package(packName):uninstall()
		-- 		local msg = ("[%s] uninstalled."):format(packName)
		-- 		vim.defer_fn(function()
		-- 			vim.notify(msg, nil, { title = "Mason", icon = "󰅗" })
		-- 		end, 0)
		-- 	end
		-- end)
	end

	masonReg.refresh(refreshCallback)
end

return {
	{
		"williamboman/mason.nvim",
		init = function()
			-- Do not crowd home directory with NPM cache folder
			vim.env.npm_config_cache = vim.env.HOME .. "/.cache/npm"
		end,
		opts = {
			ui = {
				border = "rounded",
				height = 0.85,
				width = 0.8,
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)

			-- Filter out disabled packages
			local packages = {}
			for _, package in ipairs(PACKAGES) do
				table.insert(packages, package)
			end

			vim.defer_fn(function()
				syncPackages(packages)
			end, 3000)
		end,

		event = { "VeryLazy" },
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local on_attach = function(client, bufnr)
				local opts = { buffer = bufnr, silent = true }

				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
				vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
				vim.keymap.set({ "n", "x" }, "<F3>", function()
					vim.lsp.buf.format({ async = true })
				end, opts)
				vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, opts)
			end

			-- Configure LSP servers using new vim.lsp.config API
			vim.lsp.config("lua_ls", {
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = { enable = false },
					},
				},
			})

			vim.lsp.config("ts_ls", { 
				on_attach = on_attach, 
				capabilities = capabilities,
			})
			vim.lsp.enable("ts_ls")
			
			vim.lsp.config("pyright", { on_attach = on_attach, capabilities = capabilities })
			vim.lsp.config("html", { on_attach = on_attach, capabilities = capabilities })
			vim.lsp.config("cssls", { on_attach = on_attach, capabilities = capabilities })
			vim.lsp.config("jsonls", { on_attach = on_attach, capabilities = capabilities })
			vim.lsp.config("yamlls", { on_attach = on_attach, capabilities = capabilities })
			vim.lsp.config("intelephense", {
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					intelephense = {
						format = {
							enable = true,
						},
					},
				},
			})
			vim.lsp.config("eslint", { on_attach = on_attach, capabilities = capabilities })
			vim.lsp.config("vue_ls", { 
				on_attach = on_attach, 
				capabilities = capabilities,
			})
			vim.lsp.enable("vue_ls")

			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"pyright",
					"html",
					"cssls",
					"jsonls",
					"yamlls",
					"intelephense",
					"eslint",
					"vue_ls",
				},
				automatic_installation = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
	},
}
