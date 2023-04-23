return {
    -- https://github.com/rmagatti/auto-session
    ["rmagatti/auto-session"] = {
        config = function()
            require("auto-session").setup {
                log_level = "error",
                auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
                pre_save_cmds = { function()
                    local nvim_tree_api = require('nvim-tree.api')
                    nvim_tree_api.tree.close()
                end }
            }
        end
    },
    ["folke/which-key.nvim"] = {
        opt = false,
        disable = false,
        keys = nil,
        module = { "nvim-neoclip.lua", "aerial.nvim", "undotree" },
    },
    -- ["rmagatti/session-lens"] = {
    --     -- keys = "<leader>s",
    --     -- cmd = "SearchSession",
    --     after = "telescope.nvim",
    --     requires = { 'rmagatti/auto-session', 'nvim-telescope/telescope.nvim' },
    --     config = function()
    --         local ok, session_lens = pcall(require, 'session-lens')
    --         if ok then
    --             session_lens.setup({ --[[your custom config--]] })
    --             -- require("telescope").load_extension("session-lens")
    --         end
    --     end
    -- },
    ["nvim-treesitter/nvim-treesitter"] = {
        override_options = {
            ensure_installed = 'all',
            indent = { enable = true },
            highlight = {
                enable = true,
                disable = function(lang, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
            },
            autopairs = { enable = true },
            context_commentstring = {
                enable = true,
                config = {
                    javascriptreact = { style_element = "{/*%s*/}" },
                    typescriptreact = { style_element = "{/*%s*/}" },
                },
            },
            autotag = {
                enable = true,
                filetypes = {
                    'html', 'javascript', 'typescript', 'javascriptreact',
                    'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx', 'rescript',
                    'xml', 'php', 'markdown',
                    'glimmer', 'handlebars', 'hbs', "astro",
                },
            },
            matchup = { enable = false },
        },
        requires = {
            'JoosepAlviste/nvim-ts-context-commentstring',
            'windwp/nvim-ts-autotag',
            {
                'nvim-treesitter/nvim-treesitter-context',
                config = function()
                    require('treesitter-context').setup()
                end,
            }
        }
    },
    ["numToStr/Comment.nvim"] = {
        override_options = {
            pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        }
    },
    ["NvChad/nvterm"] = {
        override_options = {
            terminals = {
                list = {},
                type_opts = {
                    float = {
                        relative = "editor",
                        row = 0.05,
                        col = 0.05,
                        width = 0.9,
                        height = 0.9,
                        border = "single",
                    },
                    horizontal = { location = "rightbelow", split_ratio = 0.3 },
                    vertical = { location = "rightbelow", split_ratio = 0.5 },
                },
            },
        }
    },
    ["b0o/schemastore.nvim"] = {},
    ["simrat39/rust-tools.nvim"] = {},
    -- https://github.com/Saecki/crates.nvim
    ["saecki/crates.nvim"] = {
        event = { "BufRead Cargo.toml" },
        requires = { { 'nvim-lua/plenary.nvim' } },
        config = function()
            require('crates').setup({
                null_ls = {
                    enabled = true,
                    name = "crates.nvim",
                },
            })
        end,
    },
    -- https://github.com/williamboman/mason.nvim
    ["williamboman/mason.nvim"] = {
        override_options = {
            ui = {
                icons = {
                    package_installed = "",
                    package_pending = "",
                    package_uninstalled = "",
                },
            },
            ensure_installed = {}
        },
    },
    -- https://github.com/williamboman/mason-lspconfig.nvim
    ["williamboman/mason-lspconfig.nvim"] = {
        module = { "mason.nvim" },
        config = function()
            require("mason-lspconfig").setup {
                automatic_installation = true,
                ensure_installed = {
                    -- web dev
                    "css-lsp",
                    "html-lsp",
                    "typescript-language-server",
                    "json-lsp",
                    "astro-language-server",
                    "codelldb",
                    "eslint-lsp",
                    "prettier",
                    "prisma-language-server",
                    "rust-analyzer",
                    "tailwindcss-language-server",
                    "taplo",
                    "yaml-language-server",
                    "graphql-language-service-cli",


                    -- shell
                    "shfmt",
                    "shellcheck",
                }
            }
        end
    },
    ["neovim/nvim-lspconfig"] = {
        after = "mason-lspconfig.nvim",
        config = function()
            require "plugins.configs.lspconfig"
            require "custom.plugins.config.lspconfig"
        end,
    },
    ["jose-elias-alvarez/null-ls.nvim"] = {
        after = "nvim-lspconfig",
        config = function()
            require "custom.plugins.config.null-ls"
        end,
    },
    ["max397574/better-escape.nvim"] = {
        event = "InsertEnter",
        config = function()
            require("better_escape").setup()
        end,
    },
    ["nvim-tree/nvim-tree.lua"] = {
        override_options = {
            git = {
                enable = true,
            },
            diagnostics = {
                enable = true,
                show_on_dirs = false,
            },
            renderer = {
                indent_markers = {
                    enable = true,
                },
                highlight_git = true,
                icons = {
                    git_placement = "after",
                    show = {
                        git = true,
                    },
                },
            },
        }
    },
    ["hrsh7th/cmp-nvim-lsp-document-symbol"] = { after = "cmp-path" },
    ["hrsh7th/cmp-cmdline"] = { after = "cmp-nvim-lsp-document-symbol" },
    ["hrsh7th/nvim-cmp"] = {
        override_options = {
            sources = {
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer" },
                { name = "nvim_lua" },
                { name = "path" },
                { name = "crates" },
            },
        },
        formatting = {
            format = function(_, vim_item)
                local icons = require("nvchad_ui.icons").lspkind
                vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)
                vim_item.abbr = string.sub(vim_item.abbr, 1, 80)
                return vim_item
            end,
        },
        config = function()
            require "plugins.configs.cmp"
            local cmp = require 'cmp'

            local search_sources = cmp.config.sources({
                    { name = 'nvim_lsp_document_symbol' },
                }, {
                    { name = 'buffer' },
                })
            cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = search_sources
            })
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    {
                        name = 'cmdline',
                        option = {
                            ignore_cmds = { 'Man', '!' }
                        }
                    }
                })
            })
        end,
    },
    ["nvim-telescope/telescope.nvim"] = {
        event = "VimEnter",
        module = { "nvim-neoclip.lua", "aerial.nvim" },
        override_options = {
            defaults = {
                history = {
                    path = vim.fn.stdpath 'data' .. '/telescope_history.sqlite3',
                },
            },
            pickers = {
                lsp_code_actions = {
                    theme = 'cursor',
                },
                live_grep = {
                    file_ignore_patterns = { '.git/', 'node_modules/', 'package-lock.json' },
                },
            }
        },
        requires = {
            {
                'nvim-telescope/telescope-frecency.nvim',
                after = "telescope.nvim",
                config = function()
                    require('telescope').load_extension('frecency')
                end,
                requires = { "kkharji/sqlite.lua" }
            },
        }
    },
    -- https://github.com/edluffy/specs.nvim
    -- Show where your cursor moves when jumping large distances
    -- (e.g between windows). Fast and lightweight, written completely in Lua.
    ["edluffy/specs.nvim"] = {
        opt = true,
        setup = function()
            require("core.lazy_load").on_file_open("specs.nvim")
        end,
        config = function()
            local specs = require('specs')
            specs.setup {
                show_jumps = true,
                min_jump   = 10,
                popup      = {
                    delay_ms = 25,
                    inc_ms = 10,
                    blend = 10,
                    width = 50,
                    resizer = specs.slide_resizer,
                },
            }
        end,
    },
    --https://github.com/mg979/vim-visual-multi
    ["mg979/vim-visual-multi"] = {
        opt = true,
        setup = function()
            require("core.lazy_load").on_file_open("vim-visual-multi")

            vim.g.VM_default_mappings = 0
            -- vim.g.VM_highlight_matches = 'red'
            -- vim.g.VM_theme = 'codedark'
            vim.g.VM_maps = {
                ['Find Under'] = '<C-x>',
                ['Find Subword Under'] = '<C-x>',
                ['Select Cursor Down'] = '<C-Down>',
                ['Select Cursor Up'] = '<C-Up>',
            }
        end,
    },
    ["mbbill/undotree"] = {
        {
            cmd = 'UndotreeToggle',
            -- keys = '<leader>ut',
            setup = function()
                vim.g.undotree_TreeNodeShape = '◉'
                vim.g.undotree_SetFocusWhenToggle = 1
            end,
            -- config = function()

            -- end,
        }
    },
    -- https://github.com/AckslD/nvim-neoclip.lua
    ["AckslD/nvim-neoclip.lua"] = {
        keys = { "<localleader>p" },
        config = function()
            require('neoclip').setup {
                enable_persistent_history = true,
                keys = {
                    telescope = {
                        i = { select = '<c-p>', paste = '<CR>', paste_behind = '<c-k>' },
                        n = { select = 'p', paste = '<CR>', paste_behind = 'P' },
                    },
                },
            }
            local function clip()
                require('telescope').extensions.neoclip.default(
                    require('telescope.themes').get_dropdown()
                )
            end

            require('which-key').register {
                ['<localleader>p'] = { clip, 'neoclip: open yank history' },
            }
        end,
    },
    -- https://github.com/stevearc/aerial.nvim
    ["stevearc/aerial.nvim"] = {
        keys = { "<leader>a" },
        config = function()
            require('aerial').setup {
                -- backends = { "treesitter", "lsp", "markdown" },
                layout = {
                    width = 40,
                    default_direction = "prefer_right",
                    placement = "window",
                },
            }
            require('which-key').register {
                ['<leader>a'] = { "<Cmd>AerialToggle<CR>", 'Toggle Aerial' }
            }
        end
    },
    ["https://gitlab.com/yorickpeterse/nvim-pqf"] = {
        config = function()
            require('pqf').setup {}
        end,
    },
    ["kevinhwang91/nvim-bqf"] = {
        ft = 'qf',
    },
    ["ActivityWatch/aw-watcher-vim"] = {},
    ["renerocksai/telekasten.nvim"] = {
        requires = "renerocksai/calendar-vim",
        keys = { "<leader>ca", "<leader>o" },
        config = function()
            require "custom.plugins.config.telekasten"
        end
    },
    ["iamcco/markdown-preview.nvim"] = {
        ft = { 'markdown' },
        run = function()
            vim.fn['mkdp#util#install']()
        end,
        config = function()
            vim.g.mkdp_auto_start = 0
            vim.g.mkdp_auto_close = 1
            require('which-key').register {
                ['<localleader>m'] = { '<cmd>MarkdownPreviewToggle<CR>', 'markdown-preview: toggle' },
            }
        end,
    },
    ["tpope/vim-sleuth"] = {},
    ["tpope/vim-repeat"] = {},
    ["tpope/vim-surround"] = {},
    ["tpope/vim-fugitive"] = {},
    ["andymass/vim-matchup"] = {
        setup = function()
            vim.g.matchup_matchparen_offscreen = { method = "popup" }
        end,
    },
    -- https://github.com/wellle/targets.vim
    -- adds various text objects to give you more targets to operate on
    ["wellle/targets.vim"] = {},
    ["phaazon/hop.nvim"] = {
        keys = { { 'n', 's' }, 'f', 'F', 't', 'T' },
        config = function()
            local hop = require 'hop'
            -- remove h,j,k,l from hops list of keys
            hop.setup {
                keys = 'etovxqpdygfbzcisuran',
            }
            -- NOTE: override F/f using hop motions
            vim.api.nvim_set_keymap('n', 'f', "<cmd>lua require'hop'.hint_words()<cr>", {})
            vim.api.nvim_set_keymap('n', 'F', "<cmd>lua require'hop'.hint_lines()<cr>", {})
            vim.api.nvim_set_keymap('o', 'f', "<cmd>lua require'hop'.hint_words()<cr>", {})
            vim.api.nvim_set_keymap('o', 'F', "<cmd>lua require'hop'.hint_lines()<cr>", {})
            vim.api.nvim_set_keymap('', 't', "<cmd>lua require'hop'.hint_char1()<cr>", {})
            vim.api.nvim_set_keymap('', 'T', "<cmd>lua require'hop'.hint_char1({ current_line_only = true })<cr>", {})
        end,
    },
    ["https://gitlab.com/yorickpeterse/nvim-window.git"] = {
        keys = "<c-w>w",
        config = function()
            require('which-key').register {
                ['<c-w>w'] = {
                    function()
                        require('nvim-window').pick()
                    end,
                    'pick & switch window',
                },
            }
        end,
    },
    -- https://github.com/stevearc/dressing.nvim
    ["stevearc/dressing.nvim"] = {
        after = 'telescope.nvim',
        config = function()
            require('dressing').setup {
                -- input = {
                --   insert_only = false,
                -- winblend = 100,
                --   -- border = as.style.current.border,
                -- },
                select = {
                    telescope = require('telescope.themes').get_cursor {
                        layout_config = {
                            height = function(self, _, max_lines)
                                local results = #self.finder.results
                                local PADDING = 4 -- this represents the size of the telescope window
                                local LIMIT = math.floor(max_lines / 2)
                                return (results <= (LIMIT - PADDING) and results + PADDING or LIMIT)
                            end,
                        },
                    },
                },
            }
        end,
    },
    -- https://github.com/Exafunction/codeium.vim
    ["Exafunction/codeium.vim"] = {
        config = function()
            -- Change '<C-g>' here to any keycode you like.
            vim.keymap.set('i', '<C-h>', function()
                return vim.fn['codeium#Accept']()
            end, { expr = true })
        end
    }
}
