" Vim Configuration File v2.0.0
" ~/.vimrc
" Maintained by Kevin Gisi

function! HasGit()
  silent exec '!which git > /dev/null 2>&1'
  return !v:shell_error
endfunction

function! HasGitHub()
  let os=substitute(system('uname'), '\n', '', '')
  if os == 'Darwin' || os == 'Mac'
    silent exec '!ping -c 1 -t 1 github.com > /dev/null 2>&1'
  else
    silent exec '!ping -c 1 -w 1 github.com > /dev/null 2>&1'
  endif
  return !v:shell_error
endfunction

" Bootstrap Vundle if necessary
if HasGit()
  if !empty(glob('~/.vim/bundle/Vundle.vim'))
    source ~/.vim/vundle
  else
    if HasGitHub()
      silent exec '!echo Vundle not found. Installing...'
      silent exec '!git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim > /dev/null 2>&1'
      source ~/.vim/vundle
    endif
  endif
endif

" Dotfiles management
source ~/.vim/dotfiles

" Main configuration
source ~/.vim/vimrc_main
