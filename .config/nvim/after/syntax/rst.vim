hi rstInlineCode ctermfg=239

syn region inlineIdris   matchgroup=rstInlineCode start=":idris:`"   end="`" keepend contains=@rstidris2
syn region inlineHaskell matchgroup=rstInlineCode start=":haskell:`" end="`" keepend contains=@rsthaskell
syn region inlineLatex   matchgroup=rstInlineCode start=":latex:`"   end="`" keepend contains=@rsttex

" `rstComment` below is copied from the neovim's `syntax/rst.vim` and modified
" to contain `@Spell`.
"execute 'syn region rstComment contained' .
"      \ ' start=/.*/'
"      \ ' skip=+^$+' .
"      \ ' end=/^\s\@!/ contains=rstTodo,@Spell'
" The code above is commented out because it somewhy breaks highlighting of
" the `.. code:: ...` sections.
