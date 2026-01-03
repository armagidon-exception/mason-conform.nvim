local Config = require "mason-conform.config"
local M = {}

---@param cfg mason-conform.setupOpts
---@return nil
function M.setup(cfg)
	cfg = cfg or vim.deepcopy(Config.default_config)

	Config.config = vim.tbl_deep_extend("force", Config.default_config, cfg)

	require "mason-conform.auto_install"()
	require "mason-conform.auto_discover"()
end

return M
