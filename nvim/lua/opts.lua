opt = vim.opt

opt.syntax = "off"
opt.relativenumber = true
opt.number = true

opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

opt.splitright = true
opt.splitbelow = true

opt.backspace = 'indent,eol,start'

opt.backup = false
opt.writebackup = false
opt.swapfile = false

local undo_dir = "/tmp/.nvim_undodir_" .. vim.fn.expand("$USER")
if not vim.loop.fs_stat(undo_dir) then
  vim.loop.fs_mkdir(undo_dir, tonumber("700", 8))
end
opt.undodir = undo_dir
opt.undofile = true
