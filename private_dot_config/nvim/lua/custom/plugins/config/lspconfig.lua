local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

local default_lsp_config = function(on_attach, capabilities)
    local default_config = {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
            debounce_text_changes = 150,
        },
    }
    return default_config
end

-- local setup_func = function(completion_engine, config_table)
--     if completion_engine == "coq" then
--         local coq = require("coq")
--         return coq.lsp_ensure_capabilities(config_table)
--     else
--         return config_table
--     end
-- end

local default_config = default_lsp_config(on_attach, capabilities)
-- local servers = { "html", "cssls", "jsonls", "rust_analyzer", "graphql", "tsserver" }
local servers = require("mason-lspconfig").get_installed_servers()

local custom_lsp_config = {
    ["jsonls"] = function(on_attach, capabilities)
        local schemas = require("schemastore").json.schemas()
        return {
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                json = {
                    schemas = schemas,
                },
            },
            filetypes = {
                "json",
                "jsonc"
            }
        }
    end,
    ["rust_analyzer"] = function(on_attach, capabilities)
        local rt = require("rust-tools")
        rt.setup {
            -- server = {
            --     -- on_attach is a callback called when the language server attachs to the buffer
            --     on_attach = on_attach,
            --     -- on_attach = function(_, bufnr)
            --     --     -- Hover actions
            --     --     vim.keymap.set("n", "<leader>rr", rt.runnables.runnables, { buffer = bufnr })
            --     --     -- Code action groups
            --     --     -- vim.keymap.set("n", "<leader>rr", rt.code_action_group.code_action_group, { buffer = bufnr })
            --     -- end,
            --     -- capabilities = capabilities,
            --     -- standalone = false,
            --     settings = {
            --         -- to enable rust-analyzer settings visit:
            --         -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            --         ["rust-analyzer"] = {
            --             lens = {
            --                 enable = true,
            --             },
            --             -- enable clippy on save
            --             checkonsave = {
            --                 command = "clippy",
            --             },
            --         },
            --     },
            -- },
            tools = {
                runnables = {
                    use_telescope = true,
                },
                autosethints = true,
                hover_actions = { auto_focus = true },
                inlay_hints = {
                    auto = true,
                    show_parameter_hints = true,
                    -- parameter_hints_prefix = "",
                    -- other_hints_prefix = "",
                },
            }
        }

        return {
            -- capabilities = capabilities,
            -- on_attach = on_attach,
        }
    end,
    ["graphql"] = function(on_attach, capabilities)
        return {
            on_attach = on_attach,
            capabilities = capabilities,
            filetypes = {
                "graphql",
                "typescriptreact",
                "javascriptreact",
                "typescript",
                "javascript"
            }
        }
    end,
}

local rt = require("rust-tools")
rt.setup {
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        on_attach = on_attach,
        capabilities = capabilities,
        -- settings = {
        --     -- to enable rust-analyzer settings visit:
        --     -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
        --     ["rust-analyzer"] = {
        --         cargo = {
        --             autoReload = true
        --         },
        --         lens = {
        --             enable = true,
        --         },
        --         -- enable clippy on save
        --         checkOnSave = {
        --             command = "clippy",
        --         },
        --     },
        -- },
    },
    tools = {
        executor = require("rust-tools.executors").termopen,
        runnables = {
            use_telescope = true,
        },
    }
}

for _, lsp in ipairs(servers) do
    if lsp == "lua_ls" or lsp == "rust_analyzer" then
        goto skip_to_next
    end
    local custom_config = custom_lsp_config[lsp];
    if custom_config then
        local config_table = custom_config(on_attach, capabilities)
        -- config_table.on_attach = on_attach
        -- config_table.capabilities = capabilities
        lspconfig[lsp].setup(config_table)
    else
        lspconfig[lsp].setup(default_config)
    end
    ::skip_to_next::
end

-- for _, lsp in ipairs(servers) do
--     lspconfig[lsp].setup {
--         on_attach = on_attach,
--         capabilities = capabilities,
--     }
-- end
