if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  " Temporary files that bash creates when you open a command in editor.
  au! BufEnter *var/folders/lt/*bash-fc-* set filetype=sh
augroup END
