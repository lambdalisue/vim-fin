function! fin#matcher#fuzzy#filter(items, query, ignore) abort
  if len(a:items) is# 0
    return []
  endif
  let pattern = (a:ignore ? '\c' : '\C') . s:pattern(a:query)
  let indices = range(0, len(a:items) - 1)
  return filter(
        \ indices,
        \ 'a:items[v:val] =~# pattern',
        \)
endfunction

function! fin#matcher#fuzzy#highlight(query, ignore) abort
  let pat = s:pattern(a:query)
  if empty(pat)
    silent nohlsearch
  else
    silent! execute printf('/%s%s/', a:ignore ? '\c' : '\C', pat)
  endif
endfunction

function! s:pattern(query) abort
  let chars = map(
        \ split(a:query, '\zs'),
        \ 'fin#util#escape_pattern(v:val)'
        \)
  let patterns = map(chars, { _, v -> printf('%s[^%s]\{-}', v, v)})
  return join(patterns, '')
endfunction
