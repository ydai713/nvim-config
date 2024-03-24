_G.dbt_compile_output_buf = nil

local M = {}

local function dbt_compile()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname:match("^.+(%..+)$") == ".sql" then
    -- Extract filename without extension
    local filename = bufname:match("^.+/(.+)%..+$")
    -- Command to compile the SQL file using dbt
    local cmd = "dbt --no-use-colors compile --output text --defer --state ./prod --select " .. filename

    -- Check if the output buffer already exists and is valid
    if not _G.dbt_compile_output_buf or not vim.api.nvim_buf_is_valid(_G.dbt_compile_output_buf) then
      -- Create a new buffer for the output
      _G.dbt_compile_output_buf = vim.api.nvim_create_buf(false, true)
      -- Optionally, name the buffer for easier identification
      vim.api.nvim_buf_set_name(_G.dbt_compile_output_buf, "DBT Compile Output")
      vim.api.nvim_buf_set_option(_G.dbt_compile_output_buf, "filetype", "sql")
    end

    -- Clear existing lines in the output buffer
    vim.api.nvim_buf_set_lines(_G.dbt_compile_output_buf, 0, -1, false, {})

    -- Ensure the output buffer is displayed in a window
    local win_found = false
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == _G.dbt_compile_output_buf then
        win_found = true
        break
      end
    end
    if not win_found then
      -- Split the window and display the output buffer
      vim.cmd("vsplit")
      vim.api.nvim_win_set_buf(0, _G.dbt_compile_output_buf)
    end

    -- Function to handle command output and display it in the output buffer
    local function on_event(job_id, data, event)
      if event == "stdout" or event == "stderr" then
        for _, line in ipairs(data) do
          if line ~= "" and not line.match(line, "^%d+:%d+:%d+") then
            vim.api.nvim_buf_set_lines(_G.dbt_compile_output_buf, -1, -1, false, { line })
          end
        end
      end
    end

    -- Start the job
    vim.fn.jobstart(cmd, {
      on_stdout = on_event,
      on_stderr = on_event,
      on_exit = function(job_id, code, event)
        if code ~= 0 then
          vim.api.nvim_buf_set_lines(
            _G.dbt_compile_output_buf,
            -1,
            -1,
            false,
            { "dbt compile finished with error code: " .. code }
          )
        end
      end,
    })
  end
end

local function dbt_format()
  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname:match("^.+(%..+)$") == ".sql" then
    print("Formatting current buffer")
    -- Correctly format the command for jobstart
    local cmd = { "sqlfluff", "fix", bufname }

    -- Start the job with a callback to print the command upon completion
    local job_id = vim.fn.jobstart(cmd, {
      on_exit = function(id, exit_code, event)
        print("Formatting completed")
        if vim.api.nvim_buf_is_loaded(bufnr) then
          -- Reload the buffer content from the file
          vim.cmd("edit!")
        end
      end,
    })
  else
    print("Current buffer is not an SQL file")
  end
end

local function dbt_lineage()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname:match("^.+(%..+)$") == ".sql" then
    local filename = bufname:match("^.+/(.+)%..+$")
    local cmd = { "dbt-lineage-viewer", "--max-depth", "2", filename, "--output", "/tmp/dbt_lineage.html" }

    -- Start the job with a callback
    local job_id = vim.fn.jobstart(cmd, {
      on_exit = function(id, exit_code, event)
        if exit_code == 0 then
          -- Assuming the URL or file path to open is known and static, e.g., the output location
          local open_cmd = { "open", "/tmp/dbt_lineage.html" } -- Directly use the output file path
          vim.fn.jobstart(open_cmd)
        else
          print("dbt-lineage-viewer command failed with exit code: " .. exit_code)
        end
      end,
    })
  else
    print("Current buffer is not an SQL file")
  end
end

local function dbt_run()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname:match("^.+(%..+)$") == ".sql" then
    -- Extract filename without extension
    local filename = bufname:match("^.+/(.+)%..+$")
    -- Command to run the SQL file using dbt
    local cmd = "dbt --no-use-colors run --fail-fast --defer --state ./prod --select " .. filename

    -- Check if the output buffer already exists and is valid
    if not _G.dbt_run_output_buf or not vim.api.nvim_buf_is_valid(_G.dbt_run_output_buf) then
      -- Create a new buffer for the output
      _G.dbt_run_output_buf = vim.api.nvim_create_buf(false, true)
      -- Optionally, name the buffer for easier identification
      vim.api.nvim_buf_set_name(_G.dbt_run_output_buf, "DBT Run Output")
    end

    -- Clear existing lines in the output buffer
    vim.api.nvim_buf_set_lines(_G.dbt_run_output_buf, 0, -1, false, {})

    -- Ensure the output buffer is displayed in a window
    local win_found = false
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == _G.dbt_run_output_buf then
        win_found = true
        break
      end
    end
    if not win_found then
      -- Split the window and display the output buffer
      vim.cmd("vsplit")
      vim.api.nvim_win_set_buf(0, _G.dbt_run_output_buf)
    end

    -- Function to handle command output and display it in the output buffer
    local function on_event(job_id, data, event)
      if event == "stdout" or event == "stderr" then
        for _, line in ipairs(data) do
          vim.api.nvim_buf_set_lines(_G.dbt_run_output_buf, -1, -1, false, { line })
        end
      end
    end

    -- Start the job
    vim.fn.jobstart(cmd, {
      on_stdout = on_event,
      on_stderr = on_event,
      on_exit = function(job_id, code, event)
        if code ~= 0 then
          vim.api.nvim_buf_set_lines(
            _G.dbt_run_output_buf,
            -1,
            -1,
            false,
            { "dbt run finished with error code: " .. code }
          )
        end
      end,
    })
  end
end

local function dbt_show_table()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname:match("^.+(%..+)$") == ".sql" then
    -- Extract filename without extension
    local filename = bufname:match("^.+/(.+)%..+$")
    -- Command to run the SQL file using dbt
    local cmd = "dbt --no-use-colors show --output text --defer --state ./prod --full-refresh --select " .. filename

    -- Check if the output buffer already exists and is valid
    if not _G.dbt_show_output_buf or not vim.api.nvim_buf_is_valid(_G.dbt_show_output_buf) then
      -- Create a new buffer for the output
      _G.dbt_show_output_buf = vim.api.nvim_create_buf(false, true)
      -- Optionally, name the buffer for easier identification
      vim.api.nvim_buf_set_name(_G.dbt_show_output_buf, "DBT Show Output")
    end

    -- Clear existing lines in the output buffer
    vim.api.nvim_buf_set_lines(_G.dbt_show_output_buf, 0, -1, false, {})

    -- Ensure the output buffer is displayed in a window
    local win_found = false
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == _G.dbt_show_output_buf then
        win_found = true
        break
      end
    end
    if not win_found then
      -- Split the window and display the output buffer
      vim.cmd("vsplit")
      vim.api.nvim_win_set_buf(0, _G.dbt_show_output_buf)
    end

    -- Function to handle command output and display it in the output buffer
    local function on_event(job_id, data, event)
      if event == "stdout" or event == "stderr" then
        for _, line in ipairs(data) do
          if line ~= "" and not line.match(line, "^%d+:%d+:%d+") then
            vim.api.nvim_buf_set_lines(_G.dbt_show_output_buf, -1, -1, false, { line })
          end
        end
      end
    end

    -- Start the job
    vim.fn.jobstart(cmd, {
      on_stdout = on_event,
      on_stderr = on_event,
      on_exit = function(job_id, code, event)
        if code ~= 0 then
          vim.api.nvim_buf_set_lines(
            _G.dbt_show_output_buf,
            -1,
            -1,
            false,
            { "dbt run finished with error code: " .. code }
          )
        end
      end,
    })
  end
end

local function dbt_show_json()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname:match("^.+(%..+)$") == ".sql" then
    -- Extract filename without extension
    local filename = bufname:match("^.+/(.+)%..+$")
    -- Command to run the SQL file using dbt
    local cmd = "dbt --no-use-colors show --output json --defer --state ./prod --full-refresh --select " .. filename

    -- Check if the output buffer already exists and is valid
    if not _G.dbt_show_output_buf or not vim.api.nvim_buf_is_valid(_G.dbt_show_output_buf) then
      -- Create a new buffer for the output
      _G.dbt_show_output_buf = vim.api.nvim_create_buf(false, true)
      -- Optionally, name the buffer for easier identification
      vim.api.nvim_buf_set_name(_G.dbt_show_output_buf, "DBT Show Output")
      vim.api.nvim_buf_set_option(_G.dbt_show_output_buf, "filetype", "json")
    end

    -- Clear existing lines in the output buffer
    vim.api.nvim_buf_set_lines(_G.dbt_show_output_buf, 0, -1, false, {})

    -- Ensure the output buffer is displayed in a window
    local win_found = false
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == _G.dbt_show_output_buf then
        win_found = true
        break
      end
    end
    if not win_found then
      -- Split the window and display the output buffer
      vim.cmd("vsplit")
      vim.api.nvim_win_set_buf(0, _G.dbt_show_output_buf)
    end

    -- Function to handle command output and display it in the output buffer
    local function on_event(job_id, data, event)
      if event == "stdout" or event == "stderr" then
        for _, line in ipairs(data) do
          if line.match(line, "^%d+:%d+:%d+%s+%{") then
            vim.api.nvim_buf_set_lines(_G.dbt_show_output_buf, -1, -1, false, { "{" })
          elseif line ~= "" and not line.match(line, "^%d+:%d+:%d+") then
            vim.api.nvim_buf_set_lines(_G.dbt_show_output_buf, -1, -1, false, { line })
          end
        end
      end
    end

    -- Start the job
    vim.fn.jobstart(cmd, {
      on_stdout = on_event,
      on_stderr = on_event,
      on_exit = function(job_id, code, event)
        if code ~= 0 then
          vim.api.nvim_buf_set_lines(
            _G.dbt_show_output_buf,
            -1,
            -1,
            false,
            { "dbt run finished with error code: " .. code }
          )
        end
      end,
    })
  end
end

M.dbt_compile = dbt_compile
M.dbt_format = dbt_format
M.dbt_lineage = dbt_lineage
M.dbt_run = dbt_run
M.dbt_show_table = dbt_show_table
M.dbt_show_json = dbt_show_json

return M
