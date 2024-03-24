local M = {}

local function swap_windows()
  local win_count = #vim.api.nvim_list_wins()

  if win_count ~= 2 then
    print("This function works with exactly two windows.")
    return
  end

  -- Get current and other window IDs
  local current_win = vim.api.nvim_get_current_win()
  local windows = vim.api.nvim_list_wins()
  local other_win = windows[1] == current_win and windows[2] or windows[1]

  -- Get buffer IDs for each window
  local current_buf = vim.api.nvim_win_get_buf(current_win)
  local other_buf = vim.api.nvim_win_get_buf(other_win)

  -- Swap the buffers
  vim.api.nvim_win_set_buf(current_win, other_buf)
  vim.api.nvim_win_set_buf(other_win, current_buf)
end

M.swap_windows = swap_windows
return M
