" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

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

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Put these in an autocmd group, so that we can delete them easily.
  augroup widths
    au!
    autocmd FileType * setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
    autocmd FileType go setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab
    autocmd FileType vim setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
    " For all text files set 'textwidth' to 80 characters.
    autocmd FileType text setlocal textwidth=80
  augroup END
else
  " Always set autoindenting on.
  set autoindent
endif " has("autocmd")

" The matchit plugin makes the % command work better,
" but it is not backwards compatible.
if has('syntax') && has('eval')
  packadd matchit
endif

" Enable Pathogen package manager.
execute pathogen#infect()

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
set background=dark
colorscheme solarized

" Open new split panes to right and bottom, which feels more
" natural than Vim’s default.
set splitbelow
set splitright

set clipboard=unnamedplus


""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""
" toggle spell-check
map <F2> :setlocal spell! spelllang=en_us<CR>

" The first part clears the last used search. It will not set the pattern to
" an empty string, because that would match everywhere. The pattern is really
" cleared, like when starting Vim.
" The second part disables highlighting, redraws the screen (default
" behavior for C-l) and moves one character to the left with 'h' (to keep
" the cursor in place).
noremap <silent> ,cl :let @/ = ""<cr> :nohls<cr><c-l>h

" Copy to system clipboard
vnoremap <C-c> "+y
nnoremap <C-p> "+P
vnoremap <C-p> "+P

" Insert a new line after the current line (don't enter insert mode).
nnoremap ,j o<Esc>
" Insert a new line before the current line (don't enter insert mode).
nnoremap ,k O<Esc>

" Quicker window movement.
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

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
" https://github.com/Yggdroot/indentLine
let g:indentLine_fileType = ['python']
" let g:indentLine_char = '>'
" let g:indentLine_leadingSpaceChar = '·'
let g:indentLine_char = '|'
let g:indentLine_leadingSpaceChar = '_'
let g:indentLine_leadingSpaceEnabled = 1


" vim-markdown - force .md files as markdown.
" https://github.com/tpope/vim-markdown
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh']
let g:markdown_minlines = 100


" vim-instant-markdown - instant markdown previews.
" https://github.com/suan/vim-instant-markdown
map <F5> :InstantMarkdownPreview<CR>
let g:instant_markdown_autostart = 0


" vim-mucomplete - minimalist autocompletion plugin.
" https://github.com/lifepillar/vim-mucomplete
set completeopt+=menuone
set completeopt-=preview
set completeopt+=noinsert
set shortmess+=c   " Shut off completion messages.
set belloff+=ctrlg " If Vim beeps during completion.
let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#delayed_completion = 1


" vimwiki - personal wiki for Vim.
" Prerequisites.
" Avoid side effects if `nocp` already set.
if &compatible | set nocompatible | endif
filetype plugin indent on
" vimwiki configuration.
let g:vimwiki_list = [{'path': '~/Documents/vimwiki', 'ext': '.md'}]
" vimwiki markdown support.
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
