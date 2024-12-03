local Split = require('nui.split')
local event = require('nui.utils.autocmd').event

local M = {}

M.res_buff = nil
M.already_escaped = false

function M.setup()
  M.res_buff = Split({
    relative = 'editor',
    position = 'bottom',
    size = 0,
    focusable = false,
    win_options = {
      foldenable = false,
      spell = false,
      signcolumn = 'no',
      wrap = false,
      number = false,
      relativenumber = false,
      foldenable = false,
    },
    buf_options = {
      modifiable = false,
      buftype = 'nofile',
      swapfile = false,
      buflisted = false,
    },
  })
  M.res_buff:mount()
  vim.api.nvim_buf_set_name(M.res_buff.bufnr, 'Typst compilation errors')
  M.res_buff:on({event.BufWinEnter, event.BufEnter}, function()
    if vim.fn.winnr('$') == 1 and vim.api.nvim_get_current_win() == M.res_buff.winid then
      vim.cmd [[q]]
    end
  end)
  M.res_buff:on({event.BufHidden, event.WinClosed}, function()
    M.res_buff:hide()
  end)
  M.res_buff:hide()
end

function M.hide()
  M.res_buff:hide()
end

function M.check(clearBeforeEcho)
  local flines = vim.fn.join(vim.fn.getline(1, '$'), '\n')
  if clearBeforeEcho then
    vim.cmd [[ call feedkeys(':', 'nx') " For clearing previous messages ]]
  end
  vim.cmd [[ echo "Checking typst..." ]]
  local tc = vim.fn.system(string.format("%s --color=always compile --format=pdf - /dev/null", vim.g.typst_cmd), flines)
  if clearBeforeEcho then
    vim.cmd [[ call feedkeys(':', 'nx') " For clearing previous messages ]]
  end

  M.res_buff:hide()
  if tc == "" then
    vim.cmd [[
      echohl DiagnosticOk
      echo "Successfully checked typst"
      echohl None
    ]]
  else
    local winnr = vim.api.nvim_get_current_win()

    local tclines = vim.split(tc, '\n')
    tclines = vim.lsp.util.trim_empty_lines(tclines)
    table.insert(tclines, 1, '')
    table.insert(tclines, '')

    M.res_buff:show()
    vim.api.nvim_buf_set_option(M.res_buff.bufnr, 'modifiable', true)
    vim.api.nvim_buf_set_lines(M.res_buff.bufnr, 0, -1, false, tclines)
    vim.api.nvim_win_set_height(0, #(tclines)) -- reading current since we did `show()` above
    vim.api.nvim_buf_set_option(M.res_buff.bufnr, 'modifiable', false)
    if not M.already_escaped then
      vim.cmd [[ AnsiEsc ]]
      M.already_escaped = true
    end

    vim.api.nvim_set_current_win(winnr)
  end
end

return M
