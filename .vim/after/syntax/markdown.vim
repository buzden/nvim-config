""" Idris-specific stuff

" Highlight hidden Idris like Idris code block
syn region hiddenIdris matchgroup=markdownCodeDelimiter start="^<!-- idris$" end="^-->$" keepend contains=@markdownHighlight_idris2

" Highlight hidden Idris like Idris code block
syn region hiddenIdris matchgroup=markdownCodeDelimiter start="^::: *idris$" end="^:::$" keepend contains=@markdownHighlight_idris2

" Highlight inline Idris of Pandoc's Markdown
"syn region hiddenIdris matchgroup=markdownCodeDelimiter start="`" end="`{.idris}" keepend contains=@markdownHighlight_idris2

""" Stuff specific for MyST dialect

syn match mystRole "{[^}]*}`[^`]*`"
hi def link mystRole Identifier

syn match mystRefDef "\s*(.*)=\s*$"
hi def link mystRefDef Keyword

syn match mystComment "%.*$" contains=@Spell
hi def link mystComment Comment

syn match mystColonFence "^\s*::::* *\a*\({[^}]*}\)\=$"
syn match mystColonFence "^\s*::::*\s*$"
hi def link mystColonFence markdownCodeDelimiter

""" Personal preferences

syn region mystTodo matchgroup=markdownCodeDelimiter start="^\s*::: *{todo}" end="^\s*:::\s*$" keepend contains=@Spell
hi def mystTodo ctermfg=64 "39 "93

" Highlight (inline) code like it is done in `rst.vim`
hi link markdownCode String

" Make code delimiters not so screaming
hi markdownCodeDelimiter ctermfg=240
