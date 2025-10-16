syn match   gitcommitSummary	"^.*\%<73v." contained containedin=gitcommitFirstLine nextgroup=gitcommitOverflow contains=@Spell
hi def link gitcommitOverflow		Error
