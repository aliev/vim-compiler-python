command! -bang -nargs=* -complete=customlist,python#commands#django#complete_managment_commands Django
      \ call python#commands#django#admin_command(<bang>0, <q-args>)

command! -bang -nargs=* -complete=file PyRun
      \ call python#commands#python#run(<bang>0, <q-args>)
