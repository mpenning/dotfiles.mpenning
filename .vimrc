" Misc ************************************************************************
" set nocompatible " disable vi compat... DONT put below the 1st vimrc line
set nocompatible
let loaded_matchparen = 1 " Stop auto-paren highlighting (if enabled)
let g:netrw_dirhistmax=0  " disable ~/.vim/.netrwhist
set backspace=indent,eol,start
"" Show line numbers
" set number 
set vb t_vb= " Turn off the bell, this could be more annoying
"set isk+=_,$,@,%,#,-,. " none of these should be word dividers, so make them not be

"" Add matching for the % command below...
set matchpairs+=<:>
set noautoindent        " I indent my code myself.
set nocindent
set ttyfast
set ttyscroll=0

" Tabs ************************************************************************
set shiftwidth=4 " set shiftwidth to my code defaults (3 spaces)
set expandtab " auto expand tabs
set smarttab

" Cursor highlights ***********************************************************
set nocursorline " Ensure that the cursor's line is not highlighted
"set cursorcolumn

" Searching * *****************************************************************
set incsearch " incremental search, search as you type
set hlsearch " highlight search
set ignorecase " Ignore case when searching
set smartcase " Ignore case when searching lowercase
set gdefault  " Use 'g' flag by default with :s/foo/bar/.

" Vim UI *****************************************************************
set history=1000
set undolevels=1000
set title
set visualbell
set showcmd     " shows what you type for a command
"set modeline    " Enable modeline display  (it's best to avoid modeline)
set ruler " Show ruler
set noerrorbells
set cmdheight=1 " the command bar is 1 high
set laststatus=2
set statusline=%F%m%r%h%w\ (%{&ff}){%Y}\ [%l,%v][%p%%]
set hidden      " http://nvie.com/posts/how-i-boosted-my-vim/


"" Terminal hack for colors in PuTTY
" Source: http://vim.wikia.com/wiki/Using_vim_color_schemes_with_Putty
if &term =~ "xterm"
  if has("terminfo")
    let &t_Co=8
    let &t_Sf="\<Esc>[3%p1%dm"
    let &t_Sb="\<Esc>[4%p1%dm"
  else
    let &t_Co=8
    let &t_Sf="\<Esc>[3%dm"
    let &t_Sb="\<Esc>[4%dm"
  endif
endif

" Set Vim colorscheme... rxvt doesn't do well with ir_black
if &term =~ "rxvt"
  " Use desert with rxvt terms
  set t_Co=16
  :colors desert
else
  " Use ir_black with other terms
  set t_Co=16
  :colors ir_black
  set background=dark
endif


" Filetypes *******************************************************************
" Load filetype plugins from my .vim/ files
:filetype on
:filetype plugin on
" Enable syntax highlighting
:syntax on



" Useful Abbreviations ******************************************************
" NOTE: map  works in command mode
" NOTE: map! works in insert mode

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

"" Miscellaneous finger-savers
map q :q<CR>             " exit vim with q if no changes were made
map ;N :set number<CR>   " toggle line numbers on with ;N
map ;n :set nonumber<CR> " toggle line numbers off with ;n


"" Coding shortcuts... auto close parens and brackets
"map! ( ()<ESC>ha
"map! [ []<ESC>ha

""HTML Hacks
" Print an empty <a> tag.
map! ;h <a href=""></a><ESC>5hi
" Wrap an <a> tag around the URL under the cursor... cursor must be at the 
" beginning of the url
map ;H lBi<a href="<ESC>Ea"></a><ESC>3hi

