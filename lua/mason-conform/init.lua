local M = {}

---@type mason-conform.setupOpts
M.config = {
	ignore_install = {},
	auto_enable = true,
}

---@param cfg mason-conform.setupOpts
---@return nil
function M.setup(cfg)
	cfg = cfg or {}
	if cfg and cfg.ignore_install then
		M.config.ignore_install = cfg.ignore_install
	end

	if cfg and cfg.auto_enable then
		M.config.auto_enable = cfg.auto_enable
	end

	require "mason-conform.auto_install"()

	if M.config.auto_enable then
		require "mason-conform.auto_discover"()
	end
end

return M
