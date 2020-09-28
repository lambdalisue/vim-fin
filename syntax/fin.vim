if exists('b:current_syntax')
  finish
endif

syntax clear
syntax match FinBase /.*/
syntax match FinLineNr /^\s*\d\+ /

let b:current_syntax = 'fin'
