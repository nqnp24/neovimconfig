-- ============================ --
--      GENERAL SETTINGS        --
-- ============================ --

-- Filetype settings and compatibility
vim.opt.compatible = false                    -- Disable compatibility with `vi` for full Neovim features
vim.opt.termguicolors = true                  -- Enable true color support in the terminal
vim.opt.clipboard = 'unnamedplus'             -- Use system clipboard for copy-paste operations

-- Backup and swapfile settings
vim.opt.swapfile = false                      -- Disable swapfile creation
vim.opt.backup = false                        -- Disable backup file creation
vim.opt.writebackup = false                   -- Prevent editing files if already opened by another program

-- Buffer and window settings
vim.opt.hidden = false                        -- Do not allow hidden buffers; must save current file to switch
vim.opt.mouse = 'a'                           -- Enable mouse support in all modes
vim.opt.cmdheight = 2                         -- Use one line for the command-line area
vim.opt.laststatus = 2                        -- Always show the status line
vim.opt.showmode = true                       -- Show mode (e.g., INSERT, NORMAL)
vim.opt.showcmd = true                        -- Show command input in the command line
vim.opt.undofile = true                       -- Enable persistent undo across sessions
-- vim.opt.undodir = '~/.vim/undo'               -- Directory for undo history
vim.opt.updatetime = 100                      -- Set faster completion and background operations
vim.opt.timeoutlen = 1000                     -- Timeout for key sequence completion in milliseconds

-- Window behavior and cursor settings
vim.opt.splitbelow = true                     -- Open horizontal splits below the current window
vim.opt.splitright = true                     -- Open vertical splits to the right
vim.opt.cursorline = true                     -- Highlight the current line
vim.opt.relativenumber = true                 -- Show relative line numbers
vim.opt.number = true                         -- Display absolute line numbers
vim.opt.signcolumn = 'yes'                    -- Always display the sign column
vim.opt.wrap = false                          -- Disable line wrapping (long lines will overflow)
vim.opt.scrolloff = 10                        -- Keep 8 lines visible above and below the cursor
vim.opt.sidescrolloff = 10                    -- Keep 8 columns visible to the left and right of the cursor
vim.opt.winfixheight = true                   -- Prevent window height from changing
vim.opt.winfixwidth = true                    -- Prevent window width from changing

-- Font and title settings
-- vim.opt.guifont = 'Iosevka:h20'               -- Set font for GUI (use appropriate font)
-- vim.opt.title = false                         -- Do not set the terminal title
-- vim.opt.guitablabel = '%t'                    -- Show only file name in tab label

-- ============================ --
--      KEY MAPPINGS             --
-- ============================ --

-- Map Shift-Tab to go to the previous tab
vim.api.nvim_set_keymap('n', '<C-S-Tab>', ':tabprevious<CR>', { noremap = true, silent = true })

-- Map Tab to go to the next tab
vim.api.nvim_set_keymap('n', '<C-Tab>', ':tabnext<CR>', { noremap = true, silent = true })

-- =================================== --
--     LANGUAGES AND FORMATTING       --
-- =================================== --

-- Function to format and save C/C++ files
function FormatAndSave()
    local filetype = vim.bo.filetype
    if filetype == 'c' or filetype == 'cpp' or filetype == 'h' or filetype == 'cc' or filetype == 'hpp' then
        vim.cmd('%!clang-format-19 -style=file') -- Apply clang-format to C/C++ files
    end
end

-- Rust
vim.g.rustfmt_autosave = 1
vim.g.rustfmt_command = 'rustfmt'

-- Map Ctrl-s to format and save the current file
vim.api.nvim_set_keymap('n', '<C-s>', ':lua FormatAndSave()<CR>:w<CR>', { noremap = true, silent = true })

-- Indentation settings for various filetypes
vim.cmd [[
    set autoindent
    set expandtab
    set shiftwidth=4
    set softtabstop=4
    set tabstop=4
    set smartindent
]]

-- Filetype-specific settings for C/C++
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'c', 'cpp', 'h', 'cc', 'hpp' },
    callback = function()
        vim.cmd [[
            set autoindent
            set expandtab
            set shiftwidth=8
            set smartindent
            set softtabstop=8
            set tabstop=8
        ]]
    end
})

-- ============================ --
--         NETRW SETTINGS         --
-- ============================ --

-- NETRW settings for file explorer
vim.g.netrw_winsize = 30       -- Set the width of the netrw window
vim.g.netrw_banner = 0         -- Hide the banner in netrw
vim.g.netrw_liststyle = 1      -- Use a tree-like view in netrw

-- Netrw key mappings
local function netrw_mapping()
    local bufmap = function(lhs, rhs)
        local opts = { buffer = true, remap = true, silent = true }
        vim.keymap.set('n', lhs, rhs, opts)
    end

    -- Better navigation within netrw
    bufmap('H', 'u')             -- Go up one directory
    bufmap('h', '-^')            -- Navigate to parent directory
    bufmap('l', '<CR>')          -- Open file or directory
    --  bufmap('<Leader>aa', '<C-6>') -- Jump between file buffers
    bufmap('.', 'gh')            -- Toggle visibility of dotfiles
end

-- Autocommand for netrw filetype
local user_cmds = vim.api.nvim_create_augroup('user_cmds', { clear = true })
vim.api.nvim_create_autocmd('filetype', {
    pattern = 'netrw',
    group = user_cmds,
    callback = netrw_mapping
})

-- ============================ --
--      PLUGIN MANAGEMENT        --
-- ============================ --

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
-- Setup lazy.nvim with plugins
require("lazy").setup({
    spec = {
        "rust-lang/rust.vim",
        "nvim-treesitter/nvim-treesitter",
        "shortcuts/no-neck-pain.nvim",
        {
            "blazkowolf/gruber-darker.nvim",
            opts = {
                bold = true,
                italic = {
                    strings = false,
                },
            },
        },
        {
            "folke/zen-mode.nvim",
            opts = {
                window = {
                    backdrop = 1.00, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
                    -- height and width can be:
                    -- * an absolute number of cells when > 1
                    -- * a percentage of the width / height of the editor when <= 1
                    -- * a function that returns the width or the height
                    width = 120, -- width of the Zen window
                    height = 1, -- height of the Zen window
                    -- by default, no options are changed for the Zen window
                    -- uncomment any of the options below, or add other vim.wo options you want to apply
                    options = {
                        signcolumn = "yes", -- enable signcolumn
                        number = true, -- enable number column
                        relativenumber = true, -- enable relative numbers
                        cursorline = true, -- enable cursorline
                        cursorcolumn = false, -- disable cursor column
                        foldcolumn = "0", -- disable fold column
                        list = false, -- disable whitespace characters
                    },
                },
                plugins = {
                    -- disable some global vim options (vim.o...)
                    -- comment the lines to not apply the options
                    options = {
                        enabled = true,
                        ruler = true, -- disables the ruler text in the cmd line area
                        showcmd = false, -- disables the command in the last line of the screen
                        -- you may turn on/off statusline in zen mode by setting 'laststatus'
                        -- statusline will be shown only if 'laststatus' == 3
                        laststatus = 0, -- turn off the statusline in zen mode
                    },
                    twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
                    gitsigns = { enabled = false }, -- disables git signs
                    tmux = { enabled = false }, -- disables the tmux statusline
                    todo = { enabled = false }, -- if set to "true", todo-comments.nvim highlights will be disabled
                    -- this will change the font size on kitty when in zen mode
                    -- to make this work, you need to set the following kitty options:
                    -- - allow_remote_control socket-only
                    -- - listen_on unix:/tmp/kitty
                    kitty = {
                        enabled = false,
                        font = "+4", -- font size increment
                    },
                    -- this will change the font size on alacritty when in zen mode
                    -- requires  Alacritty Version 0.10.0 or higher
                    -- uses `alacritty msg` subcommand to change font size
                    alacritty = {
                        enabled = false,
                        font = "14", -- font size
                    },
                    -- this will change the font size on wezterm when in zen mode
                    -- See alse also the Plugins/Wezterm section in this projects README
                    wezterm = {
                        enabled = false,
                        -- can be either an absolute font size or the number of incremental steps
                        font = "+4", -- (10% increase per step)
                    },
                    -- this will change the scale factor in Neovide when in zen mode
                    -- See alse also the Plugins/Wezterm section in this projects README
                    neovide = {
                        enabled = false,
                        -- Will multiply the current scale factor by this number
                        scale = 1.2,
                        -- disable the Neovide animations while in Zen mode
                        disable_animations = {
                            neovide_animation_length = 0,
                            neovide_cursor_animate_command_line = false,
                            neovide_scroll_animation_length = 0,
                            neovide_position_animation_length = 0,
                            neovide_cursor_animation_length = 0,
                            neovide_cursor_vfx_mode = "",
                        }
                    },
                },
                -- callback where you can add custom code when the Zen window opens
                on_open = function(win)
                end,
                -- callback where you can add custom code when the Zen window closes
                on_close = function()
                end,
            }
        }
    },
    install = { colorscheme = { "gruber-darker" } },
    checker = { enabled = false },
})

-- ============================ --
--      THEME AND SYNTAX        --
-- ============================ --
require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
    ensure_installed = { "c", "rust", "cpp", "lua", "vim", "vimdoc" }, -- { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    -- List of parsers to ignore installing (or "all")
    ignore_install = { "javascript" },

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    highlight = {
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        disable = {}, -- { "c", "rust" },
        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
}

-- Set theme and syntax highlighting
vim.opt.background = 'dark'
vim.cmd([[
  syntax off
  colorscheme gruber-darker
]])

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.cmd("ZenMode")
    end
})

-- ============================ --
--    MISCELLANEOUS MAPPINGS     --
-- ============================ --

-- General keybinding for entering command mode
vim.keymap.set('n', '<CR>', ':')

-- Mapping for escaping insert mode using 'kj'
vim.keymap.set('i', 'kj', '<Esc>')
vim.keymap.set('t', 'kj', '<C-\\><C-n>')

-- Basic movement and navigation
vim.keymap.set('n', '<Leader>h', '^')          -- Go to beginning of line
vim.keymap.set('n', '<Leader>l', 'g_')         -- Go to end of line

-- Clipboard bindings (copy/paste)
if vim.fn.has('clipboard') == 1 then
    vim.keymap.set('', 'cp', '"+y')   -- Copy to system clipboard
    vim.keymap.set('', 'cv', '"+p')   -- Paste from system clipboard
end

-- Moving lines while preserving indentation
vim.keymap.set('n', '<C-j>', ':move .+1<CR>==') -- Move current line down
vim.keymap.set('n', '<C-k>', ':move .-2<CR>==') -- Move current line up
vim.keymap.set('v', '<C-j>', ":move '>+1<CR>gv=gv") -- Move selected lines down
vim.keymap.set('v', '<C-k>', ":move '<-2<CR>gv=gv") -- Move selected lines up

-- ============================ --
--         COMMON COMMANDS       --
-- ============================ --

-- File operations
vim.keymap.set('n', '<Leader>w', ':write<CR>') -- Save file
vim.keymap.set('n', '<Leader>qq', ':quitall<CR>') -- Quit all open files
vim.keymap.set('n', '<Leader>Q', ':quitall!<CR>') -- Force quit all open files

-- Buffer and window operations
vim.keymap.set('n', '<Leader>bq', ':bdelete<CR>') -- Close current buffer
vim.keymap.set('n', '<Leader>bl', ':buffer #<CR>') -- Switch to previous buffer
vim.keymap.set('n', '<Leader>bb', ':buffers<CR>:buffer<Space>') -- List buffers

-- Directory navigation
vim.keymap.set('n', '<Leader>dd', ':Explore %:p:h<CR>') -- Open current directory in netrw
vim.keymap.set('n', '<Leader>da', ':Explore<CR>') -- Open home directory in netrw
