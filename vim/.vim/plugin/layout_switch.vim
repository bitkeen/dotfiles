" When leaving insert mode, switch layout back to default.
let s:DEFAULT_LAYOUT = 0
let s:GET_CURRENT_INDEX = '
\swaymsg -t get_inputs
\ | grep -m1 "xkb_active_layout_index"
\ | grep -oP "\d+"
\'
let s:SWITCH_LAYOUT_TEMPLATE = 'swaymsg input "* xkb_switch_layout %s"'

augroup layout_switch
  autocmd!
  autocmd InsertLeave * let lastLangIndex = system(s:GET_CURRENT_INDEX)
        \ | call job_start(printf(s:SWITCH_LAYOUT_TEMPLATE, s:DEFAULT_LAYOUT))
  autocmd InsertEnter * if exists('lastLangIndex')
        \ | call job_start(printf(s:SWITCH_LAYOUT_TEMPLATE, lastLangIndex))
        \ | endif
augroup END
