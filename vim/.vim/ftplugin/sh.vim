if exists('g:loaded_surround')
  " text -> "$text"
  let b:surround_{char2nr('d')} = "\"$\r\""
  " text -> "$(text)"
  let b:surround_{char2nr('D')} = "\"$(\r)\""
endif
