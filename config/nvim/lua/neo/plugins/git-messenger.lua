return {
  "f-person/git-blame.nvim",
  config = function()
    local git_blame = require("gitblame")

    git_blame.setup({ display_virtual_text = false, message_template = "<sha>" })

    vim.keymap.set("n", "<leader>go", "<cmd>GitBlameOpenCommitURL<cr>", { desc = "Open commit URL" })
    vim.keymap.set("x", "<leader>gyf", ":GitBlameCopyFileURL<cr>", { desc = "Copy file URL" })
    vim.keymap.set("n", "<leader>gyc", function()
      vim.fn.setreg("+", git_blame.get_current_blame_text())
    end, { desc = "Copy blame commit" })
    vim.keymap.set("n", "<leader>gj", function()
      vim.cmd("!git checkout " .. git_blame.get_current_blame_text() .. "~1")
    end, { desc = "Checkout blame commit" })

    vim.keymap.set("n", "<leader>D", function()
      vim.cmd("DiffviewOpen " .. git_blame.get_current_blame_text() .. "^!")
    end, { desc = "Diff blame commit" })
  end,
}
