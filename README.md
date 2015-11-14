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

[vim-dispatch](https://github.com/tpope/vim-dispatch) will allow to you run the external commands asynchronously, without exiting from Vim. As we know running external commands blocks vim. As the backend for vim-dispatch, I recommend using tmux. If you're using neovim, you don't need tmux.

### Django Support

By this module you can run any Django commands from your vim. Don't forget to set up your $DJANGO_SETTINGS_MODULE environment variable.

``:Django runserver``

or

``:Django <tab>``

``:Django! <tab>``

to see list of Django commands.

Run tests:

``:Django test``

Asynchronously

``Django! test``

If you're using nosetests, you can run tests for current opened file

``Django test %``

if during the test there will be errors, will automatically open the quickfix with Python stacktrace

# Env options

Ignore Python warnings (very useful for vim-htmldjango_omnicomplete plugin)

``let $PYTHONWARNINGS="ignore"``

Set ``PYTHONPATH`` as current working directory

``let $PYTHONPATH=$PWD``

Auto detect virtualenv

``$VIRTUAL_ENV``

# Python Compiler

Compiler options:

``let g:python_compiler_fixqflist = 1``

``let g:python_compiler_highlight_errors = 0``

Can detect and highlight Python errors, show Python exceptions and errors in QuickFix.

![](https://raw.githubusercontent.com/aliev/vim-python/master/screen.png?raw=true)

# Autoimport and Folding for imports

Auto folds imports and plugin can auto place import statement
