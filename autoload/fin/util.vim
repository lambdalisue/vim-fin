function! fin#util#escape_pattern(str) abort
  return escape(a:str, '^$~.*[]\')
endfunction

function! fin#util#prompt(prompt, text) abort
  let hash = sha256(localtime())
  execute printf('cnoremap <silent><buffer> <CR> %s<CR>', hash)
  let result = input(a:prompt, a:text)
  let ok = result[-64:] ==# hash
  if ok
    call histdel('@', -1)
    call histadd('@', result[:-65])
  endif
  return ok ? result[:-65] : v:null
endfunction
