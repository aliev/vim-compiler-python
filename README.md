# Installation

Django command depends on the [vim-dispatch](https://github.com/tpope/vim-dispatch) module, therefore it is necessary to install it. For installation modules and packages in vim, I use a lightweight package manager - [vim-plug](https://github.com/junegunn/vim-plug/wiki). In your vimrc:

```
Plug 'tpope/vim-dispatch'

if has('nvim')
  " Adds neovim support to vim-dispatch
  Plug 'radenling/vim-dispatch-neovim'
endif

Plug 'aliev/vim-python'
```

[vim-dispatch](https://github.com/tpope/vim-dispatch) will allow run the external commands asynchronously, without exiting from Vim. As we know running external commands blocks vim. As the backend for vim-dispatch, I recommend using tmux. If you're using neovim, you don't need tmux.

# Env options

Ignore Python warnings (very useful for vim-htmldjango_omnicomplete plugin)

``let $PYTHONWARNINGS="ignore"``

Auto detect virtualenv

``$VIRTUAL_ENV``

# Python Compiler

Compiler options:

``let g:python_compiler_fixqflist = 1``
