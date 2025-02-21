local M = {}

local trust_file = vim.fn.stdpath("data") .. "/projrc-trust.json"
local config_decisions = {}

local function load_trust_file()
  local f = io.open(trust_file, "r")
  if f then
    local contents = f:read("*a")
    if contents and contents ~= "" then
      local ok, data = pcall(vim.fn.json_decode, contents)
      if ok and type(data) == "table" then
        config_decisions = data
      end
    end
    f:close()
  end
end

local function save_trust_file()
  local f = io.open(trust_file, "w")
  if f then
    f:write(vim.fn.json_encode(config_decisions))
    f:close()
  end
end

local function load_local_config(config)
  if config_decisions[config] ~= nil then
    if config_decisions[config] then
      vim.cmd("luafile " .. vim.fn.fnameescape(config))
    end
    return
  end

  local choice = vim.fn.confirm("Load local config: " .. config .. "?", "&Yes\n&No", 1)
  if choice == 1 then
    config_decisions[config] = true
    vim.cmd("luafile " .. vim.fn.fnameescape(config))
  else
    config_decisions[config] = false
  end
  save_trust_file()
end

local function load_parent_configs()
  local file_path = vim.api.nvim_buf_get_name(0)
  if file_path == "" then return end
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
  load_trust_file()
  vim.api.nvim_create_autocmd("BufEnter", { callback = load_parent_configs })
end

return M
