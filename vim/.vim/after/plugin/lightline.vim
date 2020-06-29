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
  \             [ 'keyboard_layout', 'absolutepath', 'ismodified' ] ],
  \   'right': [ [ 'columninfo' ],
  \              [ 'lineinfo' ],
  \              [ 'percent', 'session', 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ] ],
  \ },
  \ 'inactive': {
  \   'left': [ [ 'absolutepath_inactive' ] ],
  \   'right': [ [ 'lineinfo' ],
  \              [ 'percent' ] ],
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
  \ },
  \ 'tab_component_function': {
  \   'filename': 'lightline#tab#filename',
  \   'modified': 'lightline#tab#modified',
  \   'readonly': 'lightline#tab#readonly',
  \   'tabnum': 'lightline#tab#tabnum',
  \   'tabwinnr': 'LightlineTabWinNr',
  \ },
  \ 'component_function': {
  \   'gitbranch': 'fugitive#head',
  \   'absolutepath_inactive': 'LightlinePathAndModified',
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
    let tabwincount = tabpagewinnr(a:tabnr, '$')
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

  function! LightlineVenv()
    return $VIRTUAL_ENV != '' ? trim(system('basename $VIRTUAL_ENV')) : ''
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
