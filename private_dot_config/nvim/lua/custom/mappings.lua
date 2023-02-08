-- local function format(client)
--     vim.api.nvim_echo({ { ("Formatting with %s…"):format(client.name) } }, false, {})
--     vim.lsp.buf.format { id = client.id, async = true }
-- end

-- local function format_current_buffer()
--     local current_bufnr = vim.api.nvim_get_current_buf()
--     local candidates = vim.tbl_filter(function(client)
--         return client.name ~= "tsserver" and client.name ~= "stylelint_lsp" and
--             client.supports_method "textDocument/formatting" and client.attached_buffers[current_bufnr] == true
--     end, vim.lsp.get_active_clients({ bufnr = current_bufnr }))
--     if #candidates > 1 then
--         vim.ui.select(candidates, {
--             prompt = "Select Client",
--             format_item = function(client)
--                 return client.name
--             end,
--         }, function(client)
--             if client then
--                 format(client)
--             end
--         end)
--     elseif #candidates == 1 then
--         format(candidates[1])
--     else
--         vim.api.nvim_echo(
--             { { "No clients that support textDocument/formatting are attached.", "WarningMsg" } },
--             false,
--             {}
--         )
--     end
-- end

local M = {
    ["disabled"] = {
        n = {
            ["<C-c>"] = ""
        }
    },
    -- ["session-lens"] = {
    --     n = {
    --         ["<leader>s"] = { "<cmd> SearchSession <CR>", "switch session" }
    --     }
    -- },
    ["undotree"] = {
        n = {
            ['<localleader>u'] = { '<cmd>UndotreeToggle<CR>', 'undotree: toggle' },
        }
    },
    ["packer"] = {
        n = {
            ['<leader>ps'] = { '<cmd>PackerSync<CR>', 'packer: sync' },
        }
    },
    ["term"] = {
        n = {
            ['<A-g>'] = { function() require("nvterm.terminal").send("gitui", "float") end, 'toggle gitui', },
            ['<A-c>'] = { function() require("nvterm.terminal").send("npm run commit", "float") end, 'npm run commit', },
        }
    },
    ["lsp"] = {
        n = {
            ["<localleader>r"] = {
                function()
                    require("nvchad_ui.renamer").open()
                end,
                "lsp rename",
            },
            ["<localleader>a"] = {
                function()
                    vim.lsp.buf.code_action()
                end,
                "lsp code_action",
            },
            ["<localleader>d"] = {
                function()
                    vim.diagnostic.open_float(nil, {
                        focusable = true,
                        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                        border = 'rounded',
                        source = 'if_many',
                        prefix = ' ',
                        scope = 'line',
                    })
                end,
                "floating diagnostic",
            },
            ["<localleader>f"] = {
                function()
                    vim.lsp.buf.format { async = true }
                    -- format_current_buffer()
                end,
                "lsp formatting",
            },
            ["K"] = {
                function()
                    if vim.bo.filetype == 'rust' then
                        require("rust-tools").hover_actions.hover_actions()
                    else
                        vim.lsp.buf.hover()
                    end
                end,
                "lsp hover",
            },
            ["<leader>rr"] = { '<cmd>RustRunnables<CR>', 'rust runnables' },
            ["<A-j>"] = { '<cmd>RustMoveItemDown<CR>', 'rust move down' },
            ["<A-k>"] = { '<cmd>RustMoveItemUp<CR>', 'rust move up' },
        },
        v = {
            ["<localleader>a"] = {
                function()
                    vim.lsp.buf.code_action()
                end,
                "lsp code_action",
            },
        }
    },
    ["telescope"] = {
        n = {
            -- find
            ["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "find files" },
            ["<leader>fs"] = { "<cmd> Telescope live_grep <CR>", "live grep" },
            ["<leader>fr"] = { "<cmd> Telescope resume <CR>", "resume last picker" },
            ["<leader>fb"] = { "<cmd> Telescope buffers <CR>", "find buffers" },
            ["<leader>fh"] = { "<cmd> Telescope help_tags <CR>", "help page" },
            ["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "find oldfiles" },
            ["<leader>tk"] = { "<cmd> Telescope keymaps <CR>", "show keys" },

            -- git
            ["<leader>cm"] = { "<cmd> Telescope git_commits <CR>", "git commits" },
            ["<leader>gt"] = { "<cmd> Telescope git_status <CR>", "git status" },

            -- pick a hidden term
            ["<leader>pt"] = { "<cmd> Telescope terms <CR>", "pick hidden term" },

            -- theme switcher
            ["<leader>th"] = { "<cmd> Telescope themes <CR>", "nvchad themes" },
        },
    }
}

return M;

-- require('which-key').register {
--     ['<localleader>u'] = { '<cmd>UndotreeToggle<CR>', 'undotree: toggle' },
-- }

-- local present, wk = pcall(require, "which-key")

-- if not present then
--     return
-- end

-- wk.register {
--     ['<leader>s'] = { "<Cmd>SearchSession<CR>", 'switch session' }
-- }
