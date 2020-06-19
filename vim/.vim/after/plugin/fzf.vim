if &runtimepath =~# 'bundle/opt/fzf.vim'
  " Add alt-enter binding to select query.
  command! -bar -bang FzfFiletypes call fzf#vim#filetypes({'options': ['--bind=alt-enter:print-query']}, <bang>0)

  " Change filetype with fzf.
  nnoremap ]f :FzfFiletypes<CR>
endif
