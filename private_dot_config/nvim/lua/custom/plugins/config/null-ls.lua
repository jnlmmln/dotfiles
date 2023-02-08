local present, null_ls = pcall(require, "null-ls")

if not present then
    return
end

local b = null_ls.builtins

local sources = {
    -- rust
    b.formatting.rustfmt,

    -- toml
    b.formatting.taplo,

    -- webdev stuff
    b.formatting.prettier.with {
        filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
            "css",
            "scss",
            "less",
            "html",
            "yaml",
            "markdown",
            "graphql",
            "handlebars",
            "svelte",
            "astro",
            "json",
            "jsonc",
            "markdown.mdx",
        },
        condition = function()
            return vim.fn.executable('prettier') > 0
        end,
    },

    -- Lua
    b.formatting.stylua,

    -- Shell
    b.formatting.shfmt,
}

null_ls.setup {
    debug = false,
    sources = sources,
}
