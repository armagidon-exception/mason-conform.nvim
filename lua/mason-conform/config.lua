local Config = {}

---@type mason-conform.setupOpts
Config.default_config = {
	ignore_install = {},
	auto_enable = {
		enabled = true,
		notify = false,
	},
}

---@type mason-conform.setupOpts
Config.config = {}

return Config
