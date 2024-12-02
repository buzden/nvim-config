set ts=2
set expandtab
set autoindent

" Sets X11 title
set title

" Lines numbering
set signcolumn=yes
set number " Prints the current line number
set relativenumber
hi LineNr       ctermfg=239 ctermbg=233
hi CursorLineNr ctermfg=245 ctermbg=233 cterm=bold
hi SignColumn               ctermbg=233
hi EndOfBuffer  ctermfg=12  ctermbg=233

" Make folded section be colored like a comment.
hi! link Folded Comment

"hi Normal ctermbg=233

hi Todo ctermfg=0 ctermbg=130
hi Statement ctermfg=3

fun WantPasteFrom()
  set signcolumn=no
  set nonumber
  set norelativenumber
endfun
nnoremap <silent> <C-w> :call WantPasteFrom()<CR>

" Set auto change dir
set autochdir
autocmd BufEnter * silent! lcd %:p:h

" Highlight any trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+\%#\@<!$/

" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Colours of popup menus
highlight Pmenu    ctermfg=254 ctermbg=17
highlight PmenuSel ctermfg=254 ctermbg=4 cterm=bold
highlight DiagnosticError ctermfg=magenta cterm=bold

" Tabs keys
nnoremap <silent> <A-C-Right> :bnext<CR>
nnoremap <silent> <A-C-Left>  :bNext<CR>

nnoremap <silent> <C-Tab>   :bnext<CR>
nnoremap <silent> <C-S-Tab> :bNext<CR>

" Shift page without shifting the cursor
nnoremap <silent> <S-Up> <C-y>
vnoremap <silent> <S-Up> <C-y>
nnoremap <silent> <S-Down> <C-e>
vnoremap <silent> <S-Down> <C-e>

" Syntax highlighting
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
let g:markdown_fenced_languages = ['scala=scala', 'haskell=haskell', 'idris=idris2', 'bash=sh', 'sh=sh', '{eval-rst}=rst', 'tex=tex', 'c=c']
" NOTICE! Addition `java=java` above ruins spellchecking everywhere but headings O_O
let g:typst_embedded_languages = ['idris -> idris2', 'c', 'rust', 'rs -> rust', 'sh', 'haskell', 'hs -> haskell', 'scala']
let g:typst_pdf_viewer = 'mupdf'

" Spell checking
set spelllang=ru,en

" EasyAlign plugin keys
"   start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
"   start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" This unsets the "last search pattern" register by hitting return
nnoremap <silent> <CR> :noh<CR>

" Disable `q` in the main mode
nnoremap <silent> q :<CR>

" Disable `ZZ` in the main mode
nnoremap <silent> ZZ :<CR>

" Spell-check-based work competion, press Ctrl+N or Ctrl+P to see variants
set complete+=kspell

" Config for the first-generation Idris 2 support plugin
let g:idris_indent_if = 2
let g:idris_indent_case = 2
let g:idris_indent_rewrite = 0

" Center the cursor like to be in the center of the screen
au VimEnter * normal zz

" Be able to use russian keys in a command mode
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz,Ж;:

" vim: textwidth=152
