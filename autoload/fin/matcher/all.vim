function! fin#matcher#all#filter(items, query, ignore) abort
  if len(a:items) is# 0
    return []
  endif
  let indices = range(0, len(a:items) - 1)
  let l:Wrap = a:ignore ? function('tolower') : { v -> v }
  for term in split(a:query, ' ')
    call filter(
          \ indices,
          \ 'stridx(Wrap(a:items[v:val]), term) isnot# -1',
          \)
  endfor
  return indices
endfunction

function! fin#matcher#all#highlight(query, ignore) abort
  let pat = join(map(split(a:query, ' '), 'fin#util#escape_pattern(v:val)'), '\|')
  if empty(pat)
    silent nohlsearch
  else
    silent! execute printf(
          \ '/%s\%%(%s\)/',
          \ a:ignore ? '\c' : '\C',
          \ pat
          \)
  endif
endfunction
