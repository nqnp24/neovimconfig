-- ============================ --
--      GENERAL SETTINGS        --
-- ============================ --

-- Filetype settings and compatibility
vim.opt.filetype = 'colortemplate'            -- Set default filetype for color templates
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
vim.opt.cmdheight = 1                         -- Use one line for the command-line area
vim.opt.laststatus = 2                        -- Always show the status line
vim.opt.showmode = true                       -- Show mode (e.g., INSERT, NORMAL)
vim.opt.showcmd = true                        -- Show command input in the command line
vim.opt.undofile = true                       -- Enable persistent undo across sessions
vim.opt.undodir = '~/.vim/undo'               -- Directory for undo history
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
vim.opt.scrolloff = 8                         -- Keep 8 lines visible above and below the cursor
vim.opt.sidescrolloff = 8                     -- Keep 8 columns visible to the left and right of the cursor
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
        vim.cmd('%!clang-format-18 -style=file') -- Apply clang-format to C/C++ files
    end
end

-- Map Ctrl-s to format and save the current file
vim.api.nvim_set_keymap('n', '<C-s>', ':lua FormatAndSave()<CR>:w<CR>', { noremap = true, silent = true })

-- Indentation settings for various filetypes
vim.cmd [[
    set autoindent
    set expandtab
    set shiftwidth=8
    set softtabstop=8
    set tabstop=8
    set smartindent
]]

-- Filetype-specific settings for C/C++
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
    local opts = {buffer = true, remap = true, silent = true}
    vim.keymap.set('n', lhs, rhs, opts)
  end

  -- Better navigation within netrw
  bufmap('H', 'u')             -- Go up one directory
  bufmap('h', '-^')            -- Navigate to parent directory
  bufmap('l', '<CR>')          -- Open file or directory
  bufmap('<Leader>aa', '<C-6>') -- Jump between file buffers
  bufmap('.', 'gh')            -- Toggle visibility of dotfiles
end

-- Autocommand for netrw filetype
local user_cmds = vim.api.nvim_create_augroup('user_cmds', {clear = true})
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

-- Setup lazy.nvim with plugins
require("lazy").setup({
  spec = {
    "shortcuts/no-neck-pain.nvim", -- Plugin for tiling window management
    {
      "blazkowolf/gruber-darker.nvim", -- Colorscheme
      opts = {
        bold = true,
        italic = {
          strings = false,
        },
      },
    }
  },
  checker = { enabled = false },
})

-- ============================ --
--      THEME AND SYNTAX        --
-- ============================ --

-- Set theme and syntax highlighting
vim.opt.background = 'dark'
vim.cmd([[
  syntax enable
  colorscheme gruber-darker
]])

-- Activate NoNeckPain (plugin) on VimEnter
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  command = "NoNeckPain",
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
