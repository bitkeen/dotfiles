scriptencoding utf-8
" Warn when using Cyrillic in normal mode.

highlight default link Warning Search

function! s:WarnOnCyrillic()
call popup_create(
\  'Using Cyrillic',
\  {
\     'close': 'click',
\     'time': 1000,
\     'highlight': 'Warning',
\     'padding': []
\  }
\)
endfunction

let s:alphabet='абвгдежзийклмнопрстуфхцчшщъыьэюяёєії'

for char in s:alphabet
  execute 'nnoremap <silent> ' . char . ' :call <SID>WarnOnCyrillic()<CR>'
  execute 'vnoremap <silent> ' . char . ' :call <SID>WarnOnCyrillic()<CR>'
endfor
