local registry = require "mason-registry"
local mappings = require "mason-conform.mapping"

---@return table<string, string[]>
local function auto_discover()
	local output = {}
	local formatters_by_ft = require("conform").formatters_by_ft
	---@type table<string, table>
	local formatters = require("conform.formatters").list_all_formatters()

	for formatter, _ in pairs(formatters) do
		if formatters_by_ft[formatter] then
			goto continue
		end
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
			if mappings.language_to_ft[lang] then
				for _, ft in ipairs(mappings.language_to_ft[lang]) do
					output[ft] = output[ft] or {}
					table.insert(output[ft], formatter)
				end
			else
				output[lang] = output[lang] or {}
				table.insert(output[lang], formatter)
			end
		end

		::continue::
	end

	return output
end

return function()
	local discovered = auto_discover()
	require("conform").setup { formatters_by_ft = discovered }
end
