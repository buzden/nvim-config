"""""""""""""""""""""""
""" Turning on plugins
"""
"""""""""""""""""""""""

call plug#begin()

  """ IDRIS 2 SUPPORT
  """

  """ Fourth generation
  Plug 'neovim/nvim-lspconfig', { 'tag': 'v2.4.*' }
  Plug 'MunifTanjim/nui.nvim'
  Plug 'idris-community/idris2-nvim'

  """ First generation (should go after the `idris2-nvim` because of issues of order)
  Plug 'edwinb/idris2-vim'

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

let g:typst_embedded_languages = ['idris -> idris2', 'c', 'rust', 'rs -> rust', 'sh', 'haskell', 'hs -> haskell', 'scala', 'json']
let g:typst_pdf_viewer = 'mupdf'

" Preview
lua require 'typst-preview'.setup { open_cmd = 'zen --new-instance -P typst-preview --kiosk %s 2>/dev/null' }
nnoremap <silent> <C-p> :TypstPreview slide<CR>
nnoremap <silent> <C-A-p> :TypstPreview document<CR>
nnoremap <silent> <C-S-p> :TypstPreviewStop<CR>

" Make on open and edit
lua require('typst-buf').setup()
autocmd FileType typst ++once lua require('typst-buf').check(false)
autocmd FileType typst autocmd TextChanged,ModeChanged,CursorHoldI * lua require('typst-buf').check(false)
autocmd BufCreate *.typ nnoremap <silent> <CR> <Cmd>noh<CR><Cmd>lua require('typst-buf').hide()<CR>

lua vim.lsp.config("tinymist", { cmd = { vim.fn.fnamemodify("~/.local/share/nvim/typst-preview/tinymist-linux-x64", ":p") } })
lua vim.lsp.enable("tinymist")

"""""""""""""""""""""""""""""""""""""""
""" Configuring other markup languages
"""
"""""""""""""""""""""""""""""""""""""""

let g:tex_flavor = 'latex'
let g:rst_syntax_code_list = {
  \ 'scala': ['scala'],
  \ 'haskell': ['haskell'],
  \ 'idris2': ['idris', 'idris2'],
  \ 'tex': ['tex', 'latex'],
  \ 'java': ['java'],
  \ 'xml': ['xml'],
  \ 'html': ['html'],
  \ 'sh': ['sh'],
  \ 'cpp': ['cpp', 'c++'],
  \ 'python': ['python']
  \ }
let g:markdown_fenced_languages = [
  \ 'scala=scala', 'haskell=haskell', 'idris=idris2', 'bash=sh', 'sh=sh', '{eval-rst}=rst', 'tex=tex', 'c=c', 'json=json']
" NOTICE! Addition `java=java` above ruins spellchecking everywhere but headings O_O

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
      text = { "|", "∥", "⦀", "❚" },
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
"lua vim.uv.new_timer():start(2000, 1500, function() vim.schedule(function() vim.cmd('AirlineRefresh'); end); end)

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

"""""""""""""""""""""
" vim: textwidth=152
