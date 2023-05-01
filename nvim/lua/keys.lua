default_options = { noremap = true, silent = true }
function keymap_macro(mode)
  return function(mapping, command, options)
    options = vim.tbl_extend('force', default_options, options or {})
    vim.api.nvim_set_keymap(mode, mapping, command, options)
  end
end

normal_keymap = keymap_macro('n')
insert_keymap = keymap_macro('i')

-- Should update this to reload all the top-level scripts
normal_keymap('<leader><leader>', ':source $MYVIMRC<cr>:echo "Reloaded"<cr>')

normal_keymap('<leader>d',  ':NERDTreeToggle<bar>:TagbarToggle<cr>')
normal_keymap('<space>',    ':noh<bar>:echo<cr>')
normal_keymap('<leader>c',  ':!wc %<cr>')
normal_keymap('<leader>-',  ':bp<bar>bd #<cr>')
normal_keymap('<leader>t',  ':GFiles<cr>')

insert_keymap('<C-c>', '<Esc>')
