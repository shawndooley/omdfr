set nocompatible

" Load vim-plug

if empty(glob("~/.config/nvim/autoload/plug.vim"))
  execute '!curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.github.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall
endif


call plug#begin('~/.config/nvim/plugged') 

# Async linter
Plug 'w0rp/ale'


call plug#end()
