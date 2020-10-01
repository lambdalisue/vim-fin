if exists('g:loaded_fin')
  finish
endif
let g:loaded_fin = 1

command! -bar -nargs=*
      \ -complete=customlist,fin#internal#command#fin#complete
      \ Fin
      \ call fin#internal#command#fin#command(<q-mods>, [<f-args>])
