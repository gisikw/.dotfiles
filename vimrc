" Kevin Gisi's .vimrc

set nocompatible
filetype plugin on

" CVE: https://github.com/numirias/security/blob/master/doc/2019-06-04_ace-vim-neovim.md
set nomodeline

" Goodbye, Swapfiles
set nobackup
set nowritebackup
set noswapfile

" Vundle Bootstrap and Plugins
if empty(glob('~/.vim/bundle/Vundle.vim'))
  silent exec '!git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim > /dev/null 2>&1'
endif
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'scrooloose/nerdtree'
Plugin 'flazz/vim-colorschemes'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'yump/vim-kerboscript'
Plugin 'pangloss/vim-javascript'
Plugin 'othree/yajs'
Plugin 'mxw/vim-jsx'
Plugin 'junegunn/goyo.vim'
Plugin 'kchmck/vim-coffee-script'
Plugin 'tpope/vim-endwise'
Plugin 'lambdatoast/elm.vim'
Plugin 'andreasvc/vim-256noir'
Plugin 'janko-m/vim-test'
Plugin 'benmills/vimux'
" Plugin 'sbdchd/neoformat'
Plugin 'chemzqm/vim-jsx-improve'
Plugin 'mileszs/ack.vim'
Plugin 'rhysd/vim-crystal'
Plugin 'vimwiki/vimwiki'
Plugin 'reedes/vim-colors-pencil'
Plugin 'qualiabyte/vim-colorstepper'
" Plugin 'tpope/vim-markdown'
Plugin 'khzaw/vim-conceal'
Plugin 'udalov/kotlin-vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'DeltaWhy/vim-mcfunction'
call vundle#end()

" General Configuration
syntax on
set number
set relativenumber
set softtabstop=2
set shiftwidth=2
set expandtab
set backupdir=/tmp
set autoindent
set splitright
set splitbelow
set bg=dark
set backspace=2

" Color Scheme
colorscheme inkpot
" colorscheme louver

" Highlighting
set hlsearch
set incsearch
noremap <space> :noh<bar>:echo<cr>

" Use tab and shift-tab to cycle through windows.
nnoremap <Tab> <C-W>w
nnoremap <S-Tab> <C-W>W

" Make line-number lookup via numpad easy
nnoremap - G

" Make visual sorting trivial
vnoremap S :sort<CR>

" Make Ctrl+C work like traditional escape
inoremap <C-c> <Esc>

" Make F12 super fun for ES6 specs
inoremap <F12> , () => {<CR>});<Esc>O<Tab>

" Leader-Key Shortcuts
nmap <leader>1 :nmap <leader
nmap <leader>2 :call AutorunSecondary()<cr>
nmap <leader>t :CtrlPCurWD<cr>
nmap <leader>e :e<space>
nmap <leader>d :NERDTreeToggle<cr>
nmap <leader>\ :bn!<cr>
nmap <leader>- :bp\|bd #<cr>
nmap <leader>g :Goyo<cr>
nmap <leader>@ "=strftime("%m/%d/%y")<CR>P
nmap <leader>c :!wc %<cr>
nmap <leader><space> :w<cr>:TestNearest<cr>
nmap <leader>s :Ack!<space>
nmap <leader>? :sp ~/.dotfiles/vimtips<cr>

" Keyboard lag fix
command! W write
command! Q quit

" Markdown fenced code highlighting
let g:markdown_fenced_languages = ['ruby', 'javascript', 'js=javascript']
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" Filetype overrides
au BufRead,BufNewFile *.txt set nonumber
au BufRead,BufNewFile *.txt set filetype=markdown
au BufRead,BufNewFile *.ks set filetype=kerboscript
au BufRead,BufNewFile *.luap set filetype=lua
au BufRead,BufNewFile *.coffee set filetype=coffee
au BufRead,BufNewFile .eslintrc set filetype=json
au BufRead,BufNewFile *.thor set filetype=ruby

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

" Fix broken elm detection
autocmd BufRead,BufNewFile *.elm set ft=elm
autocmd BufRead,BufNewFile *.cr set ft=crystal
autocmd BufRead,BufNewFile *.kt set ft=kotlin
autocmd BufRead,BufNewFile *.go set tabstop=2
autocmd BufRead,BufNewFile *.go set noet

autocmd BufWritePre *.js Neoformat
autocmd BufWritePre *.elm Neoformat

" Language-Specific Vim-Test config
" let g:test#javascript#runner = 'mocha'
let g:test#javascript#mocha#file_pattern = 'Spec\.js'
let g:test#javascript#mocha#executable = './node_modules/.bin/mocha --opts spec/mocha.opts'
if exists('$TMUX')
  let g:test#strategy = 'vimux'
endif

let g:test#javascript#tap#executable = './node_modules/.bin/babel-tap'

" Automatically remove whitespace on save
function! StripTrailingWhitespace()
  let save_cursor = getpos(".")
  %s/\s\+$//e
  call setpos('.', save_cursor)
endfunction
" autocmd BufWritePre * call StripTrailingWhitespace()

" Configure Goyo for writing prose
let g:limelight_conceal_ctermfg = 'lightgray'
function! s:goyo_enter()
  " colorscheme Tomorrow
  " highlight NonText ctermfg=bg guifg=bg
  syntax off
  set wrap linebreak nolist noshowmode
endfunction
function! s:goyo_leave()
  syntax on
  " TODO: Save the old cs on goyo_enter, so we can restore the right one
  colorscheme inkpot
  " set nowrap nolinebreak list showmode
  " highlight NonText ctermfg=fg guifg=fg
endfunction

" Ignore some folders and files for CtrlP indexing
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.yardoc\|public$|log\|tmp\|node_modules$',
  \ 'file': '\.so$\|\.dat$|\.DS_Store$'
  \ }
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Function for autorunning the current file
let g:autorun_rules = {
  \ '\.vim'     : 'source %',
  \ 'spec\.rb' : '!clear && rspec %',
  \ '\.ks'      : 'call KOSEvaluate()',
  \ '\.txt'     : 'echo system("wc -w " . expand("%"))',
  \ 'Spec\.js'  : '!FILE=% npm run test:clean --silent',
  \ '\.js'      : '!node %',
  \ '\.py'      : '!python %',
  \ '\.lua'     : '!clear && lua %',
  \ '\.sh'      : '!clear && bash %',
\}

function! Autorun()
  for [pattern, task] in items(g:autorun_rules)
    if match(expand('%'),pattern) != -1
      exec task
      break
    endif
  endfor
endfunction

" Secondary functions for autorunning the current file
let g:autorun_rules_secondary = {
  \ '\.js'      : '!FILE=% npm run lint',
  \ '\.rb'      : '!rubocop %',
  \ '\.rake'    : '!rubocop %',
  \ '\.scss'    : '!scss-lint %',
  \ '\.ks'      : 'call KOSCopy()'
\}

function! AutorunSecondary()
  for [pattern, task] in items(g:autorun_rules_secondary)
    if match(expand('%'),pattern) != -1
      exec task
      break
    endif
  endfor
endfunction

" Functions for playing back the deleted buffer
function! Retype()
  let i = 0
  while i < len(@")
    exe ":normal a" . strpart(@",i,1)
    redraw
    sleep 50m
    let i += 1
  endwhile
  exe ":normal dd"
endfunction

function! RetypeFile()
  exe ":normal ggdG"
  call Retype()
endfunction

" Ignore some folders and files for CtrlP indexing
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.yardoc\|public$|log\|tmp$',
  \ 'file': '\.so$\|\.dat$|\.DS_Store$'
  \ }

" set shell=bash\ -l

" Function for interacting with KOS via telnet
let KOSGameDirectory = '/mnt/ksp'
let KOSTelnetPort    = '5410'
let KOSTelnetIP      = '192.168.56.1'
function! KOSEvaluate()
  exec '!export TERM=xterm && cp ' . expand('%:p') . ' ' . g:KOSGameDirectory . '/Ships/Script &&
          \ (echo open ' . g:KOSTelnetIP . ' ' . g:KOSTelnetPort . ';
          \ sleep 1;
          \ echo "1";
          \ sleep 1;
          \ echo "clearscreen. switch to 0. run ' . expand('%:t') . '.";
          \ sleep 5;
          \ ) | telnet; true'
endfunction

function! KOSCopy()
  exec '!cp ' . expand('%:p') . ' ' . g:KOSGameDirectory . '/Ships/Script'
endfunction

" Configure JSX support
let g:jsx_ext_required = 0

" Configure NERDTree
let NERDTreeQuitOnOpen = 1

" Use ag if it exists
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Call out 80+ line files
" highlight ColorColumn ctermbg=magenta
" call matchadd('ColorColumn', '\%81v', 100)

function! HLNext (blinktime)
    highlight WhiteOnRed ctermfg=white ctermbg=red
    let [bufnum, lnum, col, off] = getpos('.')
    let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
    let target_pat = '\c\%#\%('.@/.'\)'
    let ring = matchadd('WhiteOnRed', target_pat, 101)
    redraw
    exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
    call matchdelete(ring)
    redraw
    exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
    let ring = matchadd('WhiteOnRed', target_pat, 101)
    redraw
    exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
    call matchdelete(ring)
    redraw
endfunction
nnoremap <silent> n   n:call HLNext(0.1)<cr>
nnoremap <silent> N   N:call HLNext(0.1)<cr>

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Persistent Undo
let s:undoDir = "/tmp/.undodir_" . $USER
if !isdirectory(s:undoDir)
    call mkdir(s:undoDir, "", 0700)
endif
let &undodir=s:undoDir
set undofile

" Neoformat
" let g:neoformat_verbose = 1
let g:neoformat_only_msg_on_error = 1

augroup fmt
  autocmd!
  autocmd BufWritePre * Neoformat
augroup END

" Filetype-specific color schemes
autocmd BufEnter * colorscheme inkpot
autocmd BufEnter *.elm colorscheme gruvbox
autocmd BufEnter *.ks colorscheme synic
autocmd BufEnter *.md colorscheme buddy
autocmd BufEnter *.kt colorscheme monokai
autocmd BufEnter *.rkt colorscheme birds-of-paradise

" Fix splits on resize
autocmd VimResized * wincmd =

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" Use Markdown with vimwiki
let g:vimwiki_list = [{'syntax': 'markdown', 'ext': '.md', 'path': '~/.vimwiki'}]
autocmd BufWritePost ~/.vimwiki/*
            \ execute 'silent !cd ' . expand("<amatch>:p:h")
            \ . ' && git add "' . expand("<afile>:t") . '"'
            \ . ' && git commit -m "Auto commit of '
            \ . expand("<afile>:t") . '." "' . expand("<afile>:t") . '"'
            \ . ' && git push origin master'
            \ | execute 'redraw!'
let g:pencil_terminal_italics = 1
" function! s:enter_vimwiki()
"   set syntax=markdown
"   source ~/.vim/bundle/vimwiki/syntax/vimwiki_markdown_custom.vim
"   colorscheme pencil
" endfunction
" autocmd FileType vimwiki call s:enter_vimwiki()

" Disable SQL "help"
let g:loaded_sql_completion = 0
let g:omni_sql_no_default_maps = 1
