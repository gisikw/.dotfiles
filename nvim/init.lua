local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup("plugins")

vim.opt.modeline = false

vim.opt.syntax = "on"
vim.opt.relativenumber = true
vim.opt.number = true

vim.cmd.colorscheme("inkpot")

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.backspace = 'indent,eol,start'

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

local undo_dir = "/tmp/.nvim_undodir_" .. vim.fn.expand("$USER")
if not vim.loop.fs_stat(undo_dir) then
  vim.loop.fs_mkdir(undo_dir, tonumber("700", 8))
end
vim.opt.undodir = undo_dir
vim.opt.undofile = true

default_options = { noremap = true, silent = true }
function keymap_macro(mode)
  return function(mapping, command, options)
    options = vim.tbl_extend('force', default_options, options or {})
    vim.api.nvim_set_keymap(mode, mapping, command, options)
  end
end

normal_keymap = keymap_macro('n')
insert_keymap = keymap_macro('i')

normal_keymap('<leader>c',  ':!wc %<cr>')
normal_keymap('<leader>-',  ':bp<bar>bd #<cr>')
normal_keymap('<leader><leader>',  ':bnext<cr>')
insert_keymap('<C-c>', '<Esc>')

vim.opt.hlsearch = true
vim.opt.incsearch = true
-- vim.opt.termguicolors = false
normal_keymap('<space>', ':noh<bar>:echo<cr>')

function _G.insert_tab_wrapper()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    if col == 0 or vim.api.nvim_get_current_line():sub(col, col):match("%w") == nil then
        return vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
    else
        return vim.api.nvim_replace_termcodes("<C-p>", true, true, true)
    end
end

vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.insert_tab_wrapper()', {expr = true, noremap = true})
vim.api.nvim_set_keymap('i', '<S-Tab>', '<C-n>', {noremap = true})

_G.TermSplitCmd = function(cmd)
    local buf_name = "special_terminal"
    local existing_buf = vim.fn.bufnr(buf_name)
    local terminal_win = nil

    -- Check if our buffer is currently visible in any window.
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == existing_buf then
            terminal_win = win
            break
        end
    end

    -- If the terminal buffer is visible in another window, close it.
    if terminal_win then
        vim.api.nvim_win_close(terminal_win, false)
        vim.cmd(string.format("bdelete %d", existing_buf))
    end

    -- Always create a new terminal in a new split.
    vim.cmd("belowright split")
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
