syntax on
set mouse-=a
if &diff
    syntax off
endif
call plug#begin('~/.vim/plugged/')
Plug 'drewtempelmeyer/palenight.vim'
call plug#end()
set background=dark
colorscheme palenight
hi Normal guibg=NONE ctermbg=NONE
