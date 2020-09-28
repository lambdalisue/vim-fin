if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal cursorline nolist nospell

cmap <buffer><nowait> <C-t> <Plug>(fin-line-prev)
cmap <buffer><nowait> <C-g> <Plug>(fin-line-next)
cmap <buffer><nowait> <C-^> <Plug>(fin-matcher-next)
cmap <buffer><nowait> <C-6> <Plug>(fin-matcher-next)
