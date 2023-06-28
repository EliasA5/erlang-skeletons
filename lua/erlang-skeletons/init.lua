
local utils = require("erlang-skeletons.utils")

-- local plugin_dir = vim.fn.expand('<sfile>:p:h')
local plugin_dir = debug.getinfo(1).source:sub(2)
plugin_dir = plugin_dir:match("(.+/)[%w%c%d%.]+$")
if utils.isempty(vim.g.erl_tpl_dir) then
    vim.g.erl_tpl_dir = plugin_dir .. "templates/"
end

if utils.isempty(vim.g.erl_author) then
	vim.g.erl_author = utils.get_author_name()
end

if utils.isempty(vim.g.erl_company) then
	vim.g.erl_company = vim.g.erl_author
end

if utils.isempty(vim.g.erl_replace_buffer) then
	vim.g.erl_replace_buffer = 0
end

local M = {}
M.LoadTemplate = function(tb)
	local _T = {}
	_T.fulldate = os.date("%d %B %Y")
	_T.year = os.date("%Y")
	_T.author = vim.g.erl_author
	_T.user = utils.get_author_user()
	_T.company = vim.g.erl_company

	local name = vim.api.nvim_buf_get_name(0) or "untitled"
	_T.basename = name:match("/([%w%c%d_]+)%.?[%w%c%d]*$") or name

	local tpl_dir = tb.tpl_dir or vim.g.erl_tpl_dir
	local tpl = tpl_dir .. tb.tpl_file

	local file = io.open(tpl, "rb")
	if not file then return nil end

	local template = file:read "*a"
	file:close()

	local output = utils.string_sub(template, _T)

	if tb.replace_buffer or vim.g.erl_replace_buffer == 1 then
		vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
	end

	vim.api.nvim_buf_set_lines(0, 0, 0, false, output)
	vim.cmd("set filetype=erlang")
end

M.setup = function()
	vim.api.nvim_create_user_command("EQCStatem", function() M.LoadTemplate({tpl_file = "eqc_statem", }) end, { desc = "Load EQCStatem template" })
	vim.api.nvim_create_user_command("ErlServer", function() M.LoadTemplate({tpl_file = "gen_server", }) end, { desc = "Load gen_server template" })
	vim.api.nvim_create_user_command("ErlFsm", function() M.LoadTemplate({tpl_file = "gen_fsm", }) end, { desc = "Load gen_fsm template" })
	vim.api.nvim_create_user_command("ErlStatem", function() M.LoadTemplate({tpl_file = "gen_statem", }) end, { desc = "Load gen_statem/3 template" })
	vim.api.nvim_create_user_command("ErlStatem4", function() M.LoadTemplate({tpl_file = "gen_statem4", }) end, { desc = "Load gen_statem/4 template" })
	vim.api.nvim_create_user_command("ErlSupervisor", function() M.LoadTemplate({tpl_file = "supervisor", }) end, { desc = "Load supervisor template" })
	vim.api.nvim_create_user_command("ErlSupervisorBridge", function() M.LoadTemplate({tpl_file = "supervisor_bridge", }) end, { desc = "Load supervisor_bridge template" })
	vim.api.nvim_create_user_command("ErlEvent", function() M.LoadTemplate({tpl_file = "gen_event", }) end, { desc = "Load gen_event template" })
	vim.api.nvim_create_user_command("ErlApplication", function() M.LoadTemplate({tpl_file = "application", }) end, { desc = "Load application template" })
	vim.api.nvim_create_user_command("ErlCTSuite", function() M.LoadTemplate({tpl_file = "commontest", }) end, { desc = "Load commontest template" })
	vim.api.nvim_create_user_command("ErlEscript", function() M.LoadTemplate({tpl_file = "escript", }) end, { desc = "Load escript template" })
	vim.api.nvim_create_user_command("ErlWxObject", function() M.LoadTemplate({tpl_file = "wx-object", }) end, { desc = "Load wx-object template" })
	vim.api.nvim_create_user_command("ErlTemplate", function(tb) M.LoadTemplate(tb) end, { desc = "Load a custom template" })
end

return M
