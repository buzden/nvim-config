"""""""""""""""""""""""""
""" System configuration
"""
"""""""""""""""""""""""""

" Take system files installed by external packages into account
set runtimepath^=/usr/share/vim/vimfiles runtimepath+=/usr/share/vim/vimfiles/after
let &packpath = &runtimepath

" For compat between 0.9.* and 0.10.*. This can be removed as soon as we use NeoVim 0.10.*
lua vim.uv = vim.uv or vim.loop

""""""""""""""""""""""""""
""" General options setup
"""
""""""""""""""""""""""""""

" Old (pre v0.10) colorscheme, must go as early in the config as possible
colorscheme vim
set notermguicolors

" Set identation
set ts=2
set expandtab
set autoindent

" Sets X11 title
set title

set updatetime=1500 " To make `CursorHold*` work after 1.5 s of hold

"""""""""""""""""""
""" Common colours
"""
"""""""""""""""""""

hi! link Folded Comment " Make folded section be colored like a comment.
hi Visual NONE | hi Visual ctermbg=240
hi Todo ctermfg=0 ctermbg=130
hi Statement ctermfg=3

" Colours of floating messages
hi NormalFloat     ctermfg=254 ctermbg=17
hi DiagnosticError ctermfg=magenta cterm=bold

" Menus
hi Pmenu    ctermbg=17  ctermfg=254
hi PmenuSel ctermbg=239 ctermfg=254 cterm=bold

""""""""""""""""""
""" Startup state
"""
""""""""""""""""""

" Set auto change dir
set autochdir
"autocmd BufEnter * silent! tcd %:p:h

" Center the cursor like to be in the center of the screen
au VimEnter * normal zz

"""""""""""""""""""""
""" Global nice keys
"""
"""""""""""""""""""""

" Tabs keys
nnoremap <silent> <C-Tab>   :bnext<CR>
nnoremap <silent> <C-S-Tab> :bNext<CR>
nnoremap <silent> <A-C-Right> :bnext<CR>
nnoremap <silent> <A-C-Left>  :bNext<CR>

" Shift page without shifting the cursor
nnoremap <silent> <S-Up> <C-y>
vnoremap <silent> <S-Up> <C-y>
nnoremap <silent> <S-Down> <C-e>
vnoremap <silent> <S-Down> <C-e>

" This unsets the "last search pattern" register by hitting return
nnoremap <silent> <CR> :noh<CR>

" Disable `q` and `ZZ` in the main mode
nnoremap <silent> q :<CR>
nnoremap <silent> ZZ :<CR>

"""""""""""""""""""""""""""""""""
""" Spelling and internalisation
"""
"""""""""""""""""""""""""""""""""

" Spell checking
set spelllang=ru,en

" Spell-check-based work competion, press Ctrl+N or Ctrl+P to see variants
set complete+=kspell

" Be able to use russian keys in a command mode
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz,Ж;:

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

""""""""""""""""""""
""" Lines numbering
"""
""""""""""""""""""""

fun ToggleSignColumn()
  if &signcolumn == "yes"
    set signcolumn=no
    set nonumber
    set norelativenumber
  else
    set signcolumn=yes
    set number " Prints the current line number
    set relativenumber
  endif
endfun

hi LineNr       ctermfg=239 ctermbg=233
hi CursorLineNr ctermfg=245 ctermbg=233 cterm=bold
hi SignColumn               ctermbg=233
hi EndOfBuffer  ctermfg=12  ctermbg=233

call ToggleSignColumn()
nnoremap <silent> <C-w> :call ToggleSignColumn()<CR>

"""""""""""""""""""""""""""""""""
""" Managing trailing whitespace
"""
"""""""""""""""""""""""""""""""""

" Highlight any trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+\%#\@<!$/

" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

"""""""""""""""""""""""""""""""""""
""" Line for exceeding line length
"""
"""""""""""""""""""""""""""""""""""

" Show column if it exceeds set text width (incl. set from `.editorconfig`)
" Idea taken from https://superuser.com/a/1289220, but raised to a newer level ;-)
set colorcolumn=""
highlight ColorColumn ctermbg=darkgrey
autocmd BufReadPost,ModeChanged,CursorHoldI * call ShowColumnIfLineIsTooLong()
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

"""""""""""""""""""""""""""""""""""
""" Managing plugins, if available
"""""""""""""""""""""""""""""""""""

if filereadable(fnamemodify('~/.config/nvim/plugins.vim', ':p'))
  source $HOME/.config/nvim/plugins.vim
endif

"""""""""""""""""""""
" vim: textwidth=152
