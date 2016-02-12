" Kevin Gisi's .vimrc

set nocompatible
filetype plugin on

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
Plugin 'junegunn/goyo.vim'
Plugin 'junegunn/limelight.vim'
Plugin 'tpope/vim-endwise'
Plugin 'kchmck/vim-coffee-script'
call vundle#end()

" General Configuration
syntax on
set relativenumber
set number
set softtabstop=2
set shiftwidth=2
set expandtab
set backupdir=/tmp
set autoindent
set nofoldenable
set splitright
set splitbelow
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
nmap <leader>e :e<space>
nmap <leader>d :NERDTreeToggle<cr>
nmap <leader>\ :vsp<cr>
nmap <leader>- :sp<cr>
nmap <leader>w :Goyo<cr>
nmap <leader>c :echo system("wc -w " . expand("%"))<cr>
nmap <leader>n :!FILE=% npm test<cr>
nmap <leader>@ "=strftime("%m/%d/%y")<CR>P
nmap <leader><space> :!cp % /Volumes/Kerbal\ Space\ Program/Ships/Script<cr><cr>

" Keyboard lag fix
command! W write
command! Q quit

" Filetype overrides
au BufRead,BufNewFile *.txt set nonumber
au BufRead,BufNewFile *.ks set filetype=kerboscript
au BufRead,BufNewFile *.coffee set filetype=coffee

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

" Configure Goyo and Limelight for writing prose
let g:limelight_conceal_ctermfg = 'lightgray'
function! s:goyo_enter()
  Limelight
  colorscheme Tomorrow
  highlight NonText ctermfg=bg guifg=bg
  set wrap linebreak nolist
endfunction
function! s:goyo_leave()
  Limelight!
  colorscheme synic
  highlight NonText ctermfg=fg guifg=fg
endfunction

" Configure NERDTree"
let NERDTreeQuitOnOpen = 1

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
