hi rstInlineCode ctermfg=239

syn region inlineIdris   matchgroup=rstInlineCode start=":idris:`"   end="`" keepend contains=@rstidris2
syn region inlineHaskell matchgroup=rstInlineCode start=":haskell:`" end="`" keepend contains=@rsthaskell
syn region inlineLatex   matchgroup=rstInlineCode start=":latex:`"   end="`" keepend contains=@rsttex
