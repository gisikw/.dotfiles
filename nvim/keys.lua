default_options = { noremap = true, silent = true }
function normal_keymap(mapping, command, options)
  options = vim.tbl_extend('force', default_options, options or {})
  vim.api.nvim_set_keymap('n', mapping, command, options)
end

normal_keymap('<leader><leader>', ':source $MYVIMRC<cr>:echo "Reloaded"<cr>')
normal_keymap('<leader>d', ':NERDTreeToggle<cr>')
normal_keymap('<space>', ':noh<bar>:echo<cr>')
normal_keymap('<leader>c', ':!wc %<cr>')
