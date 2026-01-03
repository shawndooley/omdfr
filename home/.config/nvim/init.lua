-- Minimal, common lazy.nvim setup
-- This is the baseline most guides and configs start from

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

-- Add lazy.nvim to runtimepath
vim.opt.rtp:prepend(lazypath)

-- === Backup / Swap / Undo / Session state (Vim-style, modern Neovim) ===
-- This mirrors your old Vim behavior, but uses Neovim paths and Lua

local data = vim.fn.stdpath("data")
local cache = vim.fn.stdpath("cache")

-- Ensure directories exist
vim.fn.mkdir(data .. "/backup", "p")
vim.fn.mkdir(data .. "/swap", "p")
vim.fn.mkdir(data .. "/undo", "p")

-- Backup files
-- Prefer project-local .vim-backup, fallback to global backup dir
vim.opt.backup = true
vim.opt.backupdir = {
  ".",                    -- allow local dir
  "./.vim-backup//",     -- project-local (preferred)
  data .. "/backup//",   -- global fallback
}

-- Swap files
-- Prefer project-local .vim-swap, then global, then /tmp
vim.opt.directory = {
  "./.vim-swap//",
  data .. "/swap//",
  "/tmp//",
  ".",
}

-- Persistent undo
-- Prefer project-local .vim-undo, fallback to global undo dir
vim.opt.undofile = true
vim.opt.undodir = {
  "./.vim-undo//",
  data .. "/undo//",
}


vim.opt.clipboard = "unnamedplus"

-- Session / state (Neovim replacement for viminfo)
-- Stores marks, registers, jump list, etc.
vim.opt.shada = {
  "!",
  "'1000",
  "<50",
  "s10",
  "h"
}



-- === Core editor behavior (translated from legacy Vim config) ===

-- Keep context visible when scrolling
vim.opt.scrolloff = 10

-- Search behavior
vim.opt.hlsearch = true      -- highlight search results
vim.opt.ignorecase = true    -- case-insensitive by default
vim.opt.smartcase = true     -- but case-sensitive if pattern has caps

-- Indentation behavior
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Performance
vim.opt.lazyredraw = true

-- Tabs / spaces
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- Text formatting
vim.opt.textwidth = 80

-- C / C++ indentation (kept intentionally; LSP formatting overrides when used)
vim.opt.cindent = true
vim.opt.cinoptions = "h1,l1,g1,t0,i4,+4,(0,w1,W4,N-s,g1,h1"

-- Common typo corrections (command aliases)
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Q", "q", {})
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("WQ", "wq", {})

-- Insert-mode escape shortcut
vim.keymap.set("i", "jj", "<Esc>", { silent = true })

-- Filetype detection & syntax (mostly defaults in Neovim, but explicit)
vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")

-- Plugin specification
require("lazy").setup({
  -- Lazy manages itself
  { "folke/lazy.nvim" },

  -- Common dependency
  { "nvim-lua/plenary.nvim" },

  -- Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  -- === LSP + Completion stack (current best practice) ===

  -- LSP installer/manager
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim" },

  -- Neovim LSP
  { "neovim/nvim-lspconfig" },

  -- Autocompletion engine
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },

  -- Snippets (required by most LSP setups)
  { "L3MON4D3/LuaSnip" },

  -- Auto-pairs for brackets, quotes, etc.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
  },
})

-- === LSP + Completion configuration ===

-- LSP capabilities for completion
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Mason setup
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",      -- Lua
    "pyright",     -- Python
    "omnisharp",   -- C#
    "clangd",      -- C / C++
  },
})

-- === LSP servers (Neovim 0.11+ native API) ===
-- Neovim 0.11 deprecated the *framework* part of nvim-lspconfig.
-- The server configs still come from nvim-lspconfig, but are now
-- registered via `vim.lsp.config()` instead of `require("lspconfig")`.
--
-- This means:
-- • We DO NOT `require("lspconfig")`
-- • We call `vim.lsp.config(<server>, { ... })`
-- • Mason still installs the binaries
-- • nvim-lspconfig is now effectively "data-only"

-- Lua Language Server
-- Notes:
-- • Required for Neovim config and plugin development
-- • Needs explicit `vim` global to avoid false diagnostics
-- • Does NOT understand Neovim runtime files unless configured
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
    },
  },
})

-- Python (pyright)
-- Notes:
-- • Fast, reliable, static type checker
-- • Does NOT run code or resolve dynamic imports well
-- • Virtualenv detection depends on project layout
vim.lsp.config("pyright", {
  capabilities = capabilities,
})

-- C / C++ (clangd)
-- Notes:
-- • Requires compile_commands.json for accurate results
-- • Best used with CMake or Meson
-- • Header-only or ad-hoc builds may give degraded diagnostics
vim.lsp.config("clangd", {
  capabilities = capabilities,
})

-- C# (OmniSharp)
-- Notes:
-- • Works best when opened at the solution (.sln) root
-- • Performance depends heavily on project size
-- • Roslyn analyzers are supported but not enabled here
-- • Unity projects require additional flags
vim.lsp.config("omnisharp", {
  capabilities = capabilities,
  cmd = { "omnisharp" },
})

-- === Formatting integration (use built-in = operator) ===

-- Use LSP for formatting when available
-- This makes `=` (e.g. gg=G) call the language server formatter
-- instead of Vim's indent-based formatter
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    if client and client.server_capabilities.documentFormattingProvider then
      -- Tell Neovim to use LSP for the = operator
      vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr()"
    end
  end,
})

-- Formatting notes by language:
-- Lua (lua_ls): formats reasonably well, but opinionated
-- Python (pyright): does NOT format; requires external tool (black/ruff)
-- C/C++ (clangd): formats via clang-format if config is present
-- C# (OmniSharp): formats via Roslyn; respects .editorconfig

-- === Auto-pairs configuration ===

-- Automatically insert matching pairs: (), {}, [], "", ''
-- Behavior notes:
-- • Respects filetype and syntax (via Treesitter when available)
-- • Integrates with completion confirm (<CR>)
-- • Does NOT interfere with your use of operators like `=`
local autopairs = require("nvim-autopairs")

-- Basic setup (safe defaults)
autopairs.setup({
  check_ts = true, -- use Treesitter to avoid pairing in strings/comments
})

-- Integrate autopairs with nvim-cmp
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")

cmp.event:on(
  "confirm_done",
  cmp_autopairs.on_confirm_done()
)

-- Completion setup
local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  }),
})
