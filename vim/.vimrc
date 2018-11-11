" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

if has("vms")
  " Do not keep a backup file, use versions instead.
  set nobackup
else
  " Keep a backup file (restore to previous version).
  set backup
  if has('persistent_undo')
    " Keep an undo file (undo changes after closing).
    set undofile
  endif
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

if exists('$TMUX')
    " Wrap escape sequences for tmux.
    let &t_SI = "\ePtmux;\e\e[5 q\e\\"
    let &t_EI = "\ePtmux;\e\e[2 q\e\\"
    let &t_SR = "\ePtmux;\e\e[3 q\e\\"
else
    " Blinking bar cursor in insert mode.
    let &t_SI = "\e[5 q"
    " Steady block cursor in normal mode.
    let &t_EI = "\e[2 q"
    " Blinking underscore cursor in replace mode.
    let &t_SR = "\e[3 q"
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  au!
  " Make underscore a word separator.
  autocmd FileType * setlocal iskeyword-=_
  autocmd FileType python setlocal iskeyword+=_
  " Colorcolumns.
  autocmd FileType * setlocal colorcolumn=0
  autocmd FileType python setlocal colorcolumn=81
  autocmd FileType vim setlocal colorcolumn=81
  " Tab widths.
  autocmd FileType * setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
  autocmd FileType go setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab
  autocmd FileType vim setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType xquery setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab
else
  " Always set autoindenting on.
  set autoindent
endif

" Automatically refresh current file on if it was changed
" outside of Vim.
set autoread
if has("autocmd")
  augroup refresh
    au!
    autocmd CursorHold,CursorHoldI * checktime
    autocmd FocusGained,BufEnter * :checktime
  augroup END
endif

" The matchit plugin makes the % command work better,
" but it is not backwards compatible.
if has('syntax') && has('eval')
  packadd matchit
endif

" Avoid side effects if `nocp` already set.
if &compatible | set nocompatible | endif
filetype plugin indent on

" Enable Pathogen package manager.
execute pathogen#infect()
" Generate documentation.
call pathogen#helptags()

" Enable syntax highlighting.
syntax enable

" If you set the 'incsearch' option, Vim will show the first match
" for the pattern, while you are still typing it. This quickly shows a
" typo in the pattern.
set incsearch

" Make search case-insensitive.
set ignorecase

" Enable line numbers.
set number
" Enable relative line numbers.
set relativenumber

" Save backup files in ~/.vim/backups.
set backupdir=~/.vim/backups

" Save undo files in ~/.vim/backups/undo.
set undodir=~/.vim/backups/undo

" Save viminfo in ~/.vim/.viminfo.
set viminfo+=n~/.vim/viminfo

" Search down into subfolders.
" Provides tab-completion for all file-related tasks.
set path+=**

" Set colorscheme.
set background=light
" set background=dark
colorscheme solarized

" Highlight the current line.
set cursorline

" Open new split panes to right and bottom, which feels more
" natural than Vim’s default.
set splitbelow
set splitright

set clipboard=unnamedplus

" Put a string at the start of lines that have been wrapped.
set showbreak=›\ " The backslash escapes the trailing space.
" Indent wrapped lines at the same amount of space as the
" beginning of that line.
set breakindent

" If this many milliseconds nothing is typed the swap file
" will be written. Also used for the CursorHold event.
set updatetime=100


""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""

let mapleader=","

" Repeat the previous macro.
nnoremap <Enter> @@

" Toggle spell-check.
map <F2> :setlocal spell! spelllang=en_us<CR>

" By default Y is synonym for yy. Remap it to yank from
" the cursor to the end of the line, similar to C or D.
noremap Y y$

" Copy to system clipboard.
vnoremap <C-c> "+y
nnoremap <C-p> "+P
vnoremap <C-p> "+P

" Quicker window movement.
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Tab operations.
nnoremap tn :tabnew<Space>
nnoremap <silent> th :tabprev<CR>
nnoremap <silent> tj :tabfirst<CR>
nnoremap <silent> tk :tablast<CR>
nnoremap <silent> tl :tabnext<CR>

" The first part clears the last used search. It will not set the pattern to
" an empty string, because that would match everywhere. The pattern is really
" cleared, like when starting Vim.
" The second part disables highlighting, redraws the screen (default
" behavior for C-l) and moves one character to the left with 'h' (to keep
" the cursor in place).
nnoremap <silent> <leader>cl :let @/ = ""<CR> :nohls<CR><c-l>h

" Reload .vimrc.
nnoremap <F5> :source $MYVIMRC<CR>

" Insert a new line after the current line (don't enter insert mode).
nnoremap <leader>j o<Esc>
" Insert a new line before the current line (don't enter insert mode).
nnoremap <leader>k O<Esc>

" Save.
nnoremap <leader>u :update<CR>
" Save and quit.
nnoremap <leader>x :x<CR>
" Quit without saving.
nnoremap <leader>zq ZQ

" Yank all lines.
nnoremap <leader>ya :%y<CR>

if has("autocmd")
  " Compiling TeX.
  augroup tex
    au!
    " Map F3 to compile LaTeX. The last <Enter> skips the log.
    autocmd FileType tex map <F3> :w<Enter>:!pdflatex<space>%<Enter><Enter>
    " Map F4 to compile XeTeX.
    autocmd FileType tex map <F4> :w<Enter>:!xelatex<space>%<Enter><Enter>
  augroup END
endif


""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""

" indentLine - display vertical lines at each indentation level.
let g:indentLine_fileType = ['python', 'lua', 'vim', 'xquery']
let g:indentLine_char = '|'
" let g:indentLine_leadingSpaceEnabled = 1
" let g:indentLine_leadingSpaceChar = '·'
" let g:indentLine_leadingSpaceChar = '_'

" vim-markdown - force .md files as markdown.
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh']
let g:markdown_minlines = 100

" vim-instant-markdown - instant markdown previews.
map <F6> :InstantMarkdownPreview<CR>
let g:instant_markdown_autostart = 0

" vimwiki - personal wiki for Vim.
" vimwiki configuration.
let g:vimwiki_list = [{'path': '~/Documents/vimwiki', 'ext': '.md'}]
" vimwiki markdown support.
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}

" NERDTree - file system explorer
map <leader>n :NERDTreeToggle<CR>
" Find the current file in the tree.
map <leader>f :NERDTreeFind<CR>
" Remap from 't' so that it does not conflict with tab operation
" mappings like 'tn', 'tj', etc.
let g:NERDTreeMapOpenInTab = 'tt'
" Close vim if the only window left open is a NERDTree.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Command-T - file finder.
" Set the underlying scanning implementation that should be used to explore
" the filesystem. Default value is 'ruby'.
let g:CommandTFileScanner = 'find'
" Always include matching dot-files in the match list regardless of whether
" the search string contains a dot.
let g:CommandTAlwaysShowDotFiles = 1
let g:CommandTAcceptSelectionSplitMap = '<C-b>'

" vim-xkbswitch - automatically switch keyboard layout based on mode.
let g:XkbSwitchEnabled = 1

" vim-gitgutter - show a git diff in the sign column
" let g:gitgutter_enabled = 0
" Always show the sign column.
if exists('&signcolumn')
  set signcolumn=yes
else
  let g:gitgutter_sign_column_always = 1
endif
map <leader>hh :GitGutterLineHighlightsToggle<CR>

" jedi-vim - Python autocompletion
let g:jedi#use_tabs_not_buffers = 1
" let g:jedi#use_splits_not_buffers = "right"
" Disable docstring window popup during completion.
autocmd FileType python setlocal completeopt-=preview

" vim-better-whitespace - show and remove trailing whitespace.
map <leader>sw :StripWhitespace<CR>
autocmd FileType * let g:better_whitespace_enabled=0
autocmd FileType python let g:better_whitespace_enabled=1
autocmd FileType python CurrentLineWhitespaceOff soft
