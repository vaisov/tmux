syntax on
set mouse-=a
if &diff
    syntax off
endif
call plug#begin('~/.vim/plugged/')
Plug 'drewtempelmeyer/palenight.vim'
Plug 'mikelue/vim-maven-plugin'
call plug#end()
set background=dark
colorscheme palenight

" Transparent background
hi Normal guibg=NONE ctermbg=NONE

" Spaces instead of tabs in yaml files
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType sh setlocal ts=2 sts=2 sw=2 expandtab

if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif
