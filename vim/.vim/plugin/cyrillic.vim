scriptencoding utf-8
" Warn when using Cyrillic in normal mode.

highlight default link Warning Search

function! WarnOnCyrillic()
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

nnoremap <silent> а :call WarnOnCyrillic()<CR>
nmap б а
nmap в а
nmap г а
nmap д а
nmap е а
nmap ж а
nmap з а
nmap и а
nmap й а
nmap к а
nmap л а
nmap м а
nmap н а
nmap о а
nmap п а
nmap р а
nmap с а
nmap т а
nmap у а
nmap ф а
nmap х а
nmap ц а
nmap ч а
nmap ш а
nmap щ а
nmap ъ а
nmap ы а
nmap ь а
nmap э а
nmap ю а
nmap я а
nmap ё а
nmap є а
nmap і а
nmap ї а

vnoremap <silent> а :call WarnOnCyrillic()<CR>
vmap б а
vmap в а
vmap г а
vmap д а
vmap е а
vmap ж а
vmap з а
vmap и а
vmap й а
vmap к а
vmap л а
vmap м а
vmap н а
vmap о а
vmap п а
vmap р а
vmap с а
vmap т а
vmap у а
vmap ф а
vmap х а
vmap ц а
vmap ч а
vmap ш а
vmap щ а
vmap ъ а
vmap ы а
vmap ь а
vmap э а
vmap ю а
vmap я а
vmap ё а
vmap є а
vmap і а
vmap ї а
