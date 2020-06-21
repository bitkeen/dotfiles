if &runtimepath =~# '/usr/bin/fzf' " Basic plugin.
  " Choose a filetype and pretty format the current buffer (or range).
  function! FzfPrettyFormat(mode) range
    if a:mode ==? 'normal'
      let s:prefix = '%'
    elseif a:mode ==? 'visual'
      let s:prefix = "'<,'>"
    else
      echoerr 'Wrong mode value'
      return 1
    endif

    let s:file_types = {
    \ 'html': '!tidy -q -i --show-errors 0',
    \ 'xml': '!tidy -q -i --show-errors 0 -xml',
    \ 'json': '!python -m json.tool',
    \ 'sql': '!pg_format',
    \}

    function! s:get_type_formatter(type)
      execute s:prefix . get(s:file_types, a:type)
    endfunction

    call fzf#run({
    \ 'sink': function('s:get_type_formatter'),
    \ 'source': keys(s:file_types),
    \ 'options': '+m --prompt="Pretty format> "',
    \ 'down': '40%',
    \})
  endfunction

  nnoremap <LocalLeader>F :call FzfPrettyFormat('normal')<CR>
  vnoremap <LocalLeader>F :call FzfPrettyFormat('visual')<CR>

  if &runtimepath =~# 'bundle/opt/fzf.vim' " Plugin extension.
    " Add alt-enter binding to select query.
    command! -bar -bang FzfFiletypes call fzf#vim#filetypes({'options': ['--bind=alt-enter:print-query']}, <bang>0)
    command! -bang FzfHomeFiles call fzf#vim#files('~', <bang>0)

    " Used in FzfFiles.
    let $FZF_DEFAULT_COMMAND = 'find -L . -mindepth 1 -maxdepth 15 -type f
    \ -not -path "*/.git/*"
    \ -not -path "*/.git"
    \ -not -path "*/Session.vim"
    \ -not -path "*/.vim/tmp/*"
    \ -not -path "*/__pycache__/*"
    \ -print'

    " Override `split` action.
    let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-b': 'split',
    \ 'ctrl-v': 'vsplit',
    \}

    " File opener.
    nnoremap <Leader>t :FzfFiles<CR>
    nnoremap <Leader>T :FzfHomeFiles<CR>

    " Change filetype with fzf.
    nnoremap ]f :FzfFiletypes<CR>
    vnoremap ]f <Esc>:FzfFiletypes<CR>
  endif
endif
