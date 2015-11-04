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

if !exists('$PYTHONWARNINGS')
  let $PYTHONWARNINGS="ignore"
endif

if !exists('$PYTHONPATH')
  let $PYTHONPATH=$PWD
endif

au CursorMoved * call s:GetPythonMessage()
au QuickFixCmdPost * call s:FixQflist()
au QuickFixCmdPost * call s:PlaceSigns()

" Python errors are multi-lined. They often start with 'Traceback', so
" we want to capture that (with +G) and show it in the quickfix window
" because it explains the order of error messages.
CompilerSet efm  =%+GTraceback%.%#,

" The error message itself starts with a line with 'File' in it. There
" are a couple of variations, and we need to process a line beginning
" with whitespace followed by File, the filename in "", a line number,
" and optional further text. %E here indicates the start of a multi-line
" error message. The %\C at the end means that a case-sensitive search is
" required.
CompilerSet efm +=%E\ \ File\ \"%f\"\\,\ line\ %l\\,%m%\\C,
CompilerSet efm +=%E\ \ File\ \"%f\"\\,\ line\ %l%\\C,

" The possible continutation lines are idenitifed to Vim by %C. We deal
" with these in order of most to least specific to ensure a proper
" match. A pointer (^) identifies the column in which the error occurs
" (but will not be entirely accurate due to indention of Python code).
CompilerSet efm +=%C%p^,

" Any text, indented by more than two spaces contain useful information.
" We want this to appear in the quickfix window, hence %+.
CompilerSet efm +=%+C\ \ \ \ %.%#,
CompilerSet efm +=%+C\ \ %.%#,

" The last line (%Z) does not begin with any whitespace. We use a zero
" width lookahead (\&) to check this. The line contains the error
" message itself (%m)
CompilerSet efm +=%Z%\\S%\\&%m,

" We can ignore any other lines (%-G)
CompilerSet efm +=%-G%.%#

if filereadable("Makefile")
  CompilerSet makeprg=make
else
  CompilerSet makeprg=python
endif

function! s:PlaceSigns()
  execute "sign define PythonDispatchError text=" . g:python_sign_error_symbol . " texthl=SignColumn"
  let l:qflist = getqflist()
  let l:index0 = 100
  let l:index  = l:index0

  if exists('s:signids')
    for i in s:signids
      execute ":sign unplace ".i
    endfor
  endif

  let s:signids  = []

  for tb in l:qflist
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

" Sometimes it is too much unnecessary information
" which is not related to the context of the errors.
" This function filter clean stacktrack
function! s:FixQflist() " {{{
  let l:traceback = []
  let l:qflist = getqflist()
  for i in l:qflist
    if !empty(i['type'])
      call add(l:traceback, i)
    endif
  endfor
  if !empty(l:traceback)
    call setqflist(l:traceback)
  endif
endfunction " }}}

function! s:GetPythonMessage()
  let l:qflist = getqflist()
  let l:line = line('.')
  for qfix in l:qflist
    if l:line == qfix['lnum']
      if !empty(qfix['text'])
        let g:error = printf("Error: %s", qfix['text'])
        call WideMsg(g:error)
      endif
    else
      echo
    endif
  endfor
endfunction

function! Redraw(full) abort " {{{
    if a:full
        redraw!
    else
        redraw
    endif
endfunction " }}}

" Print as much of a:msg as possible without "Press Enter" prompt appearing {{{
function! WideMsg(msg) abort 
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
endfunction
" }}}

" vim:foldmethod=marker:foldlevel=0
