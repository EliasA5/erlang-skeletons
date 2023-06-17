local U = {}

U.isempty = function(s)
  return s == nil or s == ''
end

U.get_author_name = function()
	local name = vim.trim(vim.fn.system('getent passwd "$USER" | cut -d: -f5 | cut -d, -f1'))
	if vim.v.shell_error ~= 0 then
		name = os.getenv("USER") or "author"
	end
	return name
end

U.get_author_user = function()
	return "<" .. (os.getenv("USER") or "author") .. ">"
end

U.string_split_newlines = function(s)
	local lines = {}
	for ma in s:gmatch("([^\r\n]*)[\r\n]?") do
		table.insert(lines, ma)
	end
	return lines
end

-- substitutes the values of the form $key to value in the string s
-- using the key-value pairs from Subs
U.string_sub = function(s, Subs)
	for key,val in pairs(Subs) do
		s = s:gsub("$" .. key, val)
	end
	return U.string_split_newlines(s)
end

return U
