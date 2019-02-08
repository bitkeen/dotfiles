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
  autocmd FileType text setlocal iskeyword-=_
  " Colorcolumns.
  autocmd FileType * setlocal colorcolumn=0
  autocmd FileType python setlocal colorcolumn=81
  autocmd FileType vim setlocal colorcolumn=81
  " Tab widths.
  autocmd FileType * setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
  autocmd FileType ledger setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab
  autocmd FileType go setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab
  autocmd FileType vim setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType xquery setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab
  " Don't automatically insert comment leader for new lines.
  autocmd FileType * setlocal formatoptions-=o
  " Open help windows in a vertical split by default.
  autocmd FileType help wincmd L
  " Show line numbers in help windows.
  autocmd FileType help setlocal number
  autocmd FileType help setlocal relativenumber
  " Only show signcolumn when there is a sign to display.
  autocmd FileType help set signcolumn=auto

  " Highlight the current line, but only in focused window.
  autocmd BufEnter,WinEnter,FocusGained * setlocal cursorline
  autocmd WinLeave,FocusLost * setlocal nocursorline
else
  " Maintain indent of current line.
  set autoindent
endif

" Automatically refresh current file on if it was changed
" outside of Vim.
set autoread
if has("autocmd")
  augroup refresh
    au!
    autocmd CursorHold,CursorHoldI * :checktime
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

" Don't insert two spaces after '.', '?' and '!' for join command.
set nojoinspaces

" Enable line numbers.
set number
" Enable relative line numbers.
set relativenumber

" Set directory to save swap files in.
set directory=~/.vim/backups/swap//

" Save backup files in ~/.vim/backups.
set backupdir=~/.vim/backups//

" Save undo files in ~/.vim/backups/undo.
set undodir=~/.vim/backups/undo

" Save viminfo in ~/.vim/.viminfo.
set viminfo+=n~/.vim/viminfo

" Search down into subfolders.
" Provides tab-completion for all file-related tasks.
set path+=**

" Default is 2000.
set redrawtime=5000

" Set colorscheme.
set background=light
" set background=dark
colorscheme solarized

" Remove comment chars when joining comments.
set formatoptions+=j

" Always show status line.
set laststatus=2

" Open new split panes to right and bottom, which feels more
" natural than Vim’s default.
set splitbelow
set splitright

set clipboard=unnamedplus

" Don't show current mode on the last line, e.g. `-- INSERT --`.
set noshowmode

" Allow cursor to move where there is no text in visual block mode.
set virtualedit=block

" Put a string at the start of lines that have been wrapped.
set showbreak=›
" set showbreak=›\ " The backslash escapes the trailing space.

" Indent wrapped lines at the same amount of space as the
" beginning of that line.
set breakindent
if exists('&breakindentopt')
  set breakindentopt=shift:1
endif

" If this many milliseconds nothing is typed the swap file
" will be written. Also used for the CursorHold event.
set updatetime=100

" Don't show intro message.
set shortmess+=I

" Command-line completion mode.
" Complete the next full m
" atch, show wildmenu.
set wildmode=full

" Ignore case when completing file names and directories.
set wildignorecase


""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin configuration
""""""""""""""""""""""""""""""""""""""""""""""""""

" indentLine - display vertical lines at each indentation level.
let g:indentLine_fileType = ['python', 'lua', 'vim', 'xquery']
let g:indentLine_char = '|'

" vim-markdown - force .md files as markdown.
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh']
let g:markdown_minlines = 100

" vim-instant-markdown - instant markdown previews.
let g:instant_markdown_autostart = 0

" vimwiki - personal wiki for Vim.
" vimwiki configuration.
let g:vimwiki_list = [{'path': '~/Documents/vimwiki', 'ext': '.md'}]
" vimwiki markdown support.
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}

" NERDTree - file system explorer.
" Close vim if the only window left open is a NERDTree.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Show hidden files by default.
let NERDTreeShowHidden=1

" Command-T - file finder.
" Set the underlying scanning implementation that should be used to explore
" the filesystem. Default value is 'ruby'.
let g:CommandTFileScanner = 'find'
" Always include matching dot-files in the match list regardless of whether
" the search string contains a dot.
let g:CommandTAlwaysShowDotFiles = 1
" Recurse into dot-directories.
let g:CommandTScanDotDirectories = 1
" Override wildignore setting during Command-T searches.
let g:CommandTWildIgnore=&wildignore . ",*/.git"

" vim-xkbswitch - automatically switch keyboard layout based on mode.
let g:XkbSwitchEnabled = 1

" vim-commentary - easy commenting
autocmd FileType xquery setlocal commentstring=(:\ %s\ :)

" vim-gitgutter - show a git diff in the sign column.
" let g:gitgutter_enabled = 0
" Always show the sign column.
if exists('&signcolumn')
  set signcolumn=yes
else
  let g:gitgutter_sign_column_always = 1
endif

" jedi-vim - Python autocompletion
let g:jedi#use_tabs_not_buffers = 1
" let g:jedi#use_splits_not_buffers = "right"
" Disable docstring window popup during completion.
autocmd FileType python setlocal completeopt-=preview

" vim-better-whitespace - show and remove trailing whitespace.
let g:better_whitespace_enabled=0
let g:strip_whitespace_on_save=0
autocmd FileType python let g:better_whitespace_enabled=1
autocmd FileType python DisableWhitespace
autocmd FileType python CurrentLineWhitespaceOff soft

" lightline.vim - a light and configurable statusline/tabline.
" Specify which feature is turned on. Both are equal to 1 by default.
let g:lightline = {
\  'enable': {
\    'statusline': 1,
\    'tabline': 1,
\  },
\  'colorscheme': 'solarized',
\  'active': {
\    'left': [ [ 'mode', 'paste' ],
\              [ 'gitbranch', 'spell', 'readonly' ],
\              [ 'absolutepath', 'ismodified' ] ],
\    'right': [ [ 'columninfo' ],
\               [ 'lineinfo' ],
\               [ 'percent' ] ],
\  },
\  'inactive': {
\    'left': [ [ 'absolutepath_inactive' ] ],
\    'right': [ [ 'lineinfo' ],
\               [ 'percent' ] ],
\  },
\  'tab': {
\    'active': [ 'tabnum', 'filename', 'modified', 'tabwinnr' ],
\    'inactive': [ 'tabnum', 'filename', 'modified', 'tabwinnr' ],
\  },
\  'component': {
\    'columninfo': ':%2v',
\    'lineinfo': '%3l/%L',
\    'spell': 'spell: %{&spell?&spelllang:""}',
\  },
\  'tab_component_function': {
\    'filename': 'lightline#tab#filename',
\    'modified': 'lightline#tab#modified',
\    'readonly': 'lightline#tab#readonly',
\    'tabnum': 'lightline#tab#tabnum',
\    'tabwinnr': 'LightLineTabWinNr',
\  },
\  'component_function': {
\    'gitbranch': 'fugitive#head',
\    'absolutepath_inactive': 'LightlinePathAndModified',
\  },
\  'component_expand': {
\    'ismodified': 'LightlineIsModified',
\  },
\  'component_type': {
\    'ismodified': 'warning',
\  },
\}
" Update lightline on certain events.
autocmd TextChanged,InsertLeave,BufWritePost * call lightline#update()

" Return number of windows in a specific tab.
function! LightLineTabWinNr(tabnr) abort
  let tabwincount = tabpagewinnr(a:tabnr, "$")
  return tabwincount > 1 ? '[' . tabwincount . ']' : ''
endfunction

" Join file path and modified (remove the separator bar).
function! LightlinePathAndModified()
  let absolutepath = expand('%:F') !=# '' ? expand('%:F') : '[No Name]'
  let modified = &modified ? ' [+]' : ''
  return absolutepath . modified
endfunction

function! LightlineIsModified()
  return &modified ? '[+]' : ''
endfunction

" vim-grepper - use search tools in a vim split.
runtime plugin/grepper.vim
" Specify the tools that are available to use. First in the list is
" the default tool.
let g:grepper.tools = ['git', 'grep']
" -i - ignore case.
" --no-index - search files in the current directory that is not
" managed by Git.
let g:grepper.git.grepprg .= ' -i --no-index'
let g:grepper.grep.grepprg .= ' -i'
" Populate the prompt with double quotes and put cursor in between.
let g:grepper.prompt_quote = 3
" let g:grepper.highlight = 1
let g:grepper.simple_prompt = 1


""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""

let mapleader=" "

" Repeat the previous macro.
nnoremap <Enter> @@

" Toggle spell-check.
map <F2> :setlocal spell! spelllang=en_us<CR>

" Use j and k if a count is specified, gj, gk if no count is specified.
" For counts larger or equal to five, set a mark that can be used in
" the jump list.
nnoremap <expr> j (v:count > 4 ? "m'" . v:count : '') . (v:count > 1 ? 'j' : 'gj')
nnoremap <expr> k (v:count > 4 ? "m'" . v:count : '') . (v:count > 1 ? 'k' : 'gk')

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
" Also set up for visual mode.
vnoremap <C-j> <C-w>j
vnoremap <C-k> <C-w>k
vnoremap <C-h> <C-w>h
vnoremap <C-l> <C-w>l

" Go to beginning or end of the line in command mode.
cnoremap <C-a> <home>
cnoremap <C-e> <end>

" Open (in) a new tab.
nnoremap <leader>gn :tabnew<Space>
" Switch tabs.
nnoremap <silent> <leader>gj :tabfirst<CR>
nnoremap <silent> <leader>gk :tablast<CR>
" Move tabs.
nnoremap <silent> <leader>gH :-tabmove<CR>
nnoremap <silent> <leader>gJ :0tabmove<CR>
nnoremap <silent> <leader>gK :$tabmove<CR>
nnoremap <silent> <leader>gL :+tabmove<CR>

" The first part clears the last used search. It will not set the pattern to
" an empty string, because that would match everywhere. The pattern is really
" cleared, like when starting Vim.
" The second part disables highlighting, redraws the screen (default
" behavior for C-l) and moves one character to the left with 'h' (to keep
" the cursor in place).
nnoremap <silent> <leader>cl :let @/ = ""<CR> :nohls<CR><c-l>h

" Reload .vimrc.
nnoremap <leader>rl :source $MYVIMRC<CR>

" Insert a new line after the current line (don't enter insert mode).
nnoremap <leader>j o<Esc>
" Insert a new line before the current line (don't enter insert mode).
nnoremap <leader>k O<Esc>

" Save.
nnoremap <leader>u :update<CR>
" Save and quit.
nnoremap <leader>x :x<CR>
" Quit without saving.
nnoremap <leader>q :q!<CR>
vnoremap <leader>q <Esc>:q!<CR>

" Edit file, starting in same directory as current file.
nnoremap <leader>e :edit <C-R>=expand('%:p:h') . '/'<CR>

nnoremap <leader>V V`]

" Yank all lines.
nnoremap <leader>ya :%y<CR>

" Open empty splits.
nnoremap <leader>- :new<CR>
nnoremap <leader>\ :vnew<CR>

" Substitute.
nnoremap <leader>s :%s/
vnoremap <leader>s :s/

" Open an empty tab and close all the other tabs.
" Don't close the buffers.
nnoremap <silent> <leader><leader>q :tabnew<CR>:tabonly<CR>

" Change inner word to upper case.
nnoremap cu gUiw
" Change inner word to lower case.
nnoremap cl guiw

" Go to tab by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <silent> <leader>0 :tablast<cr>

if has("autocmd")
  " Compiling TeX.
  augroup tex
    au!
    " Map F3 to compile LaTeX. The last <Enter> skips the log.
    autocmd FileType tex map <F3> :w<Enter>:!pdflatex<space>%<Enter><Enter>
    " Map F4 to compile XeTeX.
    autocmd FileType tex map <F4> :w<Enter>:!xelatex<space>%<Enter><Enter>
  augroup END
  " Quickfix window mappings.
  augroup qf
    au!
    " Go to older error list.
    autocmd FileType qf nnoremap <leader>H :colder<CR>
    " Go to newer error list.
    autocmd FileType qf nnoremap <leader>L :cnewer<CR>
  augroup END
endif


""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin mappings
""""""""""""""""""""""""""""""""""""""""""""""""""

" vimwiki - personal wiki for Vim.
nmap <leader>wb <Plug>VimwikiSplitLink
nmap <leader>wv <Plug>VimwikiVSplitLink

" Command-T - file finder.
" Show open buffers. Default mapping is <leader>b, remap it to
" <leader>bf because git-blame will be mapped to <leader>bl.
nmap <silent> <leader>bf <Plug>(CommandTBuffer)
" Show jumplist. Default is <leader>j, it conflicted with
" mappings for opening new lines in normal mode.
nmap <silent> <leader>l <Plug>(CommandTJump)
let g:CommandTAcceptSelectionSplitMap = '<C-b>'

" NERDTree - file system explorer.
let g:NERDTreeMapOpenInTab = '<C-t>'
let g:NERDTreeMapOpenSplit = '<C-b>'
let g:NERDTreeMapOpenVSplit = '<C-v>'

map <leader>n :NERDTreeToggle<CR>
" Find the current file in the tree.
map <leader>f :NERDTreeFind<CR>

" vim-gitgutter - show a git diff in the sign column.
map <leader>hh :GitGutterLineHighlightsToggle<CR>

" vim-instant-markdown - instant markdown previews.
map <F6> :InstantMarkdownPreview<CR>

" vim-gitgutter - show a git diff in the sign column.
map <leader>hh :GitGutterLineHighlightsToggle<CR>

" vim-better-whitespace - show and remove trailing whitespace.
map <leader>bwt :ToggleWhitespace<CR>
map <leader>bws :StripWhitespace<CR>

" git-blame.vim - see blame information in the bottom line.
nnoremap <silent> <leader>bl :<C-u>call gitblame#echo()<CR>

" Gundo - graph undo tree.
nnoremap <leader>gu :GundoToggle<CR>

" vim-grepper - use search tools in a vim split.
nnoremap <leader>gr :Grepper<CR>
" Search the word under the cursor.
nnoremap <silent> <leader>gw :Grepper -cword -noprompt<cr>
" Switch between searching tools.
let g:grepper.prompt_mapping_tool = '<leader>gr'

" jedi-vim - Python autocompletion
let g:jedi#goto_assignments_command = '<leader>ga'
let g:jedi#usages_command = '<leader>gy'

" QFEnter - open a Quickfix item in a window you choose.
let g:qfenter_keymap = {}
let g:qfenter_keymap.open = ['<CR>']
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-b>']
let g:qfenter_keymap.topen = ['<C-t>']
