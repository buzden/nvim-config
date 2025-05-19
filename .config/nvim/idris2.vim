""""""""""""""""""""
" Enable Idris-LSP "
"                  "
""""""""""""""""""""

lua << EOF

local function custom_on_attach(client)

  vim.cmd [[
    nnoremap <silent> <LocalLeader>j <Cmd>echo "Jumping to the definition..."<CR><Cmd>lua vim.lsp.buf.definition()<CR>

    nnoremap <silent> <CR>           <Cmd>noh<CR><Cmd>lua require('idris2.hover').close_split()<CR>
    nnoremap <silent> <LocalLeader>t <Cmd>lua require('idris2.hover').open_split(); vim.lsp.buf.hover()<CR>
    nnoremap <silent> <LocalLeader>y <Cmd>lua require('idris2.hover').close_split(); vim.lsp.buf.hover()<CR>
    nnoremap <silent> <LocalLeader>h <Cmd>lua vim.lsp.buf.signature_help()<CR>

    nnoremap <silent> <LocalLeader>i <Cmd>echo "Show implicits: on"<CR><Cmd>lua require('idris2').show_implicits()<CR>
    nnoremap <silent> <LocalLeader>I <Cmd>echo "Show implicits: off"<CR><Cmd>lua require('idris2').hide_implicits()<CR>
    nnoremap <silent> <LocalLeader>n <Cmd>echo "Namespaces: show full"<CR><Cmd>lua require('idris2').full_namespace()<CR>
    nnoremap <silent> <LocalLeader>N <Cmd>echo "Namespaces: hide"<CR><Cmd>lua require('idris2').hide_namespace()<CR>

    nnoremap <silent> <LocalLeader>c  <Cmd>lua require('idris2.code_action').case_split()<CR>
    nnoremap <silent> <LocalLeader>mc <Cmd>lua require('idris2.code_action').make_case()<CR>
    nnoremap <silent> <LocalLeader>mw <Cmd>lua require('idris2.code_action').make_with()<CR>
    nnoremap <silent> <LocalLeader>l  <Cmd>lua require('idris2.code_action').make_lemma()<CR>
    nnoremap <silent> <LocalLeader>d  <Cmd>lua require('idris2.code_action').add_clause()<CR>
    nnoremap <silent> <LocalLeader>g  <Cmd>lua require('idris2.code_action').generate_def()<CR>
    nnoremap <silent> <LocalLeader>p  <Cmd>lua require('idris2.code_action').refine_hole()<CR>
    nnoremap <silent> <LocalLeader>P  <Cmd>lua require('idris2.code_action').expr_search()<CR>
    nnoremap <silent> <LocalLeader>O  <Cmd>lua require('idris2.code_action').intro()<CR>

    nnoremap <silent> <LocalLeader><Tab> <Cmd>lua require('idris2.browse').browse()<CR>
    nnoremap <silent> <LocalLeader>e <Cmd>lua require('idris2.repl').evaluate()<CR>
    nnoremap <silent> <LocalLeader>v <Cmd>lua require('idris2.metavars').request_all()<CR>

    nnoremap <silent> <LocalLeader>x <Cmd>lua vim.diagnostic.goto_next()<CR>
    nnoremap <silent> <LocalLeader>z <Cmd>lua vim.diagnostic.goto_prev()<CR>

    nnoremap <silent> <C-o> <C-o><Cmd>echo "Restarting LSP..."<CR><Cmd>cd %:p:h<CR><Cmd>LspRestart<CR>
    nnoremap <silent> <C-i> <C-i><Cmd>echo "Restarting LSP..."<CR><Cmd>cd %:p:h<CR><Cmd>LspRestart<CR>
  ]]

end

local function save_hook(action)
  vim.cmd('silent write')
end

local opts = {
  client = {
    hover = {
      use_split = false,
      split_size = 0,
      auto_resize_split = true,
      with_history = false,
      split_position = 'bottom',
    },
  },

  -- Options passed to lspconfig idris2 configuration
  server = {
    on_attach = custom_on_attach,
    init_options = {
      logSeverity = "ERROR"
    }
  },

  -- Function to execute after a code action is performed
  code_action_post_hook = save_hook,

  -- Set default highlight groups for semantic tokens
  use_default_semantic_hl_groups = false,
}

require('idris2').setup(opts)

EOF

"""""""""""""""""""""""""
" Idris non-LSP actions "
"                       "
"""""""""""""""""""""""""

" These functions are based on the original Edwin Brady's idris2-vim plugin

function! IWrite(str, colour)
  exec "echohl " . a:colour
  echo substitute(a:str, "\n$", "", "")
  echohl None
endfunction

function! IdrisReload()
  w
  let file = expand('%:p')
  let tc = system("idris2 --no-colour --find-ipkg " . shellescape(file) . " --client ''")
  if (! (tc is ""))
    call IWrite(tc, "DiagnosticWarn")
  else
    call IWrite("Successfully reloaded " . file, "LspSemantic_enumMember")
  endif
  return tc
endfunction

function! s:IdrisCommand(...)
  let idriscmd = shellescape(join(a:000))
  return system("idris2 --no-color --find-ipkg " . shellescape(expand('%:p')) . " --client " . idriscmd)
endfunction

" Text near cursor position that needs to be passed to a command.
" Refinment of `expand(<cword>)` to accomodate differences between
" a (n)vim word and what Idris requires.
function! s:currentQueryObject()
  let word = expand("<cword>")
  if word =~ '^?'
    " Cut off '?' that introduces a hole identifier.
    let word = strpart(word, 1)
  endif
  return word
endfunction

function! IdrisShowType()
  w
  let word = s:currentQueryObject()
  let ty = s:IdrisCommand(":t", word)
  call IWrite(ty, "Comment")
endfunction

function! IdrisTrivialProofSearch()
  let view = winsaveview()
  w
  let cline = line(".")
  let word = s:currentQueryObject()

  let result = s:IdrisCommand(":ps!", cline, word, "")
  if (! (result is ""))
    call IWrite(result, "DiagnosticWarn")
  else
    e
    call winrestview(view)
  endif
endfunction

function! IdrisCaseSplit()
  w
  let view = winsaveview()
  let cline = line(".")
  let ccol = col(".")
  let word = expand("<cword>")
  let result = s:IdrisCommand(":cs!", cline, ccol, word)
  if (! (result is ""))
    call IWrite(result, "DiagnosticWarn")
  else
    e
    call winrestview(view)
  endif
endfunction

autocmd FileType idris2 :nnoremap <silent> <LocalLeader>R <Cmd>cd %:p:h<CR><Cmd>echo "Restarting LSP..."<CR><CMD>LspRestart<CR>
autocmd FileType idris2 :nnoremap <silent> <LocalLeader>r <Cmd>cd %:p:h<CR><Cmd>echo "Reloading Idris file..."<CR><CMD>call IdrisReload()<CR>
autocmd FileType idris2 :nnoremap <silent> <LocalLeader>o <Cmd>cd %:p:h<CR><CMD>call IdrisTrivialProofSearch()<CR>
autocmd FileType idris2 :nnoremap <silent> <LocalLeader>t <Cmd>cd %:p:h<CR><CMD>call IdrisShowType()<CR>
autocmd FileType idris2 :nnoremap <silent> <LocalLeader>T <Cmd>cd %:p:h<CR><CMD>call IdrisShowType()<CR>
autocmd FileType idris2 :nnoremap <silent> <LocalLeader>c <Cmd>cd %:p:h<CR><CMD>call IdrisCaseSplit()<CR>
autocmd FileType idris2 :nnoremap <silent> <LocalLeader>C <Cmd>cd %:p:h<CR><CMD>call IdrisCaseSplit()<CR>

let g:idris_indent_if = 2
let g:idris_indent_case = 2
let g:idris_indent_rewrite = 0

""""""""""""""""""""""""""""""
" Colors for semantic values "
"                            "
""""""""""""""""""""""""""""""

" Type constructors
highlight LspSemantic_type ctermfg=33
" Data constructors
highlight LspSemantic_enumMember ctermfg=46

" Variables
highlight LspSemantic_variable ctermfg=245
highlight @lsp.type.variable   ctermfg=245

" Explicit namespaces
highlight LspSemantic_namespace ctermfg=118 cterm=bold
" Module identifiers
highlight link LspSemantic_module Identifier
" Postulates
highlight LspSemantic_postulate ctermbg=52 cterm=bold

" Disable infelicitous categories
highlight link LspSemantic_function NONE
highlight link @lsp.type.function   NONE
highlight link LspSemantic_keyword  NONE

" vim: textwidth=152
