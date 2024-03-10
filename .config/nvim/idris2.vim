""""""""""""""""""""
" Enable Idris-LSP "
"                  "
""""""""""""""""""""

lua << EOF

local function custom_on_attach(client)

  vim.cmd [[ nnoremap <silent> <LocalLeader>j <Cmd>lua vim.lsp.buf.definition()<CR> ]]

  vim.cmd [[ nnoremap <silent> <CR>           <Cmd>noh<CR><Cmd>lua require('idris2.hover').close_split()<CR> ]]
  vim.cmd [[ nnoremap <silent> <LocalLeader>t <Cmd>lua require('idris2.hover').open_split(); vim.lsp.buf.hover()<CR> ]]
  vim.cmd [[ nnoremap <silent> <LocalLeader>y <Cmd>lua require('idris2.hover').close_split(); vim.lsp.buf.hover()<CR> ]]
  vim.cmd [[ nnoremap <silent> <LocalLeader>h <Cmd>lua vim.lsp.buf.signature_help()<CR> ]]

  vim.cmd [[ nnoremap <silent> <LocalLeader>i <Cmd>lua require('idris2').show_implicits()<CR> ]]
  vim.cmd [[ nnoremap <silent> <LocalLeader>I <Cmd>lua require('idris2').hide_implicits()<CR> ]]
  vim.cmd [[ nnoremap <silent> <LocalLeader>n <Cmd>lua require('idris2').full_namespace()<CR> ]]
  vim.cmd [[ nnoremap <silent> <LocalLeader>N <Cmd>lua require('idris2').hide_namespace()<CR> ]]

  vim.cmd [[ nnoremap <silent> <LocalLeader>c  <Cmd>lua require('idris2.code_action').case_split()<CR> ]]
  vim.cmd [[ nnoremap <silent> <LocalLeader>mc <Cmd>lua require('idris2.code_action').make_case()<CR> ]]
  vim.cmd [[ nnoremap <silent> <LocalLeader>mw <Cmd>lua require('idris2.code_action').make_with()<CR> ]]
  vim.cmd [[ nnoremap <silent> <LocalLeader>l  <Cmd>lua require('idris2.code_action').make_lemma()<CR> ]]
  vim.cmd [[ nnoremap <silent> <LocalLeader>d  <Cmd>lua require('idris2.code_action').add_clause()<CR> ]]
  vim.cmd [[ nnoremap <silent> <LocalLeader>g  <Cmd>lua require('idris2.code_action').generate_def()<CR> ]]
  vim.cmd [[ nnoremap <silent> <LocalLeader>p  <Cmd>lua require('idris2.code_action').refine_hole()<CR> ]]
  vim.cmd [[ nnoremap <silent> <LocalLeader>P  <Cmd>lua require('idris2.code_action').expr_search()<CR> ]]
  vim.cmd [[ nnoremap <silent> <LocalLeader>O  <Cmd>lua require('idris2.code_action').intro()<CR> ]]

  vim.cmd [[ nnoremap <silent> <LocalLeader><Tab> <Cmd>lua require('idris2.browse').browse()<CR> ]]
  vim.cmd [[ nnoremap <silent> <LocalLeader>e <Cmd>lua require('idris2.repl').evaluate()<CR> ]]
  vim.cmd [[ nnoremap <silent> <LocalLeader>v <Cmd>lua require('idris2.metavars').request_all()<CR> ]]

  vim.cmd [[ nnoremap <silent> <LocalLeader>x <Cmd>lua vim.diagnostic.goto_next()<CR> ]]
  vim.cmd [[ nnoremap <silent> <LocalLeader>z <Cmd>lua vim.diagnostic.goto_prev()<CR> ]]

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

autocmd FileType idris2 :nnoremap <silent> <LocalLeader>r <CMD>call IdrisReload()<CR>
autocmd FileType idris2 :nnoremap <silent> <LocalLeader>o <CMD>call IdrisTrivialProofSearch()<CR>
autocmd FileType idris2 :nnoremap <silent> <LocalLeader>t <CMD>call IdrisShowType()<CR>
autocmd FileType idris2 :nnoremap <silent> <LocalLeader>T <CMD>call IdrisShowType()<CR>
autocmd FileType idris2 :nnoremap <silent> <LocalLeader>c <CMD>call IdrisCaseSplit()<CR>
autocmd FileType idris2 :nnoremap <silent> <LocalLeader>C <CMD>call IdrisCaseSplit()<CR>

" Set the current directory to be one of the open file
autocmd FileType idris2 :cd %:p:h

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
