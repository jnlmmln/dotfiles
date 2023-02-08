local autocmd = vim.api.nvim_create_autocmd

print("ASDASDASDASD")

vim.g.mapleader = "," -- Remap leader key
vim.g.maplocalleader = " " -- Local leader is <Space>
-- vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Prevents to move nvim into background
vim.keymap.set('n', '<C-z>', "<nop>")
-- Maps Shift + Tab so that it removes tabs in insert mode
vim.keymap.set('i', '<S-TAB>', "<C-d>")
-- disable space in normal mode as is used as localleader
vim.keymap.set('n', '<Space>', "<nop>")
-- Show diagnostic popup on cursor hover
-- local diag_float_grp = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })
-- vim.api.nvim_create_autocmd("CursorHold", {
--     callback = function()
--         vim.diagnostic.open_float(nil, {
--             focusable = false,
--             border = 'rounded',
--             source = 'if_many',
--             prefix = ' ',
--             scope = 'line',
--         })
--     end,
--     group = diag_float_grp,
-- })

-- Title
vim.opt.titlestring = ' %f %r %m'
vim.opt.title = true
vim.opt.titlelen = 120
autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = { '*' },
    callback = function()
        local title = vim.fn.expand('%:t')
        if title ~= '' and title ~= 'NvimTree_1' then
            vim.opt.titlestring = GetFileIconForBuffer() ..
                ' ' .. title .. ' (' .. vim.fn.expand('%:h') .. ')%( %r%)%( %m%) | nvim'
        end
    end,
})

-- Utilities
function GetFileIconForBuffer()
    local icon
    local ok, devicons = pcall(require, 'nvim-web-devicons')
    if ok then
        local f_name, f_extension = vim.fn.expand('%:t'), vim.fn.expand('%:e')
        f_extension = f_extension ~= '' and f_extension or vim.bo.filetype
        icon = devicons.get_icon(f_name, f_extension)
        if icon then
            return icon
        end
    end

    return ""
end
