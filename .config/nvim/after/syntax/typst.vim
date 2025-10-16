""" Personal preferences

hi def typstMarkupRawBlock ctermfg=64
hi def Macro ctermfg=64

""" Idris-specific stuff

" Highlight hidden Idris like Idris code block
syn region hiddenIdris matchgroup=typstMarkupRawBlock start="^/* idris$" end="^*/$" keepend contains=@typstEmbedded_idris2
