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

augroup python
  au!
  " Show error message under cursor
  " for visual and insert mode
  au CursorHold <buffer> call s:SetPythonErrorMessage()

  au QuickFixCmdPost * call s:FixQflist()

  au BufEnter,QuickFixCmdPost * call s:HighlightPythonError()
augroup end

" For Flake8 first
CompilerSet efm  =%E%f:%l:\ could\ not\ compile,
CompilerSet efm +=%-Z%p^,
CompilerSet efm +=%A%f:%l:%c:\ %t%n\ %m,
CompilerSet efm +=%A%f:%l:\ %t%n\ %m,

" Python errors are multi-lined. They often start with 'Traceback', so
" we want to capture that (with +G) and show it in the quickfix window
" because it explains the order of error messages.

CompilerSet efm +=%+GTraceback%.%#,

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

" Highlight lines that had errors
function! s:HighlightPythonError() abort
  highlight link PyError SpellBad

  let l:qflist = getqflist()
  let l:matches = getmatches()

  "clear all already highlighted
  for l:match in l:matches
    if l:match.group == "PyError"
      call matchdelete(l:match.id)
    endif
  endfor

  for l:item in l:qflist
    if bufnr('%') == item.bufnr
      call matchadd("PyError", '\w\%' . l:item.lnum . 'l\n\@!')
    endif
  endfor
endfunction

" Set and show error messages for lines
" in which they were found
function! s:SetPythonErrorMessage() abort
  let l:qflist = getqflist()
  let l:line = line('.')

  for l:item in l:qflist
    if l:line == l:item.lnum
      if !empty(l:item.text)
        if bufnr('%') == l:item.bufnr
          call WideMsg(l:item.text)
        endif
      endif
    else
      echo
    endif
  endfor
endfunction

" Sometimes Python issues debugging messages
" which don't belong to a call stack context
" this function filters these messages
function! s:FixQflist() abort " {{{
  let l:traceback = []
  let l:qflist = getqflist()

  for l:item in l:qflist
    if !empty(l:item.type)
      call add(l:traceback, l:item)
    endif
  endfor

  if !empty(l:traceback)
    call setqflist(l:traceback)
  endif
endfunction " }}}

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
