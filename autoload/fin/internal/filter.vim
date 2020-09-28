function! fin#internal#filter#start(ctx) abort
  let bufnr = bufnr('%')
  let bufhidden = &bufhidden
  try
    set bufhidden=hide
    if s:start(a:ctx) && a:ctx.cursor <= len(a:ctx.indices)
      return a:ctx.indices[a:ctx.cursor - 1]
    else
      return -1
    endif
  finally
    execute 'keepalt keepjumps buffer' bufnr
    let &bufhidden = bufhidden
    redraw | echo
  endtry
endfunction

function! s:start(ctx) abort
  let bufname = printf('fin://%s', expand('%:p'))
  execute printf('keepalt keepjumps edit %s', fnameescape(bufname))

  cnoremap <silent><buffer><expr> <Plug>(fin-line-prev) <SID>m_line_prev()
  cnoremap <silent><buffer><expr> <Plug>(fin-line-next) <SID>m_line_next()
  cnoremap <silent><buffer><expr> <Plug>(fin-matcher-prev) <SID>m_matcher_prev()
  cnoremap <silent><buffer><expr> <Plug>(fin-matcher-next) <SID>m_matcher_next()

  setlocal buftype=nofile bufhidden=wipe undolevels=-1
  setlocal noswapfile nobackup nobuflisted
  setlocal nowrap nofoldenable nonumber
  setlocal filetype=fin

  let b:fin_context = a:ctx
  let bufnr = bufnr('%')
  call timer_start(0, { -> s:consumer(a:ctx, bufnr) })
  call s:update(a:ctx)
  return fin#util#prompt(g:fin#prompt, a:ctx.query) isnot# v:null
endfunction

function! s:consumer(ctx, bufnr) abort
  if getcmdtype() !=# '@' || bufnr('%') isnot# a:bufnr
    return
  endif
  let query = getcmdline()
  if query !=# a:ctx.query
    let a:ctx.query = query
    call s:update(a:ctx)
  endif
  call timer_start(g:fin#interval, { -> s:consumer(a:ctx, a:bufnr) })
endfunction

function! s:update(ctx) abort
  let ignore = a:ctx.query ==# tolower(a:ctx.query)
  call fin#internal#context#update(a:ctx, ignore)
  call s:update_statusline(a:ctx)
  call s:update_content(a:ctx)
  call fin#matcher#{a:ctx.matcher}#highlight(a:ctx.query, ignore)
  call cursor(a:ctx.cursor, 1, 0)
  redraw
endfunction

function! s:update_statusline(ctx) abort
  let statusline = [
        \ '%%#FinStatuslineFile#%s ',
        \ '%%#FinStatuslineMiddle#%%=',
        \ '%%#FinStatuslineMatcher# Matcher: %s ',
        \ '%%#FinStatuslineIndicator# %d/%d',
        \]
  let &l:statusline = printf(
        \ join(statusline, ''),
        \ a:ctx.bufname,
        \ a:ctx.matcher,
        \ len(a:ctx.indices),
        \ a:ctx.size,
        \)
endfunction

function! s:update_content(ctx) abort
  if empty(a:ctx.indices)
    silent! keepjumps %delete _
    return
  endif
  let content = a:ctx.content
  let indices = copy(a:ctx.indices)
  if a:ctx.number
    let digit = len(a:ctx.size . ' ')
    let format = printf('%%%dd %%s', digit)
    let body = map(
          \ indices,
          \ 'printf(format, v:val + 1, content[v:val])'
          \)
  else
    let body = map(indices, 'content[v:val]')
  endif
  silent! call setline(1, body)
  execute printf('silent! keepjumps %d,$delete _', len(indices) + 1)
endfunction

function! s:m_line_prev() abort
  let ctx = b:fin_context
  let size = max([len(ctx.indices), 1])
  if ctx.cursor is# 1
    let ctx.cursor = g:fin#wrap_around ? size : 1
  else
    let ctx.cursor -= 1
  endif
  call cursor(ctx.cursor, 1, 0)
  redraw
  call feedkeys(" \<C-h>", 'n')   " Stay TERM cursor on cmdline
  return ''
endfunction

function! s:m_line_next() abort
  let ctx = b:fin_context
  let size = max([len(ctx.indices), 1])
  if ctx.cursor is# size
    let ctx.cursor = g:fin#wrap_around ? 1 : size
  else
    let ctx.cursor += 1
  endif
  call cursor(ctx.cursor, 1, 0)
  redraw
  call feedkeys(" \<C-h>", 'n')   " Stay TERM cursor on cmdline
  return ''
endfunction

function! s:m_matcher_prev() abort
  let ctx = b:fin_context
  let size = len(g:fin#matchers)
  let index = max([index(g:fin#matchers, ctx.matcher), 0])
  if index is# 0
    let index = size - 1
  else
    let index -= 1
  endif
  let ctx.matcher = g:fin#matchers[index]
  call timer_start(0, { -> s:update(ctx) })
  call feedkeys(" \<C-h>", 'n')   " Stay TERM cursor on cmdline
  return ''
endfunction

function! s:m_matcher_next() abort
  let ctx = b:fin_context
  let size = len(g:fin#matchers)
  let index = max([index(g:fin#matchers, ctx.matcher), 0])
  if index is# size - 1
    let index = 0
  else
    let index += 1
  endif
  let ctx.matcher = g:fin#matchers[index]
  call timer_start(0, { -> s:update(ctx) })
  call feedkeys(" \<C-h>", 'n')   " Stay TERM cursor on cmdline
  return ''
endfunction

function! s:define_highlights() abort
  highlight default link FinStatuslineFile      Comment
  highlight default link FinStatuslineMiddle    None
  highlight default link FinStatuslineMatcher   Statement
  highlight default link FinStatuslineIndicator Tag
  highlight default link FinBase   Comment
  highlight default link FinLineNr LineNr
  augroup fin_internal_filter_define_highlight
    autocmd!
    autocmd ColorScheme * ++once call s:define_highlights()
  augroup END
endfunction

call s:define_highlights()
