if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'Raimondi/delimitMate'
Plug 'preservim/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'leafgarland/typescript-vim'
Plug 'joeytwiddle/vim-diff-traffic-lights-colors'
Plug 'BenBergman/vsearch.vim'
Plug 'ocaml/vim-ocaml'
"Plug 'reasonml-editor/vim-reason-plus'
call plug#end()

" Don't be vi-compatible
set nocompatible

set autoindent
set backspace=indent,eol,start
set smarttab
" disable preview window when completing
set completeopt-=preview

" While typing a search command, show where the pattern, as it was typed
" so far, matches.
set incsearch
" Use <C-L> to clear the highlighting of :set hlsearch.
nnoremap <silent> <C-L> :nohlsearch<CR>

" The last window will always have a status line
set laststatus=2

" Show the line and column number of the cursor position,
" separated by a comma
set ruler

" When 'wildmenu' is on,
" command-line completion operates in an enhanced mode.
set wildmenu

" Minimal number of screen lines to keep above and below the cursor.
set scrolloff=5

" When a file has been detected to have been changed outside of Vim and
" it has not been changed inside of Vim, automatically read it again.
set autoread

" A history of ":" commands, and a history of previous search patterns
" is remembered.
set history=1000

filetype plugin indent on

" Maximum width of text that is being inserted.
set textwidth=80

" Print the line number in front of each line.
set nonumber

" Number of spaces that a <Tab> in the file counts for.
set tabstop=4

" Number of spaces to use for each step of (auto)indent.
" Used for |'cindent'|, |>>|, |<<|, etc.
set shiftwidth=4

" Don't use real <TAB>s
set expandtab

" Don't make a backup before overwriting a file.
set nobackup
set nowritebackup

" Don't use a swapfile for the buffer.
set noswapfile

" Show (partial) command in the last line of the screen.
set showcmd

" Maximum number of changes that can be undone.
set undolevels=1000

" Save the whole buffer for undo when reloading it.
set undoreload=10000

" When on, the ":substitute" flag 'g' is default on.  This means that
" all matches in a line are substituted instead of one.
set gdefault

" Ignore case in search patterns. Also used when searching in the tags file.
set ignorecase

" Override the 'ignorecase' option if the search pattern contains upper
" case characters.
set smartcase

" When non-empty, specifies the key sequence that toggles the 'paste' option
set pastetoggle=<F2>

" When included, Vim will use the clipboard register '*'
" for all yank, delete, change and put operations which
" would normally go to the unnamed register.
set clipboard=unnamed

" Automatic reload of .vimrc
autocmd! bufwritepost .vimrc source %

" Remove trailing whitespace on save for ___ files
function! s:RemoveTrailingWhitespaces()
    "Save last cursor position
    let l = line(".")
    let c = col(".")

    %s/\s\+$//ge

    call cursor(l,c)
endfunction
" autocmd BufWritePre * :call <SID>RemoveTrailingWhitespaces()

" Start highlighting, use 'background' to set colors
syntax on

"highlight Normal ctermbg=Black ctermfg=White

" When set to "dark", Vim will try to use colors that look good on a
" dark background.  When set to "light", Vim will try to use colors that
" look good on a light background.
"set background=dark

" 'colorcolumn' is a comma separated list of screen columns that are
" highlighted with ColorColumn |hl-ColorColumn|.
set colorcolumn=81
highlight colorcolumn ctermfg=Black ctermbg=White     cterm=none
highlight visual      ctermfg=White ctermbg=LightBlue cterm=none
highlight MatchParen                ctermbg=Blue      cterm=underline

" Show trailing whitespace
highlight extrawhitespace ctermbg=red cterm=none
autocmd InsertEnter * match extrawhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match extrawhitespace /\s\+$/

" Mistakes
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" Keep selection after indentation
vnoremap < <gv
vnoremap > >gv

let mapleader = ","

" Tab navigation
nnoremap <Leader>t :tabnew<CR>

nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>Q :q!<CR>

let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1

" single click will open directory nodes, while a double
" click will still be required for file nodes
let g:NERDTreeMouseMode = 2

" let g:netrw_winsize = 25
" let g:netrw_liststyle = 3     " tree list style on netrw
" let g:netrw_banner = 0        " no banner
" let g:netrw_browse_split = 3  " open files in a new tab
" let g:netrw_browse_split = 4  " open in previous window
" hitting <v> opens a window at right side (default is left side)
" let g:netrw_altv = 1
" augroup ProjectDrawer
"   autocmd!
"   autocmd VimEnter * :Vexplore
" augroup END

map <F4> :NERDTreeToggle<CR>
" nnoremap <Leader>n :NERDTreeToggle<CR>
" nnoremap <Leader>f :NERDTreeFind<CR>
" map <F4> :NERDTreeFind<CR>

" auto-close NERDTree when the last file is closed
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" ignore files in .gitignore
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" leafgarland/typescript-vim'
let g:typescript_indent_disable = 1

autocmd FileType ocaml setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  " bind K to grep word under cursor
  " nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

  " bind \ (backward slash) to grep shortcut
  command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
  nnoremap \ :Ag<SPACE>
endif
