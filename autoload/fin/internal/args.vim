let s:Args = vital#fin#import('App.Args')

function! fin#internal#args#set(args, name, value) abort
  return s:Args.set(a:args, a:name, a:value)
endfunction

function! fin#internal#args#pop(args, name, default) abort
  return s:Args.pop(a:args, a:name, a:default)
endfunction

function! fin#internal#args#throw_if_dirty(args) abort
  return s:Args.throw_if_dirty(a:args, '[fin] ')
endfunction
