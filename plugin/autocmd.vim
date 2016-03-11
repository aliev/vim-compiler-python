if !exists('g:python_compiler_fixqflist')
  let g:python_compiler_fixqflist = 1
endif

augroup python
  au!
  if g:python_compiler_fixqflist == 1
    au QuickFixCmdPost * call python#utils#fix_qflist()
  endif
augroup end
