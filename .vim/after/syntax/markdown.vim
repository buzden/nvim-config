""" Idris-specific stuff

" Highlight hidden Idris like Idris code block
syn region hiddenIdris matchgroup=markdownCodeDelimiter start="^<!-- idris$" end="^-->$" keepend contains=@markdownHighlight_idris2

" Highlight hidden Idris like Idris code block
syn region hiddenIdris matchgroup=markdownCodeDelimiter start="^::: *idris$" end="^:::$" keepend contains=@markdownHighlight_idris2

" Highlight inline Idris of Pandoc's Markdown
syn region inlineIdris matchgroup=markdownCodeDelimiter start="`" end="`{.idris}" oneline keepend contains=@markdownHighlight_idris2

""" LaTeX-specific stuff

" Highlight inline LaTeX of Pandoc's Markdown
syn region inlineLaTeX matchgroup=markdownCodeDelimiter start="`" end="`{=latex}" oneline keepend contains=@markdownHighlight_tex

" Highlight LaTeX-code-inside-Markdown
syn region inlineLaTeXCmd start="\\[a-zA-Z0-9]*" end="$" oneline contains=@markdownHighlight_tex

"" Highlight LaTeX code block
"syn region injectedLaTeX matchgroup=markdownCodeDelimiter start="^::::* *{\=latex}$" end="^::::*$" keepend contains=@markdownHighlight_tex

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
