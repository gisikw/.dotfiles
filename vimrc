" Kevin Gisi's .vimrc

set nocompatible
filetype plugin indent on

" Vundle Bootstrap and Plugins
if empty(glob('~/.vim/bundle/Vundle.vim'))
  silent exec '!git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim > /dev/null 2>&1'
endif
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'scrooloose/nerdtree'
Plugin 'flazz/vim-colorschemes'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tomvanderlee/vim-kerboscript'
Plugin 'othree/yajs.vim'
call vundle#end()

" General Configuration
syntax on
set number
set softtabstop=2
set shiftwidth=2
set expandtab
set backupdir=/tmp
set autoindent
set nofoldenable
set splitright
set bg=dark
set backspace=2

" Color Scheme
colorscheme synic

" Highlighting
set hlsearch
set incsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" Make Ctrl+C work like traditional escape
inoremap <C-c> <Esc>

" Leader-Key Shortcuts
nmap <leader>t :CtrlP<cr>
nmap <leader>d :NERDTreeToggle<cr>
nmap <leader>\ :vsp<cr>
nmap <leader>- :sp<cr>

" Keyboard lag fix
command! W write
command! Q quit

" Reload vimrc on change
autocmd! bufwritepost vimrc source ~/.vimrc

" Overload tab to autocomplete
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

" Support sane pasting
set pastetoggle=<F12>
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif
  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"
  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction
let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")
function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

" Automatically remove whitespace on save
function! StripTrailingWhitespace()
  let save_cursor = getpos(".")
  %s/\s\+$//e
  call setpos('.', save_cursor)
endfunction
autocmd BufWritePre * call StripTrailingWhitespace()
