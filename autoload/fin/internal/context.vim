function! fin#internal#context#new(...) abort
  let ctx = extend({
        \ 'query': '',
        \ 'matcher': g:fin#matcher,
        \ 'number': &number,
        \ 'cursor': line('.'),
        \ 'bufname': bufname('%'),
        \ 'content': getline(1, '$'),
        \}, a:0 ? a:1 : {},
        \)
  let ctx.size = len(ctx.content)
  let ctx.indices = range(0, ctx.size - 1)
  return ctx
endfunction

function! fin#internal#context#update(ctx, ignore) abort
  let indices = fin#matcher#{a:ctx.matcher}#filter(
        \ a:ctx.content,
        \ a:ctx.query,
        \ a:ignore,
        \)
  let a:ctx.indices = indices
  let a:ctx.cursor = max([min([a:ctx.cursor, len(indices)]), 1])
endfunction
