"""""""""""""""""""""""""""""""""""""""""
""" Taking common configuration with Vim
"""
"""""""""""""""""""""""""""""""""""""""""

set runtimepath^=~/.vim runtimepath+=~/.vim/after runtimepath+=/usr/share/vim/vimfiles
let &packpath = &runtimepath

" Old (pre v0.10) colorscheme
colorscheme vim
set notermguicolors

" Common config (must go after colorscheme setting)
source ~/.vimrc

" For compat between 0.9.* and 0.10.*. This can be removed as soon as we use NeoVim 0.10.*
lua vim.uv = vim.uv or vim.loop

set updatetime=1500 " To make `CursorHold` above work after 1.5 s of hold

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

  " Sophisticated undo tree
  Plug 'mbbill/undotree'

  " A scrollbar
  Plug 'petertriho/nvim-scrollbar'
  Plug 'kevinhwang91/nvim-hlslens'

call plug#end()

""""""""""""""""""""""""
""" Configuring airline
"""
""""""""""""""""""""""""

highlight StatusLine NONE
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

""""""""""""""""""""""""""
""" Configuring EasyAlign
"""
""""""""""""""""""""""""""

" start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

""""""""""""""""""""""""""
""" Configuring undo tree
"""
""""""""""""""""""""""""""

nnoremap <silent> <C-u> <CMD>UndotreeToggle<CR>
nnoremap <silent> <C-S-u> <CMD>UndotreePersistUndo<CR><CMD>echo 'Persist undo enabled for this file'<CR>
let g:undotree_WindowLayout = 2 " Diff in the bottom
let g:undotree_SetFocusWhenToggle = 1
"let g:undotree_DiffCommand = "delta --diff-highlight" " We need to run `:AnsiEsc` in the diff panel somehow to make this work
"let g:undotree_DiffCommand = "git diff --no-index --no-color -U0" " Prints too much in the befinning

highlight DiffAdd    ctermbg=22
highlight DiffChange ctermbg=17
highlight DiffDelete ctermbg=52

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
"autocmd BufReadPost,BufWritePost *.typ lua require('typst-buf').check(true)
autocmd CursorHoldI,CursorHold *.typ lua require('typst-buf').check(false)
autocmd BufCreate *.typ nnoremap <silent> <CR> <Cmd>noh<CR><Cmd>lua require('typst-buf').hide()<CR>

""""""""""""""""""""""""""""""""""""""""
""" Rainbow (parentheses) configuration
"""
""""""""""""""""""""""""""""""""""""""""

let g:rainbow_active = 1
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

"""""""""""""""""""""""""""""""""""
""" Line for exceeding line length
"""
"""""""""""""""""""""""""""""""""""

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

"""""""""""""""""""""
""" Enable scrollbar
"""
"""""""""""""""""""""

lua << EOF
require('scrollbar').setup {
  handle = {
    color_nr = 235,
  },
  marks = {
    Cursor = {
      color_nr = 249,
      priority = 10,
    },
    Search = {
      color_nr = 11,
      priority = 3,
    },
    Error = {
      color_nr = 9,
      priority = 0,
      text = { "|", "∥" },
    },
    Warn = {
      color_nr = 3,
      priority = 1,
      text = { "|", "∥" },
    },
    Info = {
      color_nr = 19,
      text = { "|", "∥" },
    },
    Hint = {
      color_nr = 7,
      text = { "|", "∥" },
    },
    Misc = {
      color_nr = 7,
      text = { "|", "∥" },
    },
  },
}

require("scrollbar.handlers.search").setup({
  override_lens = function() end,
})

EOF

" Fixup for not-updating `airline` status after the `scrollbar` plugin was added
lua vim.uv.new_timer():start(2000, 1500, function() vim.schedule(function() vim.cmd('AirlineRefresh'); end); end)

" vim: textwidth=152
