-- Map <Esc> to revert to normal mode even in terminal emulator
vim.cmd('tnoremap <Esc> <C-\\><C-n>')

_G.TermSplitCmd = function(cmd)
  local buf_name = "special_terminal"
  local existing_buf = vim.fn.bufnr(buf_name)

  if existing_buf ~= -1 then
    vim.api.nvim_buf_delete(existing_buf, { force = true })
  end

  vim.cmd("botright split")
  vim.cmd(string.format("term %s", cmd))
  vim.api.nvim_buf_set_name(0, buf_name)
end

vim.api.nvim_command('command! -nargs=* TermSplitCmd lua _G.TermSplitCmd(<q-args>)')

_G.run_leader_cmd = function(num)
  local cmd_var = "leader_" .. tostring(num)
  if vim.g[cmd_var] == nil then
    local success, user_input = pcall(vim.fn.input, "Temp cmd: ")

    if not success or user_input == "" then return end
    vim.g[cmd_var] = "TermSplitCmd " .. user_input:gsub('%%', vim.fn.expand('%'))
  end
  vim.cmd(vim.g[cmd_var])
end

_G.clear_leader_cmds = function()
  for i = 1, 10 do
    local cmd_var = "leader_" .. tostring(i)
    vim.g[cmd_var] = nil
  end
  print("Cleared all temp commands")
end

for i = 1, 10 do
  local key = i % 10
  vim.api.nvim_set_keymap('n', '<leader>' .. tostring(key), string.format(':lua run_leader_cmd(%d)<CR>', i), { noremap = true, silent = true })
end

vim.api.nvim_set_keymap('n', '<leader>`', ':lua _G.clear_leader_cmds()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>q', ':bdelete<CR>', { noremap = true, silent = true })
