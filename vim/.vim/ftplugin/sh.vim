if exists('g:loaded_surround')
  " text -> "$text"
  let b:surround_{char2nr('d')} = "\"$\r\""
  " text -> "$(text)"
  let b:surround_{char2nr('D')} = "\"$(\r)\""
endif

" Utilize Vim's built-in man viewer instead of launching `man`.
setlocal keywordprg=:Man
