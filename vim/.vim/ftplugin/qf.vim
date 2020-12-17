" Close all quickfix windows.
nnoremap <buffer> <silent> <Leader>q :call CloseQuickfixWindows()<CR>
vnoremap <buffer> <silent> <Leader>q <Esc>:call CloseQuickfixWindows()<CR>

if &runtimepath =~ 'bundle/opt/quickpeek.vim'
  nnoremap <buffer> <silent> <LocalLeader>p :QuickpeekToggle<cr>
endif
