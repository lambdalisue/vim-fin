function! fin#internal#command#fin#command(mods, fargs) abort
  try
    let after = fin#internal#args#pop(a:fargs, 'after', '')
    let after_noremap = fin#internal#args#pop(a:fargs, 'After', '')
    let cancel = fin#internal#args#pop(a:fargs, 'cancel', '')
    let cancel_noremap = fin#internal#args#pop(a:fargs, 'Cancel', '')
    let matcher = fin#internal#args#pop(a:fargs, 'matcher', g:fin#matcher)

    if len(a:fargs) > 1
          \ || type(after) isnot# v:t_string
          \ || type(after_noremap) isnot# v:t_string
          \ || type(cancel) isnot# v:t_string
          \ || type(cancel_noremap) isnot# v:t_string
          \ || type(matcher) isnot# v:t_string
          \ || (!empty(after) && !empty(after_noremap))
          \ || (!empty(cancel) && !empty(cancel_noremap))
      throw 'Usage: Fin [-after|-After={after}] [-cancel|-Cancel={cancel}] [-matcher={matcher}] [{query}]'
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
      elseif !empty(after_noremap)
        call feedkeys(eval(printf('"%s"', after_noremap)), 'nx')
      else
        call feedkeys('zvzz', 'nx')
      endif
    else
      if !empty(cancel)
        call feedkeys(eval(printf('"%s"', cancel)), 'x')
      elseif !empty(cancel_noremap)
        call feedkeys(eval(printf('"%s"', cancel_noremap)), 'nx')
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
    let candidates = ['-after=', '-After=', '-cancel=', '-Cancel=', '-matcher=']
    return filter(candidates, { _, v -> v =~# pattern })
  endif
  return []
endfunction
