if !exists('g:python_compiler_highlight_errors')
  let g:python_compiler_highlight_errors = 0
endif

if !exists('g:python_fixqflist')
  let g:python_compiler_fixqflist = 1
endif

augroup python
  au!
  " Show error message under cursor
  " for visual and insert mode
  if !empty(g:python_compiler_highlight_errors)
    au CursorMoved * call python#utils#set_python_error()
    au BufEnter,QuickFixCmdPost * call python#utils#highlight_python_error()
  endif

  if !empty(g:python_fixqflist)
    au QuickFixCmdPost * call python#utils#fix_qflist()
  endif

augroup end
