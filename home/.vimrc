
set nocompatible

"Load vim-plug
if empty(glob("~/.vim/autoload/plug.vim"))
  execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.github.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall
endif

"Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged') 

"C++ Autocomplete
Plug 'Valloric/YouCompleteMe', {'do': './install.py --clang-completer'}

"Allows me to switch between cc/cpp and h files with the 'A' command
Plug 'vim-scripts/a.vim'

" Generate template code when opening new files based on their extension
Plug 'aperezdc/vim-template'

" Use cpp-lint inside vim
Plug 'funorpain/vim-cpplint'

" Mostly installed for Python lint
Plug 'vim-syntastic/syntastic'

"Shows a column to the left of each buffer to show git changes
Plug 'airblade/vim-gitgutter'

" Helps me stay organized
Plug 'vimwiki/vimwiki'


call plug#end() 

"Configure Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:ycm_confirm_extra_conf = 0
let g:ycm_global_ycm_extra_conf = '~'
let g:ycm_collect_identifiers_from_tags_files = 1





" Backup files
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Save your backups to a less annoying place than the current directory.
" If you have .vim-backup in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/backup or . if all else fails.
if isdirectory($HOME . '/.vim/backup') == 0
  silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
endif
set backupdir-=.
set backupdir+=.
set backupdir-=~/
set backupdir^=~/.vim/backup/
set backupdir^=./.vim-backup/
set backup


" Save your swp files to a less annoying place than the current directory.
" If you have .vim-swap in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/swap, ~/tmp or .
if isdirectory($HOME . '/.vim/swap') == 0
  silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=./.vim-swap//
set directory+=~/.vim/swap//
set directory+=~/tmp//
set directory+=.


" viminfo stores the the state of your previous editing session
set viminfo+=n~/.vim/viminfo



if exists("+undofile")
  " undofile - This allows you to use undos after exiting and restarting
  " This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
  " :help undo-persistence
  " This is only present in 7.3+
  if isdirectory($HOME . '/.vim/undo') == 0
    silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=./.vim-undo//
  set undodir+=~/.vim/undo//
  set undofile
endif


" UI Style/Behavior
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"keep at least 10 lines visable
set scrolloff=10 

set hidden

"Tweaks for find
set wildmenu
set wildmode=list:longest,full
set wildignore+=*.o,*.obj,*.jpg,*.png,*.pdf,*.bin

set path=.,,**

set grepprg=grep\ -nH\ $*

"hilight search results
set hlsearch

set autoindent smartindent
set relativenumber
set smartcase

set lazyredraw
set shiftwidth=2
set tabstop=2
set softtabstop=2
set expandtab
set textwidth=80
set cindent
set cinoptions=h1,l1,g1,t0,i4,+4,(0,w1,W4
set cino=N-s

filetype on
filetype plugin on
syntax enable


" Custom key mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Vertical split
map <F12> :vsp <cr>

" Correct common mistakes
command! WQ wq
command! Wq wq
command! W w
command! Q q

" Remap jj to escape in insertg mode. 
inoremap jj <Esc>

map <F2> :tabnext <cr>
map <F3> :tabprev <cr>
map <F9> :buffers <cr>




" Template stuff
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:email = "shawn@shawndooley.net"
let g:username= "Shawn Dooley"






" Syntastic config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_aggregate_errors = 1
let g:syntastic_python_pylint_exe = 'pylint3'



" Cpplint config
" let s:cpplint_cmd="cpplint"


set statusline+=%F
