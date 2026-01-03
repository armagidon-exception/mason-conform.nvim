local registry = require "mason-registry"
local mappings = require "mason-conform.mapping"
local Config = require "mason-conform.config"

---@return table<string, string[]>
local function auto_discover()
	local output = {}
	local formatters_by_ft = require("conform").formatters_by_ft
	---@type table<string, table>
	local formatters = require("conform.formatters").list_all_formatters()

	for formatter, _ in pairs(formatters) do
		local mason_pkg_name = mappings.conform_to_package[formatter]
		if not mason_pkg_name then
			goto continue
		end

		if not registry.is_installed(mason_pkg_name) then
			goto continue
		end

		local mason_pkg = registry.get_package(mason_pkg_name)
		local languages = mason_pkg.spec.languages

		for _, lang in ipairs(languages) do
            lang = string.lower(lang)
			if mappings.language_to_ft[lang] then
				for _, ft in ipairs(mappings.language_to_ft[lang]) do
					if not formatters_by_ft[ft] then
						output[ft] = output[ft] or {}
						table.insert(output[ft], formatter)

						if Config.config.auto_enable.enabled and Config.config.auto_enable.notify then
							vim.notify("Discovered " .. formatter .. " for " .. ft)
						end
					end
				end
			else
				if not formatters_by_ft[lang] then
					output[lang] = output[lang] or {}
					table.insert(output[lang], formatter)

					if Config.config.auto_enable.enabled and Config.config.auto_enable.notify then
						vim.notify("Discovered " .. formatter .. " for " .. lang)
					end
				end
			end
		end

		::continue::
	end

	return output
end

return function()
	if Config.config.auto_enable.enabled then
		local discovered = auto_discover()
		require("conform").setup { formatters_by_ft = discovered }
	end
end
