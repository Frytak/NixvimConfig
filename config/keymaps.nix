{ ... }: {
    keymaps = [
        # Copy
        { mode = "n"; key = "<leader>p"; action = "\"+p"; }
        { mode = "n"; key = "<leader>P"; action = "\"+P"; }
        { mode = "v"; key = "<leader>p"; action = "\"+p"; }
        { mode = "v"; key = "<leader>P"; action = "\"+P"; }

        # Paste
        { mode = "n"; key = "<leader>y"; action = "\"+yy"; }
        { mode = "v"; key = "<leader>y"; action = "\"+y"; }

        # Exit Terminal mode
        { mode = "t"; key = "<esc>"; action = "<C-\\><C-n>"; }

        # Tabs
        { mode = "n"; key = "<leader>o"; action = "<cmd>lua print \"chuj\"<enter>"; }
        { mode = "n"; key = "<leader>n"; action = "<cmd>tabnew<enter>"; }
        { mode = "n"; key = "<leader>h"; action = "<cmd>tabprevious<enter>"; }
        { mode = "n"; key = "<leader>l"; action = "<cmd>tabnext<enter>"; }
        { mode = "n"; key = "<leader>H"; action = "<cmd>tabmove -1<enter>"; }
        { mode = "n"; key = "<leader>L"; action = "<cmd>tabmove +1<enter>"; }

        # Windows
        { mode = "n"; key = "<leader>wh"; action = "<C-w><C-h>"; }
        { mode = "n"; key = "<leader>wl"; action = "<C-w><C-l>"; }
        { mode = "n"; key = "<leader>wk"; action = "<C-w><C-k>"; }
        { mode = "n"; key = "<leader>wj"; action = "<C-w><C-j>"; }

        # Telescope navigation
        { mode = "n"; key = "<leader>fb"; action = "<cmd>lua require(\"telescope\").extensions.file_browser.file_browser()<enter>"; }
        { mode = "n"; key = "<leader>ff"; action = "<cmd>lua require(\"telescope.builtin\").find_files()<enter>"; }
        { mode = "n"; key = "<leader>fg"; action = "<cmd>lua require(\"telescope.builtin\").live_grep()<enter>"; }

        # Ranger
        { mode = "n"; key = "<leader>fr"; action = "<cmd>RnvimrToggle<enter>"; }

        # Open diagnostics window
        { mode = "n"; key = "<leader>t"; action = "<cmd>lua vim.diagnostic.open_float()<enter>"; }

        # Go to definition
        { mode = "n"; key = "gd"; action = "<cmd>lua vim.lsp.buf.definition()<enter>"; }

        # Code actions
        { mode = "n"; key = "<F1>"; action = "<cmd>lua vim.lsp.buf.code_action()<enter>"; }

        # Rename
        { mode = "n"; key = "<F2>"; action = "<cmd>lua vim.lsp.buf.rename()<enter>"; }

        # Format
        { mode = "n"; key = "<F3>"; action = "<cmd>lua vim.lsp.buf.format()<enter>"; }
    ];
}
