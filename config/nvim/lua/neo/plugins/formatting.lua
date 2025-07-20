return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescriptreact = { "prettierd" },
        css = { "prettierd" },
        scss = { "prettierd" },
        html = { "prettierd" },
        json = { "prettierd" },
        jsonc = { "prettierd" },
        yaml = { "prettierd" },
        markdown = { "prettierd" },
        lua = { "stylua" },
        nix = { "alejandra" },
        toml = { "taplo" },
      },
      format_on_save = function()
        if vim.g.disable_autoformat then
          return
        end
        return { timeout_ms = 1500 }
      end,
    })

    vim.keymap.set("n", "<leader>h", function()
      vim.g.disable_autoformat = not vim.g.disable_autoformat
    end, { desc = "Toggle autoformatting" })

    vim.keymap.set({ "n", "v" }, "<leader>f", conform.format, { desc = "Format file or range (in visual mode)" })
  end,
}
