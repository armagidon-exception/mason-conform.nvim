local M = {}

---@generic T, V
---@param tbl table<T, V>
---@return table<V, T>
function M.tbl_reverse(tbl)
	local output = {}
	for k, v in pairs(tbl) do
		output[v] = k
	end
	return output
end

---@generic T : table
---@param tbl T
---@return T
function M.read_only(tbl)
	return setmetatable(tbl, {
		__newindex = function(self, k, v)
			error "Attempted to modify read-only table!"
		end,
	})
end

return M
