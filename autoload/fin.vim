let s:root = expand('<sfile>:p:h')
let s:Config = vital#fin#import('Config')

" Define Public variables
call s:Config.config(expand('<sfile>:p'), {
      \ 'prompt': '> ',
      \ 'interval': 50,
      \ 'wrap_around': 1,
      \ 'matcher': 'all',
      \ 'matchers': ['all', 'fuzzy'],
      \ 'feedkeys': 'zvzz',
      \})

function! fin#version() abort
  if !executable('git')
    echohl ErrorMsg
    echo '[fin] "git" is not executable'
    echohl None
    return
  endif
  let r = system(printf('git -C %s describe --tags --always --dirty', s:root))
  echo printf('[fin] %s', r)
endfunction
