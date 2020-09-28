function! fin#internal#command#fin#command(mods, fargs) abort
  try
    let query = fin#internal#args#pop(a:fargs, 'query', '')
    let matcher = fin#internal#args#pop(a:fargs, 'matcher', g:fin#matcher)

    if len(a:fargs) > 1
          \ || type(query) isnot# v:t_string
          \ || type(matcher) isnot# v:t_string
      throw 'Usage: Fin [-query={query}] [-matcher={matcher}] [{feedkeys}]'
    endif

    " Does all options are handled?
    call fin#internal#args#throw_if_dirty(a:fargs)

    let feedkeys = get(a:fargs, 0, g:fin#feedkeys)
    let ctx = fin#internal#context#new({
          \ 'query': query,
          \ 'matcher': matcher,
          \})
    let index = fin#internal#filter#start(ctx)
    if index isnot# -1
      call cursor(index + 1, 1, 0)
      if !empty(feedkeys)
        call feedkeys(eval(printf('"%s"', feedkeys)), 'x')
      endif
    endif
  catch
    echohl ErrorMsg
    echomsg v:exception
    echohl None
  endtry
endfunction

function! fin#internal#command#fin#complete(arglead, cmdline, cursorpos) abort
  let pattern = '^' . a:arglead
  if a:arglead =~# '^-matcher='
    let candidates = map(copy(g:fin#matchers), { _, v -> printf('-matcher=%s', v) })
    return filter(candidates, { _, v -> v =~# pattern })
  elseif a:arglead =~# '^-'
    let candidates = ['-query=', '-matcher=']
    return filter(candidates, { _, v -> v =~# pattern })
  endif
  return []
endfunction
