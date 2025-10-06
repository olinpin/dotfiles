local M = {}
local api = vim.api
local fn = vim.fn
local strw = api.nvim_strwidth
local opts = {
	header = {
"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣴⣶⣶⣶⣶⣦⣤⡀⠀⠀⠀⠀",
"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⠟⠉⠉⠉⠉⠉⠛⠻⢿⣷⣄⠀⠀",
"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⠟⠁⠀⠀⢠⣤⣄⠀⠀⠀⠀⠙⣿⣷⠀",
"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⠏⠀⠀⠀⠀⠘⠻⠋⠀⠀⠀⠀⠀⢸⣿⡇",
"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⡏⠀⠀⣀⣀⣀⣠⣤⣤⣤⣤⣿⣄⠀⢠⣿⣧",
"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⠀⠀⠀⠈⠻⣿⣶⠶⣶⣤⣤⣜⣿⣦⡈⢿⣿",
"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠀⠀⠀⠀⠀⠈⠙⠻⢶⣤⣭⣛⣿⣿⣷⣼⣿",
"⠀⠀⠀⠀⠀⣰⣶⣾⠿⠿⢿⣷⣶⣄⠀⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠛⠛⢛⣿⣿",
"⠀⠀⠀⠀⠀⢹⣿⣆⠀⠀⠀⠈⠻⢿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⡏",
"⠀⠀⠀⠀⠀⣸⣿⣿⠀⠀⠀⠀⠀⠀⢀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠀",
"⠀⠀⠀⢀⣾⣿⣿⡇⠀⠀⠀⠀⠀⠀⢸⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⡇⠀",
"⠀⠀⠀⣼⣿⠃⠹⣿⣷⣄⠀⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠇⠀",
"⠀⠀⠀⣿⡿⠀⠀⠈⠻⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀",
"⠀⠀⢸⣿⣧⠀⠀⠀⠀⠸⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡷⠀⠀",
"⠀⠀⠈⣿⣿⡄⠀⠀⠀⠀⢻⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⡀⠀",
"⠀⠀⠀⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣧⠀",
"⠀⠀⠀⢻⣿⡟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⡇",
"⠀⠀⠀⠘⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⡿",
"⠀⠀⠀⣤⣸⣿⣿⡷⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠃",
"⠀⠀⠘⣿⡿⠿⣿⣿⣿⣷⡶⢶⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⠏⠀",
"⠀⠀⢀⣿⡟⠀⠀⠀⠀⠀⠀⠈⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡿⠟⠉⠀⠀",
"⠀⠀⣼⣿⠇⠀⣴⣄⠀⠀⠀⠀⢹⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣶⣿⠟⠁⠀⠀⠀⠀",
"⢀⣼⣿⠋⠀⠀⠘⣿⣧⠀⠀⠀⢸⣿⣧⣄⣀⠀⠀⠀⢀⣀⣤⣶⣿⣿⠋⠁⠀⠀⠀⠀⠀⠀",
"⢾⣯⣁⠀⠀⠀⠀⠈⢿⡄⠀⠀⣸⡿⠉⠙⠛⠛⠛⠛⢻⣿⡏⢹⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀",
"⠀⠛⢿⣷⣦⣤⣀⡀⠀⠀⠀⣠⣿⣷⣶⣶⣶⣶⣶⣦⣤⣿⣿⡜⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀",
"⠀⠀⠀⠈⠙⠛⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⢻⡿⣷⣶⣤⣀⠀⠀⠀⠀",
"⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣏⣁⡸⠟⠈⣩⣿⣿⣿⠶⠀⠀",
"⠀⠀⠀⣠⣴⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣿⠟⠋⠁⠀⠀⠀⠀",
"⠀⠀⠀⠙⠿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀",
"⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
"       WADDLE WADDLE WADDLE       ",
},
	buttons = {}
}

M.open = function(buf, win, action)
  action = action or "open"

  win = win or api.nvim_get_current_win()

  if not vim.bo.buflisted and action == "open" then
    if vim.t.bufs[1] then
      win = vim.fn.bufwinid(vim.t.bufs[1])
      api.nvim_set_current_win(win)
    end
  end

  local ns = api.nvim_create_namespace "nvdash"
  local winh = api.nvim_win_get_height(win)
  local winw = api.nvim_win_get_width(win)
  buf = buf or vim.api.nvim_create_buf(false, true)

  local nvdash_w = 0

  if action == "open" then
    api.nvim_win_set_buf(0, buf)
  end

  opts.header = type(opts.header) == "function" and opts.header() or opts.header

  local ui = {}

  ------------------------ find largest string's width -----------------------------
  for _, v in ipairs(opts.header) do
    local headerw = strw(v)
    if headerw > nvdash_w then
      nvdash_w = headerw
    end

    local col = math.floor((winw / 2) - math.floor(strw(v) / 2)) - 6
    local opt = { virt_text_win_col = col, virt_text = { { v, "NvDashAscii" } } }
    table.insert(ui, opt)
  end

  opts.buttons = type(opts.buttons) == "table" and opts.buttons or opts.buttons()

  local key_lines = {}

  ----------------------- save display txt -----------------------------------------
  local dashboard_h = #ui + 3

  -- if screen height is small
  winh = dashboard_h > winh and dashboard_h or winh

  local row_i = math.floor((winh / 2) - (dashboard_h / 2))

  for i, v in ipairs(key_lines) do
    key_lines[i].i = v.i + row_i + 1
  end

  -- make all lines available
  local empty_str = {}
  for i = 1, winh do
    empty_str[i] = ""
  end

  ------------------------------ EXTMARKS : set text + highlight -------------------------------
  api.nvim_buf_set_lines(buf, 0, -1, false, empty_str)

  for i, v in ipairs(ui) do
    api.nvim_buf_set_extmark(buf, ns, row_i + i, 0, v)
  end

  if action == "redraw" then
    return
  end

  ------------------------------------ keybinds ------------------------------------------
  vim.wo[win].virtualedit = "all"

  if key_lines[1] then
    api.nvim_win_set_cursor(win, { key_lines[1].i, key_lines[1].col })
  end
end

return M
