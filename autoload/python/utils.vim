" Highlight lines that had errors
function! python#utils#highlight_python_error()
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
function! python#utils#set_python_error()
  let l:qflist = getqflist()
  let l:line = line('.')

  for l:item in l:qflist
    if l:line == l:item.lnum
      if !empty(l:item.text)
        if bufnr('%') == l:item.bufnr
          call python#utils#wide_msg(l:item.text)
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
function! python#utils#fix_qflist() " {{{
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

function! python#utils#redraw(full) " {{{
    if a:full
        redraw!
    else
        redraw
    endif
endfunction " }}}

" Print as much of a:msg as possible without "Press Enter" prompt appearing {{{
function! python#utils#wide_msg(msg) abort 
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
    call python#utils#redraw(0)

    echo msg

    let &ruler = old_ruler
    let &showcmd = old_showcmd
endfunction
" }}}
