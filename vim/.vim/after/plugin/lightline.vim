if &runtimepath =~# 'bundle/opt/lightline.vim'
  " Specify which feature is turned on. Both are equal to 1 by default.
  let g:lightline = {
  \ 'enable': {
  \   'statusline': 1,
  \   'tabline': 1,
  \ },
  \ 'colorscheme': 'powerline_custom',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'venv', 'gitbranch', 'spell', 'isreadonly' ],
  \             [ 'keyboard_layout', 'path_active', 'ismodified' ] ],
  \   'right': [ [ 'columninfo' ],
  \              [ 'lineinfo' ],
  \              [ 'percent', 'session', 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ] ],
  \ },
  \ 'inactive': {
  \   'left': [ [ 'path_inactive' ] ],
  \   'right': [ [ 'lineinfo' ],
  \              [ 'percent' ] ],
  \ },
  \ 'tabline': {
  \   'left': [ [ 'tabs' ] ],
  \   'right': [ ],
  \ },
  \ 'tab': {
  \   'active': [ 'tabnum', 'filename', 'modified', 'tabwinnr' ],
  \   'inactive': [ 'tabnum', 'filename', 'modified', 'tabwinnr' ],
  \ },
  \ 'component': {
  \   'columninfo': ':%2v',
  \   'lineinfo': '%3l/%L',
  \   'spell': 'spell: %{&spell?&spelllang:""}',
  \   'session': '%{LightlineObsession()}',
  \   'path_active': '%{LightlinePath(55)}%( %h%)%( %{LightlineIsNew()}%)',
  \   'path_inactive': '%{LightlinePath(25)}%( %h%)%( %{LightlineIsNew()}%)%( %{LightlineIsModified()}%)'
  \ },
  \ 'tab_component_function': {
  \   'filename': 'LightlineTabFilename',
  \   'modified': 'lightline#tab#modified',
  \   'readonly': 'lightline#tab#readonly',
  \   'tabnum': 'lightline#tab#tabnum',
  \   'tabwinnr': 'LightlineTabWinNr',
  \ },
  \ 'component_function': {
  \   'gitbranch': 'fugitive#Head',
  \   'keyboard_layout': 'LightlineXkbSwitch',
  \ },
  \ 'component_expand': {
  \   'ismodified': 'LightlineIsModified',
  \   'isreadonly': 'LightlineIsReadonly',
  \   'venv': 'LightlineVenv',
  \   'linter_checking': 'lightline#ale#checking',
  \   'linter_warnings': 'lightline#ale#warnings',
  \   'linter_errors': 'lightline#ale#errors',
  \   'linter_ok': 'lightline#ale#ok',
  \ },
  \ 'component_type': {
  \   'ismodified': 'warning',
  \   'isreadonly': 'warning',
  \   'linter_checking': 'left',
  \   'linter_warnings': 'warning',
  \   'linter_errors': 'error',
  \   'linter_ok': 'left',
  \ },
  \ 'component_visible_condition': {
  \   'session': 'LightlineObsession()',
  \ },
  \ 'mode_map': {
  \   'n' : 'N',
  \   'i' : 'I',
  \   'R' : 'R',
  \   'v' : 'V',
  \   'V' : 'VL',
  \   "\<C-v>": 'VB',
  \   'c' : 'C',
  \   's' : 'S',
  \   'S' : 'S',
  \   "\<C-s>": 'SB',
  \   't': 'T',
  \ },
  \}

  " Update lightline on certain events.
  autocmd plugins TextChanged,InsertLeave,BufWritePost * call lightline#update()

  " Return number of windows in a specific tab.
  function! LightlineTabWinNr(tabnr) abort
    let l:tabwincount = tabpagewinnr(a:tabnr, '$')
    return l:tabwincount > 1 ? '[' . l:tabwincount . ']' : ''
  endfunction

  function! LightlineTabFilename(tabnr)
    if gettabwinvar(a:tabnr, tabpagewinnr(a:tabnr), '&buftype') ==# 'quickfix'
      return '[Quickfix]'
    endif
    return lightline#tab#filename(a:tabnr)
  endfunction

  function! LightlinePath(threshold)
    " Return path (full/relative/filename) based on whether difference
    " between winwidth and path length is longer than threshold.
    if &buftype ==# 'quickfix'
      return '[Quickfix]'
    endif

    let l:path = expand('%:~') " Full path.
    if strlen(l:path)
      if (winwidth(0) - strlen(l:path)) < a:threshold
        let l:path = expand('%:f')  " Relative path.
        if (winwidth(0) - strlen(l:path)) < a:threshold
          let l:path = expand('%:t')  " Filename.
        endif
      endif
    else
      " Can't print home directory as tilde for a new buffer with Vim's
      " `expand`. Use a shell command instead.
      let l:path = system('pwd | sed "s#$HOME#~#" | tr -d "\n"') . '/' . '[No Name]'
      if (winwidth(0) - strlen(l:path)) < a:threshold
          let l:path = '[No Name]'
      endif
    endif

    return l:path
  endfunction

  function! LightlineIsNew()
    if &ft ==# 'netrw' || &ft ==# 'tagbar'
      return ''
    endif

    let l:abspath = expand('%:F')
    return l:abspath ==# '' || filereadable(l:abspath) ? '' : '[New]'
  endfunction

  function! LightlineIsModified()
    return &modified ? '[+]' : ''
  endfunction

  function! LightlineIsReadonly()
    return &readonly ? 'RO' : ''
  endfunction

  function! LightlineVenv()
    return $VIRTUAL_ENV != '' ? trim(system('basename $VIRTUAL_ENV')) : ''
  endfunction

  " Get keyboard layout using vim-xkbswitch.
  " Borrowed from airline.
  function! LightlineXkbSwitch()
    if !exists('g:XkbSwitchLib')
      return
    endif

    let l:keyboard_layout = libcall(g:XkbSwitchLib, 'Xkb_Switch_getXkbLayout', '')
    let l:keyboard_layout = split(l:keyboard_layout, '\.')[-1]
    let short_codes = get(g:, 'short_codes', {'us': 'US', 'ru': 'RU', 'ua': 'UA'})

    if has_key(short_codes, l:keyboard_layout)
      let l:keyboard_layout = short_codes[l:keyboard_layout]
    endif
    return l:keyboard_layout
  endfunction

  function! LightlineObsession()
    if &runtimepath !~# 'bundle/opt/vim-obsession'
      return
    endif
    return ObsessionStatus()
  endfunction

  " lightline wasn't getting updated for some reason.
  " Update it explicitly, :echo at the is to clear the command line.
  nnoremap <Leader><C-w> :SudoWrite<CR>:call lightline#update()<CR>:echo<CR>
endif
