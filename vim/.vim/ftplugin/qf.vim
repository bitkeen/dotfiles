" Close all quickfix windows.
nnoremap <buffer> <silent> <Leader>q :call CloseQuickfixWindows()<CR>
vnoremap <buffer> <silent> <Leader>q <Esc>:call CloseQuickfixWindows()<CR>

" Go to older error list.
nnoremap <buffer> <Leader>H :colder<CR>
" Go to newer error list.
nnoremap <buffer> <Leader>L :cnewer<CR>

if &runtimepath =~ 'bundle/opt/quickpeek.vim'
  nnoremap <buffer> <silent> <LocalLeader>p :QuickpeekToggle<cr>
endif

" Remove file under cursor from quickfix list.
nnoremap <buffer> gsf :Cfilter! ^<C-r><C-f><CR>
