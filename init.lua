-- General Settings
vim.opt.filetype = 'colortemplate'
vim.opt.showmatch = true
vim.opt.fileencoding = 'utf-8'                 -- The encoding written to a file
vim.opt.compatible = false                      -- Disable compatibility mode with `vi`, allowing Neovim to use its full set of features
vim.opt.termguicolors = true                    -- Set terminal GUI colors (most terminals support this)
vim.opt.clipboard = 'unnamedplus'               -- Use the system clipboard
vim.opt.swapfile = false                        -- Do not create a swapfile
vim.opt.backup = false                          -- Do not create a backup file
vim.opt.writebackup = false                     -- Do not allow editing if the file is being edited by another program
vim.opt.hidden = false                          -- Do not allow hidden buffers (need to save current file first to open another)
vim.opt.mouse = 'a'                             -- Allow the mouse to be used in Neovim
vim.opt.cmdheight = 1                           -- More space in the command line for displaying messages
vim.opt.conceallevel = 0                        -- Show '' in markdown files
vim.opt.laststatus = 2                          -- Always show the status line
vim.opt.showmode = true                         -- Show modes like -- INSERT --
vim.opt.showcmd = true                          -- Show command input
vim.opt.undofile = true                         -- Enable persistent undo
vim.opt.undodir = '~/.vim/undo'
vim.opt.updatetime = 100                        -- Faster completion (default 4000ms)
vim.opt.timeoutlen = 1000                       -- Time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.splitbelow = true                       -- Force all horizontal splits to go below the current window
vim.opt.splitright = true                       -- Force all vertical splits to go to the right of the current window
vim.opt.ruler = true                            -- Show the ruler
vim.opt.showtabline = 1                         -- Always show tabs

vim.opt.scrolloff = 8                           -- Number of lines to keep above and below the cursor
vim.opt.sidescrolloff = 8                       -- Number of columns to keep to the left and right of the cursor

vim.opt.wrap = false                            -- Display lines as one long line
vim.opt.signcolumn = 'yes'                      -- Always show the sign column
vim.opt.cursorline = true                       -- Highlight the current line
vim.opt.relativenumber = true                   -- Show relative line numbers
vim.opt.number = true                           -- Show line numbers
vim.opt.numberwidth = 4                         -- Set number column width to 4
vim.opt.modeline = true                         -- Enable modeline
vim.opt.iminsert = 0                            -- Input method insert mode
vim.opt.imsearch = 0                            -- Input method search mode
vim.opt.incsearch = true                        -- Show search matches as you type
vim.opt.hlsearch = true                         -- Highlight all matches on the previous search pattern
vim.opt.smartcase = true                        -- Smart case searching
vim.opt.ignorecase = true                       -- Ignore case in search patterns
vim.opt.guifont = 'Iosevka:h20'                 -- Font for GUI interface and terminal
vim.opt.title = false                           -- Do not set the terminal title
-- vim.opt.noequalalways = true
vim.opt.winfixheight = true
vim.opt.winfixwidth = true
vim.opt.guitablabel = '%t'
-- vim.opt.termwinsize = '10x200'

vim.opt.background = 'dark'
vim.cmd('colorscheme quiet')

-- Map Shift-Tab to go to the previous tab
vim.api.nvim_set_keymap('n', '<C-S-Tab>', ':tabprevious<CR>', { noremap = true, silent = true })

-- Map Tab to go to the next tab
vim.api.nvim_set_keymap('n', '<C-Tab>', ':tabnext<CR>', { noremap = true, silent = true })

-- --------- Languages Configuration ---------

-- Format and save function
function FormatAndSave()
    local filetype = vim.bo.filetype
    if filetype == 'c' or filetype == 'cpp' or filetype == 'h' or filetype == 'cc' or filetype == 'hpp' then
        vim.cmd('%!clang-format-18 -style=file')
    end
end

-- Map Ctrl-s to call FormatAndSave and then save the file
vim.api.nvim_set_keymap('n', '<C-s>', ':lua FormatAndSave()<CR>:w<CR>', { noremap = true, silent = true })
-- Map C-a to call Explore
vim.api.nvim_set_keymap('n', '<C-a>', ':Explore<CR>', { noremap = true, silent = true })
-- Set tabstop, shiftwidth, and other indentation settings
-- vim.opt.tabstop = 8
-- vim.opt.shiftwidth = 8
-- vim.opt.noexpandtab = true
-- vim.opt.smartindent = true
-- vim.opt.autoindent = true
vim.cmd [[
	set autoindent
	set expandtab
	set shiftwidth=8
	set smartindent
	set softtabstop=8
	set tabstop=8
	]]
-- Filetype specific settings for C/C++
vim.api.nvim_create_autocmd('FileType', {
    pattern = {'c', 'cpp', 'h', 'cc', 'hpp'},
    callback = function()
	vim.cmd [[
		set autoindent
		set expandtab
		set shiftwidth=8
		set smartindent
		set softtabstop=8
		set tabstop=8
	]]
        -- vim.opt_local.tabstop = 8
        -- vim.opt_local.shiftwidth = 8
        -- vim.opt_local.softtabstop = 8
        -- vim.opt_local.noexpandtab = true
        -- vim.opt_local.smartindent = true
        -- vim.opt_local.autoindent = true
    end
})

