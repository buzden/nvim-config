set runtimepath^=~/.vim runtimepath+=~/.vim/after runtimepath+=/usr/share/vim/vimfiles
let &packpath = &runtimepath

let g:mapleader='|'
let maplocalleader = "\\"

call plug#begin()

  """"""" IDRIS 2 SUPPORT

  """ Fourth generation
  Plug 'neovim/nvim-lspconfig'
  Plug 'MunifTanjim/nui.nvim'
  Plug 'ShinKage/idris2-nvim'

  """ First generation (should go after the `idris2-nvim` because of issues of order)
  "Plug 'edwinb/idris2-vim'
  " Enabled now through system-wide installation of `idris2-vim`

  """""" OTHER NICE STUFF

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

call plug#end()

source ~/.vimrc
source $HOME/.config/nvim/idris2.vim

""" Rainbow (parentheses) configuration

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

""" Nerd tree configuration

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
autocmd BufRead,TextChanged,TextChangedI * call ShowColumnIfLineIsTooLong()
function! ShowColumnIfLineIsTooLong()
  if &textwidth > 0
    let maxLineLength = max(map(getline(1,'$'), 'len(v:val)'))
    if maxLineLength > &textwidth
      execute "set colorcolumn=" . (&textwidth + 1)
    else
      set colorcolumn=""
    endif
  endif
endfunction
