function! fin#internal#command#fin#command(mods, fargs) abort
  try
    let after = fin#internal#args#pop(a:fargs, 'after', 'zvzz')
    let cancel = fin#internal#args#pop(a:fargs, 'cancel', '')
    let matcher = fin#internal#args#pop(a:fargs, 'matcher', g:fin#matcher)

    if len(a:fargs) > 1
          \ || type(after) isnot# v:t_string
          \ || type(cancel) isnot# v:t_string
          \ || type(matcher) isnot# v:t_string
      throw 'Usage: Fin [-after={after}] [-cancel={cancel}] [-matcher={matcher}] [{query}]'
    endif

    " Does all options are handled?
    call fin#internal#args#throw_if_dirty(a:fargs)

    let query = get(a:fargs, 0, '')
    let ctx = fin#internal#context#new({
          \ 'query': query,
          \ 'matcher': matcher,
          \})
    let index = fin#internal#filter#start(ctx)
    if index isnot# -1
      call cursor(index + 1, 1, 0)
      if !empty(after)
        call feedkeys(eval(printf('"%s"', after)), 'x')
      endif
    else
      if !empty(cancel)
        call feedkeys(eval(printf('"%s"', cancel)), 'x')
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
    let candidates = ['-after=', '-cancel=', '-matcher=']
    return filter(candidates, { _, v -> v =~# pattern })
  endif
  return []
endfunction
