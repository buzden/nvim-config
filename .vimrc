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

hi Visual NONE | hi Visual ctermbg=240
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
autocmd BufEnter * silent! tcd %:p:h

" Highlight any trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+\%#\@<!$/

" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Colours of floating messages
highlight NormalFloat    ctermfg=254 ctermbg=17
highlight DiagnosticError ctermfg=magenta cterm=bold
"highlight DiagnosticError ctermbg=0 cterm=bold

" Menus
highlight Pmenu    ctermbg=17  ctermfg=254
highlight PmenuSel ctermbg=239 ctermfg=254 cterm=bold
"highlight PmenuSel ctermfg=17 ctermbg=254 cterm=bold

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
let g:markdown_fenced_languages = [
  \ 'scala=scala', 'haskell=haskell', 'idris=idris2', 'bash=sh', 'sh=sh', '{eval-rst}=rst', 'tex=tex', 'c=c', 'json=json']
" NOTICE! Addition `java=java` above ruins spellchecking everywhere but headings O_O
let g:typst_embedded_languages = ['idris -> idris2', 'c', 'rust', 'rs -> rust', 'sh', 'haskell', 'hs -> haskell', 'scala', 'json']
let g:typst_pdf_viewer = 'mupdf'

" Spell checking
set spelllang=ru,en

" This unsets the "last search pattern" register by hitting return
nnoremap <silent> <CR> :noh<CR>

" Disable `q` in the main mode
nnoremap <silent> q :<CR>

" Disable `ZZ` in the main mode
nnoremap <silent> ZZ :<CR>

" Spell-check-based work competion, press Ctrl+N or Ctrl+P to see variants
set complete+=kspell

" Center the cursor like to be in the center of the screen
au VimEnter * normal zz

" Be able to use russian keys in a command mode
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz,Ж;:

" vim: textwidth=152
