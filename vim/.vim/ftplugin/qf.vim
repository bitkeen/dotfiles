if &runtimepath =~ 'bundle/opt/quickpeek.vim'
  " Change filetype.
  nnoremap <buffer> <silent> <LocalLeader>p :QuickpeekToggle<cr>
endif

if exists('loaded_cfilter')
  " Using cfilter plugin to filter quickfix list
  nnoremap <buffer> <LocalLeader>f :Cfilter<space>
endif
