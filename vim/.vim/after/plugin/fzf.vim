if &runtimepath =~# '/usr/bin/fzf' " Basic plugin.
  " Choose a filetype and pretty format the current buffer (or range).
  function! FzfPrettyFormat(range_prefix) range
    let range_prefix_arg = a:range_prefix

    function! s:get_type_formatter(filetype) closure
      call FormatFile(a:filetype, range_prefix_arg)
    endfunction

    call fzf#run({
    \ 'sink': function('s:get_type_formatter'),
    \ 'source': keys(g:formatter_mapping),
    \ 'options': '+m --cycle --prompt="Pretty format> "',
    \ 'down': '50%',
    \})
  endfunction

  nnoremap <LocalLeader>F :call FzfPrettyFormat("%")<CR>
  vnoremap <LocalLeader>F :call FzfPrettyFormat("'<,'>")<CR>

  let g:fzf_layout = { 'down': '50%' }

  " Hide fzf's statusline.
  autocmd main FileType fzf set laststatus=0 noshowmode noruler
        \| autocmd main BufLeave <buffer> set laststatus=2 showmode ruler

  if &runtimepath =~# 'bundle/opt/fzf.vim' " Plugin extension.
    " Add alt-enter binding to select query.
    command! -bar -bang FzfFiletypes call fzf#vim#filetypes({}, <bang>0)
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
    \ 'ctrl-t': 'tab drop',
    \ 'ctrl-b': 'split',
    \ 'ctrl-v': 'vsplit',
    \}

    " File opener.
    nnoremap <silent> <Leader>t :FzfFiles<CR>
    nnoremap <silent> <Leader>T :FzfHomeFiles<CR>

    " Change filetype with fzf.
    nnoremap ]f :FzfFiletypes<CR>
    vnoremap ]f <Esc>:FzfFiletypes<CR>
  endif
endif
