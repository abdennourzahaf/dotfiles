return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local fzf = require("fzf-lua")

    fzf.setup({
      fzf_opts = { ["--cycle"] = true },
      oldfiles = { cwd_only = true, include_current_session = true },
      keymap = {
        fzf = {
          ["ctrl-q"] = "select-all+accept",
          ["ctrl-d"] = "half-page-down",
          ["ctrl-u"] = "half-page-up",
        },
      },
      lsp = { includeDeclaration = false, jump1 = true },
      git = {
        commits = {
          winopts = { preview = { hidden = "hidden" } },
          actions = {
            ["ctrl-o"] = {
              fn = function(selected)
                local commit_hash = selected[1]:match("[^ ]+")
                vim.cmd("DiffviewOpen " .. commit_hash .. "^!")
              end,
            },
          },
        },
      },
      winopts = { preview = { delay = 0 } },
      grep = {
        rg_opts = "--column --line-number --no-heading --color=always --fixed-strings --smart-case --max-columns=4096 -e",
        actions = {
          ["ctrl-space"] = { fzf.actions.grep_lgrep },
          ["ctrl-s"] = {
            fn = function(_, opts)
              fzf.actions.toggle_flag(_, vim.tbl_extend("force", opts, { toggle_flag = "--smart-case" }))
            end,
          },
          ["ctrl-t"] = {
            fn = function(_, opts)
              fzf.actions.toggle_flag(_, vim.tbl_extend("force", opts, { toggle_flag = "-g '!*.test.*'" }))
            end,
          },
          ["ctrl-g"] = {
            fn = function(_, opts)
              fzf.actions.toggle_flag(_, vim.tbl_extend("force", opts, { toggle_flag = "-g '!*generated*'" }))
            end,
          },
        },
      },
    })

    vim.keymap.set("n", "<leader>sc", fzf.commands, { desc = "Commands" })
    vim.keymap.set("n", "<leader>sd", fzf.diagnostics_document, { desc = "Buffer diagnostics" })
    vim.keymap.set("n", "<leader>sD", fzf.diagnostics_workspace, { desc = "Workspace diagnostics" })
    vim.keymap.set("n", "<leader>sg", fzf.live_grep, { desc = "Live Grep" })
    vim.keymap.set("n", "<leader>sh", fzf.helptags, { desc = "Help Tags" })
    vim.keymap.set("n", "<leader>sj", fzf.git_commits, { desc = "Commits" })
    vim.keymap.set("n", "<leader>sk", fzf.keymaps, { desc = "Key Maps" })
    vim.keymap.set("n", "<leader>sr", fzf.resume, { desc = "Resume" })
    vim.keymap.set("n", "<leader>ss", fzf.lsp_document_symbols, { desc = "Document Symbols" })
    vim.keymap.set("n", "<leader>sw", fzf.grep_cword, { desc = "Document Symbols" })
    vim.keymap.set("n", "<leader>sw", function()
      fzf.live_grep({ query = vim.fn.expand("<cword>") })
    end, { desc = "Grep cword" })

    vim.keymap.set("n", "<leader><space>", fzf.files, { desc = "Files" })
    vim.keymap.set("n", "<leader>r", fzf.oldfiles, { desc = "Recent Files" })

    vim.keymap.set("n", "gi", function()
      fzf.lsp_definitions({
        regex_filter = function(value)
          return string.match(value.filename, "%.d.ts") == nil
        end,
      })
    end, { desc = "Jump to definition" })

    vim.keymap.set("n", "gre", function()
      fzf.lsp_references({
        regex_filter = function(value)
          return not vim.startswith(value.text, "import")
            and not vim.startswith(string.sub(value.text, value.col - 2, value.col - 1), "</")
            and not vim.startswith(value.text, "export default ")
        end,
      })
    end, { desc = "Show LSP references" })
    vim.keymap.set("n", "gt", fzf.lsp_typedefs, { desc = "Show LSP type definitions" })
  end,
}
