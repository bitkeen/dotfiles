" Main {{{

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
  " Enable mouse when in tmux.
  set ttymouse=xterm2

  " Bracketed paste works by default in Vim 8, but not when in tmux.
  let &t_BE = "\<Esc>[?2004h"
  let &t_BD = "\<Esc>[?2004l"
  let &t_PS = "\<Esc>[200~"
  let &t_PE = "\<Esc>[201~"

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

" Maintain indent of current line.
set autoindent

" Only do this part when compiled with support for autocommands.
if has('autocmd')
  augroup main
    autocmd!

    " Don't automatically insert comment leader for new lines.
    autocmd FileType * setlocal formatoptions-=o

    " Make underscore a word separator.
    autocmd FileType text setlocal iskeyword-=_

    " Colorcolumns.
    autocmd FileType * setlocal colorcolumn=0
    autocmd FileType c setlocal colorcolumn=81
    autocmd FileType lua setlocal colorcolumn=81
    autocmd FileType python setlocal colorcolumn=81
    autocmd FileType vim setlocal colorcolumn=81
    autocmd FileType sh setlocal colorcolumn=81

    " Tab widths.
    autocmd FileType * setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
    autocmd FileType ledger setlocal noexpandtab
    autocmd FileType go setlocal noexpandtab
    autocmd FileType xquery setlocal noexpandtab
    autocmd FileType vim setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType json setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType yaml* setlocal tabstop=2 shiftwidth=2 softtabstop=2

    " Open help windows in a vertical split by default.
    autocmd FileType help wincmd L
    " Show line numbers in help windows.
    autocmd FileType help setlocal number
    autocmd FileType help setlocal relativenumber
    " Only show signcolumn when there is a sign to display.
    autocmd FileType help setlocal signcolumn=auto

    " Highlight the current line, but only in focused window.
    autocmd BufEnter,WinEnter,FocusGained * setlocal cursorline
    autocmd WinLeave,FocusLost * setlocal nocursorline

    " Use Markdown in calcurse notes.
    autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown

    " See https://github.com/posva/vim-vue#my-syntax-highlighting-stops-working-randomly.
    autocmd FileType vue syntax sync fromstart
  augroup END

  augroup folding
    autocmd!
    autocmd FileType python setlocal foldmethod=indent
    autocmd FileType yaml setlocal foldmethod=indent
    autocmd FileType html,xml setlocal foldmethod=indent
    autocmd BufWinEnter .vimrc,.bash*,.tmux.conf,*/i3/config setlocal foldmethod=marker
    autocmd BufWinEnter .vimrc,.bash*,.tmux.conf,*/i3/config setlocal foldlevel=0
  augroup END
endif

" Automatically refresh current file on if it was changed
" outside of Vim.
set autoread
if has("autocmd")
  augroup refresh
    autocmd!
    " 'checktime' causes errors in command line windows
    " (q/, q:), 'silent!' ignores these errors
    autocmd CursorHold,CursorHoldI * :silent! checktime
    autocmd FocusGained,BufEnter * :silent! checktime
  augroup END
endif

" The matchit plugin makes the % command work better,
" but it is not backwards compatible.
if has('syntax') && has('eval')
  packadd matchit
endif

" Enable Pathogen package manager.
execute pathogen#infect()
" Generate documentation.
call pathogen#helptags()

filetype plugin indent on

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
set directory=~/.vim/tmp/swap//

" Save backup files in ~/.vim/backups.
set backupdir=~/.vim/tmp/backup//

" Save undo files in ~/.vim/backups/undo.
set undodir=~/.vim/tmp/undo//

" Save viminfo in ~/.vim/.viminfo.
set viminfo+=n~/.vim/tmp/viminfo

" A view is a vim script that resotres the contents of the current
" window.
set viewdir=~/.vim/tmp/view//

" Search down into subfolders.
" Provides tab-completion for all file-related tasks.
set path+=**

" Default is 2000.
set redrawtime=10000

" Remove comment chars when joining comments.
set formatoptions+=j

" Show trailing whitespace as middle dots (when 'list' is set).
" Tab is U+21B9. Slash escapes the space.
" Nbsp is U+25AF.
set listchars=trail:·,tab:↹\ ,nbsp:▯

" Always show status line.
set laststatus=2

" Always start editing with all folds open.
set foldlevelstart=99

" Open new split panes to right and bottom, which feels more
" natural than Vim’s default.
set splitbelow
set splitright

set clipboard=unnamedplus

" Don't show current mode on the last line, e.g. `-- INSERT --`.
set noshowmode

" Don't move the cursor to the first non-blank of the line
" on Ctrl-D, Ctrl-U, gg, G, etc.
set nostartofline

" Allow cursor to move where there is no text in visual block mode.
set virtualedit=block

" Put a string at the start of lines that have been wrapped.
set showbreak=›

" Indent wrapped lines at the same amount of space as the
" beginning of that line.
set breakindent
if exists('&breakindentopt')
  set breakindentopt=shift:1
endif

" If this many milliseconds nothing is typed the swap file
" will be written. Also used for the CursorHold event.
set updatetime=100

" Commandline history size. Default is 50.
if &history < 1000
  set history=1000
endif

" Don't show intro message.
set shortmess+=I

" Command-line completion mode.
" Complete the next full m
" atch, show wildmenu.
set wildmode=full

" Ignore case when completing file names and directories.
set wildignorecase

" Instead of failing a command because of unsaved changes, raise
" a dialog asking if you wish to save changed files.
set confirm

" Vim before 8.1.1365 is vulnerable to arbitrary code execution via modelines
" by opening a specially crafted text file.
if !has("patch-8.1-1366")
  set nomodeline
else
  " Disallow options that are an epxression to be set in the modeline.
  " Default is off, but it is still included here.
  set nomodelineexpr
endif

" Netrw
let g:netrw_banner=0
" Tree view.
let g:netrw_liststyle=3
" Directory where netrw saves .netrwhist and .netrwbook.
let g:netrw_home = '~/.vim/tmp'

" Enable basic fzf plugin.
set rtp+=/usr/bin/fzf

" }}}

" Plugin configuration {{{

augroup plugins
  autocmd!
augroup END

" indentLine - display vertical lines at each indentation level.
let g:indentLine_fileType = ['python', 'lua', 'vim', 'xquery']
" U+2502: BOX DRAWINGS LIGHT VERTICAL.
let g:indentLine_char = '│'

" vim-instant-markdown - instant markdown previews.
let g:instant_markdown_autostart = 0

" vimwiki - personal wiki for Vim. {{{
let g:vimwiki_list = [
\  {'path': '~/sync/wikis/mainwiki', 'syntax': 'markdown', 'ext': '.md'},
\  {'path': '~/sync/wikis/phonewiki', 'syntax': 'markdown', 'ext': '.md'},
\  {'path': '~/sync/wikis/workwiki', 'syntax': 'markdown', 'ext': '.md'},
\]
" vimwiki markdown support.
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
let g:vimwiki_hl_headers = 1
" }}}

" Command-T - file finder. {{{
" Set the underlying scanning implementation that should be used to explore
" the filesystem. Default value is 'ruby'.
let g:CommandTFileScanner = 'find'
" Always include matching dot-files in the match list regardless of whether
" the search string contains a dot.
let g:CommandTAlwaysShowDotFiles = 1
" Recurse into dot-directories.
let g:CommandTScanDotDirectories = 1
" Override wildignore setting during Command-T searches.
let g:CommandTWildIgnore=&wildignore . ",*/.git,Session.vim,*/.vim/tmp"
let g:CommandTMaxFiles=500000
" Traverse upwards looking for an SCM root, start from Vim's present
" working directory.
" Better than setting to 'file' when submodules are present.
let g:CommandTTraverseSCM='dir'
" }}}

" vim-xkbswitch - automatically switch keyboard layout based on mode.
let g:XkbSwitchEnabled = 1

" vim-commentary - easy commenting. {{{
autocmd plugins FileType abp setlocal commentstring=!%s
autocmd plugins FileType requirements setlocal commentstring=#\ %s
autocmd plugins FileType xquery setlocal commentstring=(:\ %s\ :)
autocmd plugins FileType xdefaults setlocal commentstring=!%s
" }}}

" vim-gitgutter - show a git diff in the sign column. {{{
" Always show the sign column.
if exists('&signcolumn')
  set signcolumn=yes
else
  let g:gitgutter_sign_column_always = 1
endif
" }}}

" jedi-vim - Python autocompletion
" Disable jedi completions as they are now handled by completor.
let g:jedi#completions_enabled = 0

" lightline.vim - a light and configurable statusline/tabline {{{
" Specify which feature is turned on. Both are equal to 1 by default.
let g:lightline = {
\  'enable': {
\    'statusline': 1,
\    'tabline': 1,
\  },
\  'colorscheme': 'powerline_custom',
\  'active': {
\    'left': [ [ 'mode', 'paste' ],
\              [ 'gitbranch', 'spell', 'isreadonly' ],
\              [ 'keyboard_layout', 'absolutepath', 'ismodified' ] ],
\    'right': [ [ 'columninfo' ],
\               [ 'lineinfo' ],
\               [ 'percent', 'session', 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ] ],
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
\    'session': '%{ObsessionStatus()}',
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
\    'keyboard_layout': 'LightlineXkbSwitch',
\  },
\  'component_expand': {
\    'ismodified': 'LightlineIsModified',
\    'isreadonly': 'LightlineIsReadonly',
\    'linter_checking': 'lightline#ale#checking',
\    'linter_warnings': 'lightline#ale#warnings',
\    'linter_errors': 'lightline#ale#errors',
\    'linter_ok': 'lightline#ale#ok',
\  },
\  'component_type': {
\    'ismodified': 'warning',
\    'isreadonly': 'warning',
\    'linter_checking': 'left',
\    'linter_warnings': 'warning',
\    'linter_errors': 'error',
\    'linter_ok': 'left',
\  },
\  'component_visible_condition': {
\    'session': 'ObsessionStatus()',
\  },
\  'mode_map': {
\    'n' : 'N',
\    'i' : 'I',
\    'R' : 'R',
\    'v' : 'V',
\    'V' : 'VL',
\    "\<C-v>": 'VB',
\    'c' : 'C',
\    's' : 'S',
\    'S' : 'S',
\    "\<C-s>": 'SB',
\    't': 'T',
\  },
\}

" Update lightline on certain events.
autocmd plugins TextChanged,InsertLeave,BufWritePost * call lightline#update()

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

function! LightlineIsReadonly()
  return &readonly ? 'RO' : ''
endfunction

" Get keyboard layout using vim-xkbswitch.
" Borrowed from airline.
function! LightlineXkbSwitch()
  if !exists('g:XkbSwitchLib')
    return
  endif

  let keyboard_layout = libcall(g:XkbSwitchLib, 'Xkb_Switch_getXkbLayout', '')
  let keyboard_layout = split(keyboard_layout, '\.')[-1]
  let short_codes = get(g:, 'short_codes', {'us': 'US', 'ru': 'RU', 'ua': 'UA'})

  if has_key(short_codes, keyboard_layout)
    let keyboard_layout = short_codes[keyboard_layout]
  endif
  return keyboard_layout
endfunction
" }}}

" base16-vim - themes {{{
" Colorscheme local customization.
function! s:base16_tomorrow_night_custom() abort
  call Base16hi("PMenuSel", g:base16_gui05, g:base16_gui01, g:base16_cterm05, g:base16_cterm01, "reverse", "")
  call Base16hi("Comment", g:base16_gui03, "", g:base16_cterm03, "", "italic", "")
endfunction

augroup on_change_colorscheme
  autocmd!
  autocmd ColorScheme base16-tomorrow-night call s:base16_tomorrow_night_custom()
augroup END

" .vimrc_background sets colorscheme.
if filereadable(expand("~/.vimrc_background"))
  " Access colors present in 256 colorspace.
  let base16colorspace=256
  source ~/.vimrc_background
endif
" }}}

" vim-grepper - use search tools in a vim split. {{{
runtime plugin/grepper.vim
" Specify the tools that are available to use. First in the list is
" the default tool.
let g:grepper.tools = ['rg', 'git', 'grep']
" Global config for rg is in .dotfiles/rg/.config/rg/rgconfig.
" Don't forget to stow it and export RIPGREP_CONFIG_PATH.
" -i - ignore case.
" --no-index - search files in the current directory that is not
" managed by Git.
let g:grepper.git.grepprg .= ' -i --no-index'
let g:grepper.grep.grepprg .= ' -i'
" Populate the prompt with double quotes and put cursor in between.
let g:grepper.prompt_quote = 3
" let g:grepper.highlight = 1
let g:grepper.simple_prompt = 1
" }}}

" Gundo - graph undo tree.
let g:gundo_prefer_python3 = 1

" vim-slime
let g:slime_target = "tmux"
let g:slime_paste_file = tempname()
augroup slime
  autocmd!
  " Disable linting.
  autocmd BufWinEnter */.vim/slime/repl.py :ALEDisable
  autocmd BufWinEnter */.vim/slime/repl.lua :ALEDisable
  " Enable auto-save.
  autocmd BufWinEnter */.vim/slime/repl.py :AutoSaveToggle
  autocmd BufWinEnter */.vim/slime/repl.lua :AutoSaveToggle
  " Don't display the auto-save notification.
  autocmd BufWinEnter */.vim/slime/repl.py :let g:auto_save_silent = 1
  autocmd BufWinEnter */.vim/slime/repl.lua :let g:auto_save_silent = 1
augroup END

" UltiSnips - snippets.
let g:UltiSnipsEditSplit = 'context'
let g:UltiSnipsSnippetDirectories = [$HOME.'/.vim/ultisnips']

" pydoc.vim
let g:pydoc_open_cmd = 'vsplit'
let g:pydoc_highlight = 0

autocmd plugins FileType todo :AutoSaveToggle

" }}}

" Mappings {{{

let mapleader=" "
" Backslash needs to be escaped.
let maplocalleader="\\"

" Toggle spell-check.
map <LocalLeader>s :setlocal spell! spelllang=en_us<CR>

" Use j and k if a count is specified, gj, gk if no count is specified.
" For counts larger or equal to five, set a mark that can be used in
" the jump list.
nnoremap <expr> j (v:count > 4 ? "m'" . v:count : '') . (v:count >= 1 ? 'j' : 'gj')
nnoremap <expr> k (v:count > 4 ? "m'" . v:count : '') . (v:count >= 1 ? 'k' : 'gk')
" No marks in visual mode.
vnoremap <expr> j v:count > 1 ? 'j' : 'gj'
vnoremap <expr> k v:count > 1 ? 'k' : 'gk'

nnoremap gj j
nnoremap gk k
vnoremap gj j
vnoremap gk k

" By default Y is synonym for yy. Remap it to yank from
" the cursor to the end of the line, similar to C or D.
noremap Y y$

" Write with sudo.
" See https://stackoverflow.com/a/7078429.
nnoremap <Leader>U :write !sudo tee > /dev/null %<CR>

" Quicker window movement.
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l

" Go to beginning or end of the line in command mode.
cnoremap <C-a> <home>
cnoremap <C-e> <end>

" Open (in) a new tab.
nnoremap <Leader>gn :tabnew<Space>
" Switch tabs.
nnoremap <silent> <Leader>gj :tabfirst<CR>
nnoremap <silent> <Leader>gk :tablast<CR>
" Move tabs.
nnoremap <silent> <Leader>gH :-tabmove<CR>
nnoremap <silent> <Leader>gJ :0tabmove<CR>
nnoremap <silent> <Leader>gK :$tabmove<CR>
nnoremap <silent> <Leader>gL :+tabmove<CR>

" The first part clears the last used search. It will not set the pattern to
" an empty string, because that would match everywhere. The pattern is really
" cleared, like when starting Vim.
" The second part disables highlighting, redraws the screen (default
" behavior for C-l) and moves one character to the left with 'h' (to keep
" the cursor in place).
nnoremap <silent> <Leader>l :let @/ = ""<CR> :nohlsearch<CR><c-l>h

" Reload .vimrc.
nnoremap <LocalLeader>r :source $MYVIMRC<CR>

" Save.
nnoremap <Leader>u :update<CR>
" Save and quit.
nnoremap <Leader>x :x<CR>
" Quit without saving.
nnoremap <Leader>q :q<CR>
vnoremap <Leader>q <Esc>:q<CR>

" Edit file, starting in same directory as current file.
nnoremap <Leader>ew :edit <C-R>=expand('%:p:h') . '/'<CR>
nnoremap <Leader>eb :split <C-R>=expand('%:p:h') . '/'<CR>
nnoremap <Leader>ev :vsplit <C-R>=expand('%:p:h') . '/'<CR>
nnoremap <Leader>et :tabedit <C-R>=expand('%:p:h') . '/'<CR>

" Visually select last changed or yanked text.
nnoremap <Leader>v `[v`]

" Open empty splits.
nnoremap <Leader>- :new<CR>
nnoremap <Leader>\ :vnew<CR>
" Without switching to normal mode, new split will be zoomed.
vnoremap <Leader>- <Esc>:new<CR>
vnoremap <Leader>\ <Esc>:vnew<CR>
" Similar to 'split-window -f' in tmux, split the whole page.
" -1 is to accouunt for the command line.
nnoremap <silent><Leader>_ :new<CR><C-w>J:exec 'resize ' . (&lines/2-1)<CR>
" Need to escape '|'.
nnoremap <silent><Leader>\| :vnew<CR><C-w>L:exec 'vertical resize ' . (&columns/2)<CR>
" Open a new empty tab.
nnoremap <Leader>/ :tabnew<CR>

" Open current file in a vertical split.
nnoremap <Leader><C-v> :vsplit %<CR>
nnoremap <Leader><C-b> :split %<CR>

" Substitute.
nnoremap <Leader>s :%s/
vnoremap <Leader>s :s/

" Remove trailing whitespace.
nnoremap <LocalLeader>tw :%s/\s\+$//e<CR>
vnoremap <LocalLeader>tw :s/\s\+$//e<CR>

" Remove empty lines through entire file.
nnoremap <Leader>el :g/^$/d<CR>

" Make all windows the same height and width.
nnoremap <Leader>= <C-W>=

" Open an empty tab and close all the other tabs.
" Don't close the buffers.
nnoremap <silent> <LocalLeader>qq :tabnew<CR>:tabonly<CR>
" Close all buffers.
nnoremap <silent> <LocalLeader>qa :qa!<CR>
" Leave only current tab and current window.
nnoremap <silent> <LocalLeader>qo :tabonly<CR>:only<CR>

" Repeat the previous @, can be used with a count.
nnoremap <Leader><Leader> @@

nnoremap [h :help<Space>
nnoremap ]h :tab help<Space>

" Compare buffers in current tab.
nnoremap [w :windo diffthis<CR>
" Turn diff mode off.
nnoremap ]w :windo diffoff<CR>

" Go to tab by number
noremap <Leader>1 1gt
noremap <Leader>2 2gt
noremap <Leader>3 3gt
noremap <Leader>4 4gt
noremap <Leader>5 5gt
noremap <Leader>6 6gt
noremap <Leader>7 7gt
noremap <Leader>8 8gt
" 9 instead of 0, similar to the default mapping in Firefox.
noremap <silent> <Leader>9 :tablast<CR>

" Put the text after current line.
nnoremap <Leader>p :put<CR>
" Put the text before current line.
nnoremap <Leader>P :put!<CR>

nnoremap <Leader>o :copen<CR>

" Default mappings for [f and ]f are the same as "gf" and are deprecated.
" Show current filetype.
nnoremap [f :echo &filetype<CR>
" Change filetype.
nnoremap ]f :set filetype=

" Toggle invisible characters.
nnoremap <LocalLeader>l :set list!<CR>

" Insert a space before/after the current position.
nnoremap [<Space> i<Space><Esc>
nnoremap ]<Space> a<Space><Esc>
" Insert a blank line below/above the current line.
nnoremap [n O<Esc>j
nnoremap ]n o<Esc>k

nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>

if has("autocmd")
  " Compiling TeX.
  augroup texmaps
    autocmd!
    " Map F3 to compile LaTeX. The last <Enter> skips the log.
    autocmd FileType tex noremap <F3> :w<Enter>:!pdflatex<Space>%<Enter><Enter>
    " Map F4 to compile XeTeX.
    autocmd FileType tex noremap <F4> :w<Enter>:!xelatex<Space>%<Enter><Enter>
  augroup END
  " Quickfix window mappings.
  augroup qfmaps
    autocmd!
    " Go to older error list.
    autocmd FileType qf nnoremap <Leader>H :colder<CR>
    " Go to newer error list.
    autocmd FileType qf nnoremap <Leader>L :cnewer<CR>
  augroup END
  augroup htmlmaps
    " Pretty format current buffer using tidy.
    autocmd FileType html nnoremap <F4> :silent % !tidy -q -i --show-errors 0<CR>
    autocmd FileType xml nnoremap <F4> :silent % !tidy -q -i --show-errors 0 -xml<CR>
  augroup END
endif

" Pretty format a JSON buffer.
nnoremap <LocalLeader>j :%!python -m json.tool<CR>

" Replace search term under the cursor, dot repeats the change.
nnoremap c* *Ncgn
nnoremap c# #NcgN

" }}}

" Plugin mappings {{{

" Netrw - file explorer {{{
nnoremap <silent> <Leader>ft :Texplore<CR>
nnoremap <silent> <Leader>fb :Sexplore<CR>
nnoremap <silent> <Leader>fv :Vexplore!<CR>
" }}}

" vimwiki - personal wiki for Vim.
" Default is "<Leader>wt".
nmap <Leader>wT <Plug>VimwikiTabIndex
nmap <Leader>wb <Plug>VimwikiSplitLink
nmap <Leader>wv <Plug>VimwikiVSplitLink
nmap <Leader>wt <Plug>VimwikiTabnewLink
nmap glt <Plug>VimwikiToggleListItem

" Command-T - file finder.
" Show open buffers. Default mapping is <Leader>b, remap it to
" <Leader>bf because git-blame will be mapped to <Leader>bl.
nmap <silent> <Leader>bf <Plug>(CommandTBuffer)
let g:CommandTAcceptSelectionSplitMap = '<C-b>'

" git-blame.vim - see blame information in the bottom line.
nnoremap <silent> <Leader>bl :<C-u>call gitblame#echo()<CR>

" Gundo - graph undo tree.
nnoremap <Leader>gu :GundoToggle<CR>

" vim-grepper - use search tools in a vim split.
nnoremap <Leader>gr :Grepper<CR>
" Switch between searching tools.
let g:grepper.prompt_mapping_tool = '<Leader>gr'
" Take any motion and start searching for the selected query right away.
nmap gs <Plug>(GrepperOperator)
xmap gs <Plug>(GrepperOperator)

" jedi-vim - Python autocompletion
" <Leader>d is default. Leave it here for visibility.
let g:jedi#goto_command = '<Leader>d'
" <Leader>r is default. Leave it here for visibility.
let g:jedi#rename_command = '<Leader>r'
" Default is <Leader>g.
let g:jedi#goto_assignments_command = '<Leader>ga'
" Default is <Leader>n.
let g:jedi#usages_command = '<Leader>gy'
" Default is <C-space> which conflicts with Tmux prefix binding.
let g:jedi#completions_command = '<C-n>'

" QFEnter - open a Quickfix item in a window you choose.
let g:qfenter_keymap = {}
let g:qfenter_keymap.open = ['<CR>']
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-b>']
let g:qfenter_keymap.topen = ['<C-t>']

" CamelCaseMotion - CamelCase and snake_case movement mappings.
call camelcasemotion#CreateMotionMappings('<LocalLeader>')

" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" fugitive - Git wrapper
" By default, Ctrl-g prints information about current file, which
" is not useful since this information is already in lightline.
noremap <C-g>ed :Gedit<Space>
noremap <C-g>bl :Gblame<CR>
noremap <C-g>br :Gbrowse<CR>
noremap <C-g>ci :Gcommit %<CR>
noremap <C-g>co :Git checkout<Space>
" Show log for current file.
noremap <C-g>lg :0Glog<CR>
noremap <C-g>mv :Git mv <C-R>=expand('%:p')<CR> <C-R>=expand('%:p:h') . '/'<CR>
noremap <C-g>st :Gstatus<CR>
noremap <C-g>sh :Git stash<CR>

" C-Left moves the cursor before ':'.
noremap <C-g>vs :Gvsplit :%<C-Left>
noremap <C-g>sp :Gsplit :%<C-Left>

" GV - Git commit browser. Requires fugitive.
noremap <Leader>gv :GV<CR>

" vim-gitgutter - show a git diff in the sign column.
nmap <C-g>hp <Plug>GitGutterPreviewHunk
nmap <C-g>hs <Plug>GitGutterStageHunk
nmap <C-g>hu <Plug>GitGutterUndoHunk
noremap <C-g>hh :GitGutterLineHighlightsToggle<CR>
" Remap hunk text object mappings from ic, ac to ih, ah,
" because ic and ac conflict with other plugins.
omap ih <Plug>GitGutterTextObjectInnerPending
omap ah <Plug>GitGutterTextObjectOuterPending
xmap ih <Plug>GitGutterTextObjectInnerPending
xmap ah <Plug>GitGutterTextObjectOuterPending

" vim-eunuch
nnoremap <Leader><C-r> :Rename<Space>
nnoremap <Leader><C-d> :Delete<CR>

" vim-obsession
" Toggle.
nnoremap <Leader><C-o> :Obsess!<CR>

let g:ranger_map_keys = 0
noremap <LocalLeader>f :Ranger<CR>
noremap <LocalLeader>F :RangerNewTab<CR>

" vim-merginal - interface for dealing with Git branches.
" Requires fugitive.
noremap <silent> <Leader>m :MerginalToggle<CR>

" vZoom - quickly maximize & unmaximize the current window.
nmap <Leader>z <Plug>(vzoom)

" vim-instant-markdown
noremap <LocalLeader>i :InstantMarkdownPreview<CR>

if has('python3')
  packadd MatchTagAlways
  packadd completor.vim
  packadd ultisnips

  " vim-isort
  autocmd plugins FileType python packadd vim-isort
  autocmd plugins FileType python let g:vim_isort_map = '<Leader>i'
endif

" Tmuxline - tmux status line generator.
let g:tmuxline_powerline_separators = 0

" ALE - Asynchronous Lint Engine
let g:ale_set_highlights = 0
let ale_lint_on_text_changed = 'normal'
let g:ale_echo_msg_format = '[%linter%] %code%: %s'
let g:ale_linters = {'python': ['pydocstyle', 'pyflakes', 'pylint']}

" Signature - A plugin to toggle, display and navigate marks
" Highlight signs of marks based upon state indicated by vim-gitgutter.
let g:SignatureMarkTextHLDynamic = 1

" signjump - jump to signs just like other object motions.
let g:signjump = {
\  'use_jumplist': 1,
\  'map_next_sign': ']g',
\  'map_prev_sign': '[g',
\  'map_last_sign': ']G',
\  'map_first_sign': '[G',
\}

" winresizer - easy window resizing, similar to resize mode in i3wm
let g:winresizer_start_key = '<Leader>R'

" UltiSnips - snippets
nnoremap <LocalLeader>u :UltiSnipsEdit<CR>

" python-syntax - better python syntax highlighting
let g:python_highlight_all = 1

" Tagbar - a class outline viewer using ctags
nnoremap <LocalLeader>tt :TagbarToggle<CR>

" Linediff - diff two blocks of text
nnoremap [l :Linediff<CR>
nnoremap ]l :LinediffReset<CR>
vnoremap [l :Linediff<CR>
vnoremap ]l :LinediffReset<CR>

" }}}

silent! source ~/.vimrc.local
