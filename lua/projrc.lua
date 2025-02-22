local M = {}

local function load_local_config(config)
	local contents = vim.secure.read(config)
	if contents then
		vim.cmd("luafile " .. vim.fn.fnameescape(config))
	end
end

local function load_parent_configs()
	local file_path = vim.api.nvim_buf_get_name(0)
	if file_path == "" then
		return
	end

	local dir = vim.fn.fnamemodify(file_path, ":p:h")
	local prev_dir = ""

	while dir and dir ~= prev_dir do
		local config = dir .. "/.nvim.lua"
		if vim.fn.filereadable(config) == 1 then
			load_local_config(config)
		end

		prev_dir = dir
		dir = vim.fn.fnamemodify(dir, ":h")
	end
end

function M.setup()
	vim.api.nvim_create_autocmd("BufEnter", {
		callback = load_parent_configs,
	})
end

return M
