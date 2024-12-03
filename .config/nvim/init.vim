"""""""""""""""""""""""""""""""""""""""""
""" Taking common configuration with Vim
"""
"""""""""""""""""""""""""""""""""""""""""

set runtimepath^=~/.vim runtimepath+=~/.vim/after runtimepath+=/usr/share/vim/vimfiles
let &packpath = &runtimepath

source ~/.vimrc

" For compat between 0.9.* and 0.10.*. This can be removed as soon as we use NeoVim 0.10.*
lua vim.uv = vim.uv or vim.loop

"""""""""""""""""""""""
""" Turning on plugins
"""
"""""""""""""""""""""""

call plug#begin()

  """ IDRIS 2 SUPPORT
  """

  """ Fourth generation
  Plug 'neovim/nvim-lspconfig'
  Plug 'MunifTanjim/nui.nvim'
  Plug 'ShinKage/idris2-nvim'

  """ First generation (should go after the `idris2-nvim` because of issues of order)
  "Plug 'edwinb/idris2-vim'
  " Enabled now through system-wide installation of `idris2-vim`

  """ OTHER NICE STUFF
  """

  " Nice status bar
  Plug 'vim-airline/vim-airline'

  " Support for `.editorconfig` files
  Plug 'editorconfig/editorconfig-vim'

  " Aligning utility
  Plug 'junegunn/vim-easy-align'

  " Colorful parentheses
  Plug 'luochen1990/rainbow'
  let g:rainbow_active = 1

  " Comment out code using `gc`
  Plug 'tpope/vim-commentary'

  " Nice directory tree view
  Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }

  " Support for typst
  Plug 'kaarmu/typst.vim'
  Plug 'chomosuke/typst-preview.nvim', {'tag': 'v1.*'}
  "Plug 'Myriad-Dreamin/tinymist', {'rtp': 'editors/neovim'}

  " Support for showing text with ANSI escape codes
  Plug 'powerman/vim-plugin-AnsiEsc'

call plug#end()

""""""""""""""""""""""""
""" Configuring airline
"""
""""""""""""""""""""""""

set noshowmode " This is for when airline/lightline/powershell plugin is on
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = len(getbufinfo({'buflisted':1})) > 1

""""""""""""""""""""""""""""""""""""
""" Configuring clipboard behaviour
"""
""""""""""""""""""""""""""""""""""""

" Sets yanking to go to the primary selection
set clipboard=unnamed

" Set "usual" combinations to the main clipboard (i.e., unnamedplus)
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"+pa

"""""""""""""""""""""""
""" Configuring Idris2
"""
"""""""""""""""""""""""

let g:mapleader='|'
let maplocalleader = "\\"

source $HOME/.config/nvim/idris2.vim

""""""""""""""""""""""
""" Configuring typst
"""
""""""""""""""""""""""

" Preview
lua require 'typst-preview'.setup { open_cmd = 'firefox-bin --new-instance %s -P typst-preview --kiosk' }
nnoremap <silent> <C-p> :TypstPreview slide<CR>
nnoremap <silent> <C-A-p> :TypstPreview document<CR>
nnoremap <silent> <C-S-p> :TypstPreviewStop<CR>

" Make on open and edit
lua require('typst-buf').setup()
normal zz
"autocmd BufReadPost,BufWritePost *.typ lua require('typst-buf').check(true)
autocmd CursorHoldI,CursorHold   *.typ lua require('typst-buf').check(false)
autocmd BufCreate *.typ nnoremap <silent> <CR> <Cmd>noh<CR><Cmd>lua require('typst-buf').hide()<CR>

""""""""""""""""""""""""""""""""""""""""
""" Rainbow (parentheses) configuration
"""
""""""""""""""""""""""""""""""""""""""""

let g:rainbow_conf = {
\ 'ctermfgs': [7, 226, 200, 46, 32],
\	'separately': {
\		'idris2': {
\			'parentheses':
\       [ 'start=/(/   end=/)/   fold'
\       , 'start=/\[/  end=/\]/  fold'
\       , 'start=/\[|/ end=/|\]/ fold'
\       , 'start=/`(/  end=/)/   fold'
\       , 'start=/`{/  end=/}/   fold'
\       , 'start=/`\[/ end=/\]/  fold'
\       , 'start=/\~(/ end=/)/   fold'
\       ],
\		}
\	}
\}

""""""""""""""""""""""""""""
""" Nerd tree configuration
"""
""""""""""""""""""""""""""""

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

" Close the tree when a file is open from it
let NERDTreeQuitOnOpen=3

" Ctrl-t toggles the Nerd tree (with root being a dir of current file)
nnoremap <silent> <C-t> :NERDTreeToggle %<CR>

" Show column if it exceeds set text width (incl. set from `.editorconfig`)
" Idea taken from https://superuser.com/a/1289220, but raised to a newer level ;-)
set colorcolumn=""
highlight ColorColumn ctermbg=darkgrey
autocmd ModeChanged,CursorHold,CursorHoldI * call ShowColumnIfLineIsTooLong()
function! ShowColumnIfLineIsTooLong()
  if &textwidth > 0
    let maxLineLength = max(map(getline(1,'$'), 'strchars(v:val)'))
    if maxLineLength > &textwidth
      execute "set colorcolumn=" . (&textwidth + 1)
    else
      set colorcolumn=""
    endif
  endif
endfunction
set updatetime=1500 " To make `CursorHold` above work after 1.5 s of hold

" vim: textwidth=152
