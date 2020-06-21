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

    " Change filetype with fzf.
    nnoremap ]f :FzfFiletypes<CR>
    vnoremap ]f <Esc>:FzfFiletypes<CR>
  endif
endif
