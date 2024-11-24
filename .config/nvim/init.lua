-------------------------------------------------------------------------------
-- BASE CONFIGURATION
-------------------------------------------------------------------------------

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.updatetime = 250
vim.opt.cursorline = true

vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.incsearch = true
vim.opt.termguicolors = true

vim.opt.splitright = true
vim.opt.splitbelow = true

-------------------------------------------------------------------------------
-- KEYBINDINGS
-------------------------------------------------------------------------------

-- Make Ctrl+C a proper escape
vim.keymap.set('i', '<C-c>', '<Esc>')

-- Reload Neovim config
vim.keymap.set('n', '<leader>r', function()
  vim.cmd('source $MYVIMRC')
  vim.api.nvim_echo({{"Reloaded!", "None"}}, false, {})
  vim.defer_fn(function() vim.cmd('echon ""') end, 1000)
end)

-- Shh
vim.keymap.set('n','<space>', function()
  vim.cmd('noh')
  vim.cmd('echon ""')
end)

vim.keymap.set('n', '<leader>d', ':NvimTreeToggle<cr>')

-------------------------------------------------------------------------------
-- USE UNDO TEMPFILES
-------------------------------------------------------------------------------
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
local undo_dir = "/tmp/.nvim_undodir_" .. vim.fn.expand("$USER")
if not vim.loop.fs_stat(undo_dir) then
  vim.loop.fs_mkdir(undo_dir, tonumber("700", 8))
end
vim.opt.undodir = undo_dir
vim.opt.undofile = true

-------------------------------------------------------------------------------
-- FILETYPE-SPECIFIC SETTINGS
-------------------------------------------------------------------------------
colors = {
  rust = "base16-gruvbox-dark-hard",
  lua = "base16-atlas",
  javascript = "base16-ia-dark",
  go = "base16-monokai",
  ruby = "base16-railscasts",
  sh = "base16-paraiso",
  python = "base16-onedark",
  -- todo = "base16-primer-dark"
  -- todo = "base16-qualia"
  -- todo = "base16-selenized-black"
  -- todo = "base16-woodland"
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufDelete" }, {
  callback = function()
    local color = colors[vim.bo.filetype]
    if color then
      vim.cmd.colorscheme(color)
    end
  end
})

-------------------------------------------------------------------------------
-- PLUGINS
-------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system(
    { "git", "clone", "--filter=blob:none", 
      "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    "hrsh7th/nvim-cmp",
    {
      "nvim-tree/nvim-tree.lua",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("nvim-tree").setup()
      end,
    },
    {
      'RRethy/base16-nvim',
      config = function()
        vim.cmd.colorscheme("base16-selenized-black")
      end,
    },
    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      main = 'nvim-treesitter.configs',
      opts = {
        ensure_installed = { 'lua' },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { 'ruby' },
        },
        indent = { enable = true, disable = { 'ruby' } },
      },
    },
    {
      'neovim/nvim-lspconfig',
      dependencies = {
        { 'williamboman/mason.nvim', config = true },
        'williamboman/mason-lspconfig.nvim',
        { 'j-hui/fidget.nvim', opts = {} },
        'hrsh7th/cmp-nvim-lsp',
      },
      config = function()
        require("mason").setup()
        require("mason-lspconfig").setup({
          ensure_installed = { "rust_analyzer" },
        })

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend(
          'force', 
          capabilities, 
          require('cmp_nvim_lsp').default_capabilities()
        )
        
        local lspconfig = require("lspconfig")
        require("mason-lspconfig").setup_handlers({
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities
            }) 
          end,
        })

        vim.opt.signcolumn = "yes"
        vim.diagnostic.config({ 
          virtual_text = true, 
          signs = true 
        })
        vim.diagnostic.enable() 

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
          vim.lsp.handlers.hover, {
            border = "rounded",
          }
        )

        -- Hover tooltips that dismiss
        vim.keymap.set("n", "K", function()
          vim.lsp.buf.hover()

          local group = vim.api.nvim_create_augroup(
            "HoverClose", 
            { clear = true }
          )
          vim.api.nvim_create_autocmd("CursorMoved", {
            group = group,
            callback = function()
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                local config = vim.api.nvim_win_get_config(win)
                if config.relative ~= "" then
                  vim.api.nvim_win_close(win, true)
                end
              end

              vim.api.nvim_del_augroup_by_name("HoverClose")
            end,
          })
	end)

        -- Format before save
        vim.api.nvim_create_autocmd("BufWritePre", {
          callback = function()
            vim.lsp.buf.format({ async = false })
          end
        })
      end,
    },
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
      },
      config = function()
        local cmp = require("cmp")
        cmp.setup({
          mapping = cmp.mapping.preset.insert({
            ['<C-n>'] = cmp.mapping.select_next_item(), -- Navigate suggestions
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Confirm selection
            ['<Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              else
                fallback()
              end
            end, { 'i', 's' }),
          }),
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'buffer' },
            { name = 'path' },
          }),
        })
      end,
    }
  },
  checker = { 
    enabled = true,
    notify = false,
  },
  install = {
    missing = true,
  },
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("lazy").update({ show = false })
  end,
})

-------------------------------------------------------------------------------
-- MACRO UTILITY
-------------------------------------------------------------------------------
_G.TermFloatingCmd = function(cmd)
  local buf_name = "macro term"
  local existing_buf = vim.fn.bufnr(buf_name)

  -- Delete existing buffer if it exists
  if existing_buf ~= -1 then
    vim.api.nvim_buf_delete(existing_buf, { force = true })
  end

  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, buf_name)

  -- Create a floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = math.floor(vim.o.columns * 0.8),
    height = math.floor(vim.o.lines * 0.8),
    col = math.floor(vim.o.columns * 0.1),
    row = math.floor(vim.o.lines * 0.1),
    style = "minimal",
    border = "rounded",
  })

  vim.fn.termopen(cmd)
  vim.bo[buf].buftype = "terminal"
  vim.cmd("startinsert")

  vim.api.nvim_create_autocmd("TermClose", {
    buffer = buf,
    callback = function()
      vim.opt_local.number = true
      vim.opt_local.relativenumber = true
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, true, true),
        "n", 
        false
      )
    end,
  })

  vim.api.nvim_buf_set_keymap(
    buf, "n", "q", "<Cmd>close<CR>", { noremap = true, silent = true }
  )
end

vim.api.nvim_command(
  'command! -nargs=* TermFloatingCmd lua _G.TermFloatingCmd(<q-args>)'
)

_G.run_leader_cmd = function(num)
  local cmd_var = "leader_" .. tostring(num)
  if vim.g[cmd_var] == nil then
    -- Prompt for a new command if one isn't set
    local success, user_input = pcall(vim.fn.input, "Temp cmd: ")

    if not success or user_input == "" then return end
    vim.g[cmd_var] = 
      "TermFloatingCmd " .. user_input:gsub('%%', vim.fn.expand('%'))
  end
  vim.cmd(vim.g[cmd_var])
end

-- Clear all temporary commands
_G.clear_leader_cmds = function()
  for i = 1, 10 do
    local cmd_var = "leader_" .. tostring(i)
    vim.g[cmd_var] = nil
  end
  print("Cleared all temp commands")
end

-- Keybindings for <leader>1-9 to run the temporary commands
for i = 1, 10 do
  local key = i % 10
  vim.api.nvim_set_keymap(
    'n',
    '<leader>' .. tostring(key), 
    string.format(':lua _G.run_leader_cmd(%d)<CR>', i), 
    { noremap = true, silent = true }
  )
end

vim.api.nvim_set_keymap('n', '<leader>`', ':lua _G.clear_leader_cmds()<CR>', 
                        { noremap = true, silent = true })