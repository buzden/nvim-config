syn region codeInString matchgroup=Keyword start="\\{" end="}" keepend contains=TOP
syn match idrisTypeDecl "[a-zA-Z][a-zA-z0-9_']*\(\s*,\s*[a-zA-Z][a-zA-z0-9_']*\)*\s\+:\(\s\+\|$\)" contains=idrisIdentifier,idrisOperators
" @idris2 "TODO how to refer to the whole itself?
