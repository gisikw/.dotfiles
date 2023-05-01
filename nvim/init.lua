require('vars')
require('opts')
require('keys')
require('plug')

vim.cmd.colorscheme("inkpot")

local undo_dir = "/tmp/.undodir_" .. vim.fn.expand("$USER")
if not vim.loop.fs_stat(undo_dir) then
    vim.loop.fs_mkdir(undo_dir, tonumber("700", 8))
end
vim.o.undodir = undo_dir
vim.o.undofile = true
