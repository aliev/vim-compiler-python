" Vim compiler file
" Compiler:	Unit testing tool for Python
" Maintainer:	Ali Aliev <ali@aliev.me>
" Last Change: 2015 Nov 2

if exists("current_compiler")
  finish
endif
let current_compiler = "python"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

if !exists('g:python_sign_error_symbol')
  let g:python_sign_error_symbol="⚠"
endif

au CursorMoved * call s:GetPythonMessage()
au QuickFixCmdPost * call s:FixQflist()
au QuickFixCmdPost * call s:PlaceSigns()

CompilerSet efm=%+GTraceback%.%#,%E\ \ File\ \"%f\"\\,\ line\ %l\\,%m%\\C,%E\ \ File\ \"%f\"\\,\ line\ %l%\\C,%C%p^,%+C\ \ \ \ %.%#,%+C\ \ %.%#,%Z%\\S%\\&%m,%-G%.%#
CompilerSet makeprg=python\ -i

function! s:PlaceSigns()
  execute "sign define PythonDispatchError text=" . g:python_sign_error_symbol . " texthl=SignColumn"
  let qflist = getqflist()
  let l:index0 = 100
  let l:index  = l:index0
  let s:signids  = []

  if !empty(s:signids)
    call s:UnplaceSigns()
  endif

  for tb in qflist
    let bufnr = tb['bufnr']
    let lnum = tb['lnum']
    if bufnr == 0
      continue
    endif
    execute "sign place" index "line=" . lnum "name=PythonDispatchError buffer=" . bufnr
    let s:signids += [l:index]
    let l:index += 1
  endfor
endfunction

function! s:UnplaceSigns()
  if exists('s:signids')
    for i in s:signids
      execute ":sign unplace ".i
    endfor
    unlet s:signids
  endif
endfunction

function! s:FixQflist()
  let l:traceback = []
  let qflist = getqflist()
  for i in qflist
    if !empty(i['type'])
      call add(l:traceback, i)
    endif
  endfor
  if !empty(l:traceback)
    call setqflist(l:traceback)
  endif
endfunction

function! s:GetPythonMessage()
  let qflist = getqflist()
  let line = line('.')
  for qfix in qflist
    if line == qfix['lnum']
      if !empty(qfix['text'])
        let g:error = printf("Error: %s", qfix['text'])
        call WideMsg(g:error)
      endif
    else
      echo
    endif
  endfor
endfunction

function! Redraw(full) abort " {{{2
    if a:full
        redraw!
    else
        redraw
    endif
endfunction " }}}2

" Print as much of a:msg as possible without "Press Enter" prompt appearing
function! WideMsg(msg) abort " {{{2
    let old_ruler = &ruler
    let old_showcmd = &showcmd

    "This is here because it is possible for some error messages to
    "begin with \n which will cause a "press enter" prompt.
    let msg = substitute(a:msg, "\n", '', 'g')

    "convert tabs to spaces so that the tabs count towards the window
    "width as the proper amount of characters
    let chunks = split(msg, "\t", 1)
    let msg = join(map(chunks[:-2], 'v:val . repeat(" ", &tabstop - s:_width(v:val) % &tabstop)'), '') . chunks[-1]
    let msg = strpart(msg, 0, &columns - 1)

    set noruler noshowcmd
    call Redraw(0)

    echo msg

    let &ruler = old_ruler
    let &showcmd = old_showcmd
endfunction " }}}2

