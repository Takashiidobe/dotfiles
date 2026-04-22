-- always set leader first!
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "

-------------------------------------------------------------------------------
--
-- platform
--
-------------------------------------------------------------------------------
local is_mac = vim.fn.has('mac') == 1
local open_cmd = is_mac and 'open' or 'xdg-open'
local clipboard_copy = is_mac and 'pbcopy' or 'wl-copy'
local clipboard_paste = is_mac and 'pbpaste' or 'wl-paste'
local codelldb_cmd = is_mac
		and (vim.fn.exepath('codelldb') ~= '' and vim.fn.exepath('codelldb') or '/opt/homebrew/bin/codelldb')
		or '/usr/lib/codelldb/adapter/codelldb'
local liblldb_path = is_mac
		and '/opt/homebrew/lib/liblldb.dylib'
		or '/usr/lib/codelldb/lldb/lib/liblldb.so'

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-------------------------------------------------------------------------------
--
-- preferences
--
-------------------------------------------------------------------------------
-- use 24-bit color
vim.opt.termguicolors = true
-- never ever folding
vim.opt.foldenable = false
vim.opt.foldmethod = 'manual'
vim.opt.foldlevelstart = 99
-- very basic "continue indent" mode (autoindent) is always on in neovim
-- could try smartindent/cindent, but meh.
-- vim.opt.cindent = true
-- XXX
-- vim.opt.cmdheight = 2
-- vim.opt.completeopt = 'menuone,noinsert,noselect'
-- not setting updatedtime because I use K to manually trigger hover effects
-- and lowering it also changes how frequently files are written to swap.
-- vim.opt.updatetime = 300
-- if key combos seem to be "lagging"
-- http://stackoverflow.com/questions/2158516/delay-before-o-opens-a-new-line
-- vim.opt.timeoutlen = 300
-- keep more context on screen while scrolling
vim.opt.scrolloff = 2
-- never show me line breaks if they're not there
vim.opt.wrap = false
-- always draw sign column. prevents buffer moving when adding/deleting sign
vim.opt.signcolumn = 'yes'
-- sweet sweet relative line numbers
vim.opt.relativenumber = true
-- and show the absolute line number for the current line
vim.opt.number = true
-- keep current content top + left when splitting
vim.opt.splitright = true
vim.opt.splitbelow = true
-- infinite undo!
-- NOTE: ends up in ~/.local/state/nvim/undo/
vim.opt.undofile = true
--" Decent wildmenu
-- in completion, when there is more than one match,
-- list all matches, and only complete to longest common match
vim.opt.wildmode = 'list:longest'
-- when opening a file with a command (like :e),
-- don't suggest files like there:
vim.opt.wildignore = '.git,.hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site'
-- tabs: go big or go home
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.expandtab = false
-- case-insensitive search/replace
vim.opt.ignorecase = true
-- unless uppercase in search term
vim.opt.smartcase = true
-- never ever make my terminal beep
vim.opt.vb = true
-- more useful diffs (nvim -d)
--- by ignoring whitespace
vim.opt.diffopt:append('iwhite')
--- and using a smarter algorithm
--- https://vimways.org/2018/the-power-of-diff/
--- https://stackoverflow.com/questions/32365271/whats-the-difference-between-git-diff-patience-and-git-diff-histogram
--- https://luppeng.wordpress.com/2020/10/10/when-to-use-each-of-the-git-diff-algorithms/
vim.opt.diffopt:append('algorithm:histogram')
vim.opt.diffopt:append('indent-heuristic')
-- show a column at 80 characters as a guide for long lines
vim.opt.colorcolumn = '80'
--- except in Rust where the rule is 100 characters
vim.api.nvim_create_autocmd('Filetype', { pattern = 'rust', callback = function() vim.opt_local.colorcolumn = '100' end })
-- show more hidden characters
-- also, show tabs nicer
vim.opt.listchars = 'tab:^ ,nbsp:¬,extends:»,precedes:«,trail:•'
vim.opt.clipboard = "unnamedplus"

-------------------------------------------------------------------------------
--
-- hotkeys
--
-------------------------------------------------------------------------------
-- quick-save
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>')
-- make missing : less annoying
vim.keymap.set('n', ';', ':')
-- go back to previous buffer
vim.keymap.set('n', 'gb', '<C-O>')
-- go forward to next buffer
vim.keymap.set('n', 'gn', '<C-I>')
-- Ctrl+j and Ctrl+k as Esc
-- https://github.com/neovim/neovim/issues/5916
vim.keymap.set({ 'n', 'i', 'v', 's', 'x', 'c', 'o', 'l', 't' }, '<C-j>', '<Esc>')
vim.keymap.set({ 'n', 'i', 'v', 's', 'x', 'c', 'o', 'l', 't' }, '<C-k>', '<Esc>')
-- Ctrl+h to stop searching
vim.keymap.set('v', '<C-h>', '<cmd>nohlsearch<cr>')
vim.keymap.set('n', '<C-h>', '<cmd>nohlsearch<cr>')
-- Jump to start and end of line using the home row keys
vim.keymap.set('', 'H', '^')
vim.keymap.set('', 'L', '$')
-- Neat X clipboard integration
-- <leader>p will paste clipboard into buffer
-- <leader>c will copy entire buffer into clipboard
vim.keymap.set('n', '<leader>p', function() vim.cmd('read !' .. clipboard_paste) end)
vim.keymap.set('n', '<leader>C', function() vim.cmd('w !' .. clipboard_copy) end)
-- <leader><leader> toggles between buffers
vim.keymap.set('n', '<leader><leader>', '<c-^>')
-- <leader>, shows/hides hidden characters
vim.keymap.set('n', '<leader>,', ':set invlist<cr>')
-- always center search results
vim.keymap.set('n', 'n', 'nzz', { silent = true })
vim.keymap.set('n', 'N', 'Nzz', { silent = true })
vim.keymap.set('n', '*', '*zz', { silent = true })
vim.keymap.set('n', '#', '#zz', { silent = true })
vim.keymap.set('n', 'g*', 'g*zz', { silent = true })
-- "very magic" (less escaping needed) regexes by default
vim.keymap.set('n', '?', '?\\v')
vim.keymap.set('n', '/', '/\\v')
vim.keymap.set('c', '%s/', '%sm/')
vim.keymap.set('n', '<leader>o', '<cmd>NvimTreeToggle<cr>')
-- no arrow keys --- force yourself to use the home row
vim.keymap.set('n', '<up>', '<nop>')
vim.keymap.set('n', '<down>', '<nop>')
vim.keymap.set('i', '<up>', '<nop>')
vim.keymap.set('i', '<down>', '<nop>')
vim.keymap.set('i', '<left>', '<nop>')
vim.keymap.set('i', '<right>', '<nop>')
-- let the left and right arrows be useful: they can switch buffers
vim.keymap.set('n', '<left>', ':bp<cr>')
vim.keymap.set('n', '<right>', ':bn<cr>')
-- make j and k move by visual line, not actual line, when text is soft-wrapped
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
-- handy keymap for replacing up to next _ (like in variable names)
vim.keymap.set('n', '<leader>_', 'ct_')
-- F1 is pretty close to Esc, so you probably meant Esc
vim.keymap.set('', '<F1>', '<Esc>')
vim.keymap.set('i', '<F1>', '<Esc>')
-- Clear highlights with Esc
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<cr>')

-------------------------------------------------------------------------------
--
-- configuring diagnostics
--
-------------------------------------------------------------------------------
-- Allow virtual text
vim.diagnostic.config({ virtual_text = true, virtual_lines = false })

-------------------------------------------------------------------------------
--
-- autocommands
--
-------------------------------------------------------------------------------
-- highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
	pattern = '*',
	callback = function() vim.highlight.on_yank({ timeout = 500 }) end,
})
-- jump to last edit position on opening file
vim.api.nvim_create_autocmd('BufReadPost', {
	pattern = '*',
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local line_count = vim.api.nvim_buf_line_count(0)
		-- except for git commit messages
		if mark[1] > 1 and mark[1] <= line_count and not vim.fn.expand('%:p'):find('.git', 1, true) then
			vim.api.nvim_win_set_cursor(0, mark)
		end
	end,
})
-- prevent accidental writes to buffers that shouldn't be edited
vim.api.nvim_create_autocmd('BufRead', { pattern = '*.orig', callback = function() vim.bo.readonly = true end })
vim.api.nvim_create_autocmd('BufRead', { pattern = '*.pacnew', callback = function() vim.bo.readonly = true end })
-- shorter columns in text because it reads better that way
local text = vim.api.nvim_create_augroup('text', { clear = true })
vim.api.nvim_create_autocmd('Filetype', {
	pattern = { 'text', 'markdown', 'gitcommit' },
	group = text,
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.textwidth = 72
		vim.opt_local.colorcolumn = '73'
	end,
})
--- tex has so much syntax that a little wider is ok
vim.api.nvim_create_autocmd('Filetype', {
	pattern = 'tex',
	group = text,
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.textwidth = 80
		vim.opt_local.colorcolumn = '81'
	end,
})

-------------------------------------------------------------------------------
--
-- dependency checker
--
-------------------------------------------------------------------------------
vim.api.nvim_create_user_command('CheckDeps', function()
	local deps = {
		{ group = 'Core', name = 'git',                 cmd = 'git' },
		{ group = 'Core', name = 'cc (C compiler)',     cmd = 'cc' },
		{ group = 'Core', name = 'fzf',                 cmd = 'fzf' },
		{ group = 'Core', name = 'ripgrep (rg)',        cmd = 'rg' },
		{ group = 'Core', name = 'fd',                  cmd = 'fd' },
		{ group = 'Core', name = 'proximity-sort',      cmd = 'proximity-sort' },
		{ group = 'Core', name = clipboard_copy,        cmd = clipboard_copy },
		{ group = 'Core', name = clipboard_paste,       cmd = clipboard_paste },
		{ group = 'AI',   name = 'claude',              cmd = 'claude' },
		{ group = 'AI',   name = 'codex',               cmd = 'codex' },
		{ group = 'Rust', name = 'rust-analyzer',       cmd = 'rust-analyzer' },
		{ group = 'Rust', name = 'cargo',               cmd = 'cargo' },
		{ group = 'Rust', name = 'cargo-nextest',       cmd = 'cargo-nextest' },
		{ group = 'Rust', name = 'cargo-show-asm',      cmd = 'cargo-show-asm' },
		{ group = 'Rust', name = 'cargo-flamegraph',    cmd = 'cargo-flamegraph' },
		{ group = 'Rust', name = 'cargo-semver-checks', cmd = 'cargo-semver-checks' },
		{ group = 'Rust', name = 'codelldb',            cmd = codelldb_cmd,         path = true },
		not is_mac and { group = 'Rust', name = 'perf (flamegraph)', cmd = 'perf' } or nil,
		{ group = 'LSP',    name = 'node (for TS/bash LSPs)',    cmd = 'node' },
		{ group = 'LSP',    name = 'clangd',                     cmd = 'clangd' },
		{ group = 'LSP',    name = 'gopls',                      cmd = 'gopls' },
		{ group = 'LSP',    name = 'lua-language-server',        cmd = 'lua-language-server' },
		{ group = 'LSP',    name = 'typescript-language-server', cmd = 'typescript-language-server' },
		{ group = 'LSP*',   name = 'bash-language-server',       cmd = 'bash-language-server' },
		{ group = 'LSP*',   name = 'texlab',                     cmd = 'texlab' },
		{ group = 'LSP*',   name = 'ruff',                       cmd = 'ruff' },
		{ group = 'Tools*', name = 'zathura',                    cmd = 'zathura' },
	}

	-- nvim version check
	local v = vim.version()
	local nvim_ok = v.major > 0 or v.minor >= 11
	local nvim_str = string.format('v%d.%d.%d', v.major, v.minor, v.patch)

	local lines = {
		'Dependency Status  (* = optional)',
		string.rep('─', 48),
		string.format('  %s  nvim %s (need ≥ 0.11)', nvim_ok and '✓' or '✗', nvim_str),
		'',
	}
	local group = nil
	for _, dep in ipairs(deps) do
		if not dep then goto continue end
		if dep.group ~= group then
			if group then table.insert(lines, '') end
			table.insert(lines, '[' .. dep.group .. ']')
			group = dep.group
		end
		local ok = dep.path
				and vim.uv.fs_stat(dep.cmd) ~= nil
				or vim.fn.executable(dep.cmd) == 1
		table.insert(lines, string.format('  %s  %s', ok and '✓' or '✗', dep.name))
		::continue::
	end

	local buf = vim.api.nvim_create_buf(false, true)
	local width = 54
	local height = #lines + 2
	vim.api.nvim_open_win(buf, true, {
		relative = 'editor',
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = 'minimal',
		border = 'rounded',
		title = ' CheckDeps ',
		title_pos = 'center',
	})
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
	vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf, silent = true })
	vim.keymap.set('n', '<Esc>', '<cmd>close<cr>', { buffer = buf, silent = true })
end, {})

-------------------------------------------------------------------------------
--
-- plugin configuration
--
-------------------------------------------------------------------------------
-- first, grab the manager
-- https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
-- then, setup!
require("lazy").setup({
	-- main color scheme
	{
		"wincent/base16-nvim",
		lazy = false,  -- load at start
		priority = 1000, -- load first
		config = function()
			vim.cmd([[colorscheme gruvbox-dark-hard]])
			vim.o.background = 'dark'
			vim.cmd([[hi Normal ctermbg=NONE]])
			-- Less visible window separator
			vim.api.nvim_set_hl(0, "WinSeparator", { fg = 1250067 })
			-- Make comments more prominent -- they are important.
			local bools = vim.api.nvim_get_hl(0, { name = 'Boolean' })
			vim.api.nvim_set_hl(0, 'Comment', bools)
			-- Make it clearly visible which argument we're at.
			local marked = vim.api.nvim_get_hl(0, { name = 'PMenu' })
			vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter',
				{ fg = marked.fg, bg = marked.bg, ctermfg = marked.ctermfg, ctermbg = marked.ctermbg, bold = true })
			-- XXX
			-- Would be nice to customize the highlighting of warnings and the like to make
			-- them less glaring. But alas
			-- https://github.com/nvim-lua/lsp_extensions.nvim/issues/21
			-- call Base16hi("CocHintSign", g:base16_gui03, "", g:base16_cterm03, "", "", "")
		end
	},
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = "nvim-tree/nvim-web-devicons",

		config = function()
			require("nvim-tree").setup({
				actions = {
					change_dir = {
						enable = true,
						global = true
					},
					open_file = {
						resize_window = true
					}
				},
				renderer = {
					indent_markers = {
						enable = true
					}
				},
				view = {
					width = 40
				}
			})
		end
	},
	-- nice bar at the bottom
	{
		'itchyny/lightline.vim',
		lazy = false, -- also load at start since it's UI
		config = function()
			-- no need to also show mode in cmd line when we have bar
			vim.o.showmode = false
			vim.g.lightline = {
				active = {
					left = {
						{ 'mode',     'paste' },
						{ 'readonly', 'filename', 'modified' }
					},
					right = {
						{ 'lineinfo' },
						{ 'percent' },
						{ 'fileencoding', 'filetype' }
					},
				},
				component_function = {
					filename = 'LightlineFilename'
				},
			}
			function LightlineFilenameInLua()
				if vim.fn.expand('%:t') == '' then
					return '[No Name]'
				else
					return vim.fn.getreg('%')
				end
			end

			-- https://github.com/itchyny/lightline.vim/issues/657
			vim.api.nvim_exec2(
				[[
				function! g:LightlineFilename()
					return v:lua.LightlineFilenameInLua()
				endfunction
				]],
				{ output = false }
			)
		end
	},
	-- Git fugitive
	{
		'tpope/vim-fugitive',
		config = function()
			vim.keymap.set('n', '<leader>GG', '<cmd>Git<cr>')
			vim.keymap.set('n', '<leader>B', '<cmd>Git blame<cr>')
			vim.keymap.set({ 'n', 'v' }, '<leader>GB', '<cmd>GBrowse<cr>')
		end
	},
	-- support for github
	{
		'tpope/vim-rhubarb'
	},
	-- quick navigation
	{
		url = "https://codeberg.org/andyg/leap.nvim",
		config = function()
			vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
			vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')
		end
	},
	-- better %
	{
		'andymass/vim-matchup',
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end
	},
	-- option to center the editor
	{
		"shortcuts/no-neck-pain.nvim",
		version = "*",
		opts = {
			mappings = {
				enabled = true,
				toggle = false,
				toggleLeftSide = false,
				toggleRightSide = false,
				widthUp = false,
				widthDown = false,
				scratchPad = false,
			}
		},
		config = function()
			local prose_keys_set = false
			vim.keymap.set('', '<leader>T', function()
				vim.cmd([[
					:NoNeckPain
					:set formatoptions-=tc linebreak tw=0 cc=0 wrap wm=20 noautoindent nocindent nosmartindent indentkeys=
				]])
				if not prose_keys_set then
					vim.keymap.set('n', '0', 'g0')
					vim.keymap.set('n', '$', 'g$')
					vim.keymap.set('n', '^', 'g^')
					prose_keys_set = true
				end
			end)
		end
	},
	-- auto-cd to root of git project
	-- 'airblade/vim-rooter'
	{
		'notjedi/nvim-rooter.lua',
		config = function()
			require('nvim-rooter').setup()
		end
	},
	-- fzf support for <leader>b
	{
		'ibhagwan/fzf-lua',
		config = function()
			-- stop putting a giant window over my editor
			require 'fzf-lua'.setup {
				winopts = {
					split = "belowright 10new",
					preview = {
						hidden = true,
					}
				},
				files = {
					-- file icons are distracting
					file_icons = false,
					-- git icons are nice
					git_icons = true,
					-- but don't mess up my anchored search
					_fzf_nth_devicons = true,
				},
				buffers = {
					file_icons = false,
					git_icons = true,
					-- no nth_devicons as we'll do that
					-- manually since we also use
					-- with-nth
				},
				fzf_opts = {
					-- no reverse view
					["--layout"] = "default",
				},
			}
			-- when using <leader>b for quick file open, pass the file list through
			--
			--   https://github.com/jonhoo/proximity-sort
			--
			-- to prefer files closer to the current file.
			vim.keymap.set('', '<leader>b', function()
				local opts = {}
				opts.cmd = 'fd --color=never --hidden --type f --type l --exclude .git'
				local base = vim.fn.fnamemodify(vim.fn.expand('%'), ':h:.:S')
				if base ~= '.' then
					-- if there is no current file,
					-- proximity-sort can't do its thing
					opts.cmd = opts.cmd .. (" | proximity-sort %s"):format(vim.fn.shellescape(vim.fn.expand('%')))
				end
				opts.fzf_opts = {
					['--scheme']   = 'path',
					['--tiebreak'] = 'index',
					["--layout"]   = "default",
				}
				require 'fzf-lua'.files(opts)
			end)
			-- use fzf to search buffers with <leader>;
			vim.keymap.set('n', '<leader>;', function()
				require 'fzf-lua'.buffers({
					-- just include the paths in the fzf bits, and nothing else
					-- https://github.com/ibhagwan/fzf-lua/issues/2230#issuecomment-3164258823
					fzf_opts = {
						["--with-nth"]     = "{-3..-2}",
						["--nth"]          = "-1",
						["--delimiter"]    = "[:\u{2002}]",
						["--header-lines"] = "false",
					},
					header = false,
				})
			end)
			-- use fzf to search with <leader>s
			vim.keymap.set('n', '<leader>s', function()
				require 'fzf-lua'.lsp_live_workspace_symbols()
			end)
			-- use fzf to ripgrep project with <leader>g
			vim.keymap.set('n', '<leader>g', function()
				require 'fzf-lua'.grep_project({
					rg_opts = table.concat({
						"--column",
						"--line-number",
						"--no-heading",
						"--color=always",
						"--smart-case",
						"--glob '!Cargo.lock'",
					}, " ")
				})
			end)
			-- use fzf to ripgrep buffer with <leader>/
			vim.keymap.set('n', '<leader>/', function()
				require 'fzf-lua'.lgrep_curbuf()
			end)
			-- use fzf to browse current-buffer diagnostics with <leader>x
			vim.keymap.set('n', '<leader>x', function()
				require 'fzf-lua'.diagnostics_document()
			end)
			vim.keymap.set('n', '<leader>.', function()
				require 'fzf-lua'.resume()
			end)
			vim.keymap.set('n', '<leader>O', function()
				require 'fzf-lua'.oldfiles()
			end)
			vim.keymap.set('n', '<leader>?', function()
				require 'fzf-lua'.keymaps()
			end)
		end
	},
	-- LSP
	{
		'neovim/nvim-lspconfig',
		config = function()
			-- Setup language servers.

			-- Rust
			vim.lsp.config('rust_analyzer', {
				-- Server-specific settings. See `:help lspconfig-setup`
				filetypes = { "rust" },
				settings = {
					["rust-analyzer"] = {
						cargo = {
							features = "all",
							allTargets = true,
						},
						check = {
							command = "clippy",
							allTargets = true,
						},
						imports = {
							group = {
								enable = false,
							},
						},
						completion = {
							postfix = {
								enable = false,
							},
						},
					},
				},
			})
			vim.lsp.enable('rust_analyzer')

			vim.lsp.config('clangd', { filetypes = { "c", "cpp", "objc", "objcpp" } })
			vim.lsp.enable('clangd')

			-- Bash LSP
			if vim.fn.executable('bash-language-server') == 1 then
				vim.lsp.enable('bashls')
			end

			-- m68k asm lsp
			-- if vim.fn.executable('m68k-lsp-server') == 1 then
			-- 	vim.lsp.config('m68k', { filetypes = { "asm", "s", "S" } })
			-- 	vim.lsp.enable('m68k')
			-- end

			-- texlab for LaTeX
			if vim.fn.executable('texlab') == 1 then
				vim.lsp.enable('texlab')
			end

			-- Ruff for Python
			if vim.fn.executable('ruff') == 1 then
				vim.lsp.enable('ruff')
			end

			-- TypeScript
			if vim.fn.executable('typescript-language-server') == 1 then
				vim.lsp.enable('ts_ls')
			end

			-- Go
			if vim.fn.executable('gopls') == 1 then
				vim.lsp.enable('gopls')
			end

			-- Lua
			if vim.fn.executable('lua-language-server') == 1 then
				vim.lsp.enable('lua_ls')
			end

			-- Global mappings.
			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
			vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
			vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end)
			vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end)
			vim.keymap.set('n', '[e',
				function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end)
			vim.keymap.set('n', ']e',
				function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end)
			vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

			local function cargo_bench_targets()
				local cargo_toml = vim.fn.findfile('Cargo.toml', '.;')
				if cargo_toml == '' then return nil, nil end
				local cargo_dir = vim.fn.fnamemodify(cargo_toml, ':p:h')
				local names, in_bench = {}, false
				for line in io.lines(cargo_toml) do
					if line:match('^%[%[bench%]%]') then
						in_bench = true
					elseif line:match('^%[') then
						in_bench = false
					elseif in_bench then
						local name = line:match('^name%s*=%s*"([^"]+)"')
						if name then table.insert(names, name) end
					end
				end
				return cargo_dir, names
			end

			local function infer_bench_name(cargo_dir)
				local file = vim.fn.expand('%:p')
				local benches_dir = cargo_dir .. '/benches/'
				if file:sub(1, #benches_dir) == benches_dir then
					return vim.fn.fnamemodify(file, ':t:r')
				end
			end

			local call_tree_ignore = { '.rustup/', '.cargo/registry/', 'go/pkg/mod/', 'GOROOT', '/usr/include/' }
			local function call_tree_ignored(uri)
				local ok, fname = pcall(vim.uri_to_fname, uri)
				for _, pat in ipairs(call_tree_ignore) do
					if uri:find(pat, 1, true) then return true end
					if ok and fname:find(pat, 1, true) then return true end
				end
				return false
			end

			-- Expandable call tree in a floating buffer.
			-- <Tab> lazily fetches and toggles children. <CR> jumps to definition, o to call site.
			local function call_tree(direction)
				local client = vim.lsp.get_clients({ bufnr = 0 })[1]
				if not client then
					vim.notify('No LSP client attached', vim.log.levels.WARN); return
				end
				local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
				local src_buf = vim.api.nvim_get_current_buf()
				local method = direction == 'incoming' and 'callHierarchy/incomingCalls' or 'callHierarchy/outgoingCalls'

				-- src/frontend/parser.rs -> frontend::name, src/lib.rs -> name
				local function qualified_name(i)
					local rel = vim.uri_to_fname(i.uri):match('/src/(.+)$')
					if rel then
						local dir = rel:match('^(.+)/[^/]+$')
						local parent = dir and dir:match('([^/]+)$')
						if parent then return parent .. '::' .. i.name end
					end
					return i.name
				end

				local visible = {}

				local buf = vim.api.nvim_create_buf(false, true)
				local width = math.floor(vim.o.columns * 0.65)
				local height = math.floor(vim.o.lines * 0.6)
				local win = vim.api.nvim_open_win(buf, true, {
					relative = 'editor',
					width = width,
					height = height,
					row = math.floor((vim.o.lines - height) / 2),
					col = math.floor((vim.o.columns - width) / 2),
					style = 'minimal',
					border = 'rounded',
					title = direction == 'incoming' and ' Incoming Calls ' or ' Outgoing Calls ',
					title_pos = 'center',
				})
				vim.bo[buf].modifiable = false

				local ns = vim.api.nvim_create_namespace('call_tree')
				local function render()
					if not vim.api.nvim_buf_is_valid(buf) then return end
					local lines, hls = {}, {}
					for row, node in ipairs(visible) do
						local glyph = node.loading and '⟳'
								or (node.has_children and (node.expanded and '▼' or '▶') or ' ')
						local fname = vim.fn.fnamemodify(vim.uri_to_fname(node.item.uri), ':~:.')
						local lnum = node.item.selectionRange.start.line + 1
						local qname = qualified_name(node.item)
						local name_start = #node.line_prefix + #glyph + 1
						local name_hl = node.has_children and 'Function' or 'Comment'
						local glyph_hl = node.loading and 'DiagnosticWarn' or name_hl
						table.insert(lines, string.format('%s%s %s  %s:%d',
							node.line_prefix, glyph, qname, fname, lnum))
						local r = row - 1
						table.insert(hls, { r, 'NonText', 0, #node.line_prefix })
						table.insert(hls, { r, glyph_hl, #node.line_prefix, name_start })
						table.insert(hls, { r, name_hl, name_start, name_start + #qname })
						local dc = qname:find('::')
						if dc then
							table.insert(hls, { r, 'DiagnosticError', name_start + dc - 1, name_start + dc + 1 })
						end
						table.insert(hls, { r, 'Comment', name_start + #qname + 2, -1 })
					end
					vim.bo[buf].modifiable = true
					vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
					vim.bo[buf].modifiable = false
					vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
					for _, h in ipairs(hls) do
						vim.api.nvim_buf_add_highlight(buf, ns, h[2], h[1], h[3], h[4])
					end
				end

				local function make_node(item, call_site, depth, is_last, base_prefix, ancestor_keys)
					local connector = depth == 0 and '' or (is_last and '└── ' or '├── ')
					local continuation = is_last and '    ' or '│   '
					return {
						item = item,
						call_site = call_site,
						depth = depth,
						loaded = false,
						expanded = false,
						children = {},
						ancestor_keys = ancestor_keys or {},
						line_prefix = base_prefix .. connector,
						child_base_prefix = depth == 0 and '' or (base_prefix .. continuation),
					}
				end

				local function find_idx(node)
					for i, v in ipairs(visible) do if v == node then return i end end
				end

				local function collapse(idx)
					local node = visible[idx]
					node.expanded = false
					local depth = node.depth
					while visible[idx + 1] and visible[idx + 1].depth > depth do
						table.remove(visible, idx + 1)
					end
					render()
				end

				local function prefetch_expandable(node)
					local node_key = node.item.uri .. ':' .. node.item.selectionRange.start.line
					client:request(method, { item = node.item }, function(_, calls)
						vim.schedule(function()
							local has = false
							if calls then
								for _, call in ipairs(calls) do
									local child_item = direction == 'incoming' and call.from or call.to
									local ck = child_item.uri .. ':' .. child_item.selectionRange.start.line
									if not call_tree_ignored(child_item.uri)
											and not node.ancestor_keys[ck]
											and ck ~= node_key then
										has = true; break
									end
								end
							end
							node.has_children = has
							render()
						end)
					end, src_buf)
				end

				local function expand(idx, _retry)
					local node = visible[idx]
					if node.loaded then
						node.expanded = true
						local i = find_idx(node)
						for j, child in ipairs(node.children) do
							table.insert(visible, i + j, child)
						end
						render()
						return
					end
					node.loading = true
					render()
					local node_key = node.item.uri .. ':' .. node.item.selectionRange.start.line
					local child_ancestors = vim.tbl_extend('force', node.ancestor_keys, { [node_key] = true })
					client:request(method, { item = node.item }, function(_, calls)
						local filtered, seen = {}, {}
						if calls then
							for _, call in ipairs(calls) do
								local child_item = direction == 'incoming' and call.from or call.to
								local key = child_item.uri .. ':' .. child_item.selectionRange.start.line
								if not call_tree_ignored(child_item.uri)
										and not seen[key]
										and not child_ancestors[key] then
									seen[key] = true
									local site_uri = direction == 'incoming' and child_item.uri or node.item.uri
									local site_range = call.fromRanges and call.fromRanges[1]
									table.insert(filtered, {
										item = child_item,
										call_site = site_range and { uri = site_uri, range = site_range } or nil,
									})
								end
							end
						end
						vim.schedule(function()
							node.loading = false
							if #filtered == 0 and node.has_children and (_retry or 0) < 20 then
								vim.defer_fn(function()
									if not vim.api.nvim_buf_is_valid(buf) then return end
									local i = find_idx(node)
									if i then expand(i, (_retry or 0) + 1) end
								end, 500)
								return
							end
							node.loaded = true
							for i, entry in ipairs(filtered) do
								local child = make_node(entry.item, entry.call_site,
									node.depth + 1, i == #filtered, node.child_base_prefix, child_ancestors)
								table.insert(node.children, child)
								prefetch_expandable(child)
							end
							node.expanded = true
							local i = find_idx(node)
							if i then
								for j, child in ipairs(node.children) do
									table.insert(visible, i + j, child)
								end
								render()
							end
						end)
					end, src_buf)
				end

				local function jump(loc)
					if not loc then return end
					vim.api.nvim_win_close(win, true)
					vim.lsp.util.show_document({ uri = loc.uri, range = loc.range }, client.offset_encoding)
				end

				vim.keymap.set('n', '<Tab>', function()
					local lnum = vim.api.nvim_win_get_cursor(0)[1]
					local node = visible[lnum]
					if not node then return end
					if node.expanded then collapse(lnum) else expand(lnum) end
				end, { buffer = buf, silent = true })
				vim.keymap.set('n', 'E', function()
					local to_expand = {}
					for _, node in ipairs(visible) do
						if node.has_children and not node.expanded and not node.loading then
							table.insert(to_expand, node)
						end
					end
					for _, node in ipairs(to_expand) do
						local i = find_idx(node)
						if i then expand(i) end
					end
				end, { buffer = buf, silent = true })
				vim.keymap.set('n', 'c', function()
					local lnum = vim.api.nvim_win_get_cursor(0)[1]
					local node = visible[lnum]
					if node and node.expanded then collapse(lnum) end
				end, { buffer = buf, silent = true })
				vim.keymap.set('n', 'C', function()
					for i = #visible, 1, -1 do
						if visible[i].expanded then collapse(i) end
					end
				end, { buffer = buf, silent = true })
				vim.keymap.set('n', '<CR>', function()
					local node = visible[vim.api.nvim_win_get_cursor(0)[1]]
					if node then jump({ uri = node.item.uri, range = node.item.selectionRange }) end
				end, { buffer = buf, silent = true })
				vim.keymap.set('n', 'o', function()
					local node = visible[vim.api.nvim_win_get_cursor(0)[1]]
					if node then jump(node.call_site) end
				end, { buffer = buf, silent = true })
				vim.keymap.set('n', 'q', function() vim.api.nvim_win_close(win, true) end,
					{ buffer = buf, silent = true })
				vim.keymap.set('n', '<Esc>', function() vim.api.nvim_win_close(win, true) end,
					{ buffer = buf, silent = true })

				local max_retries = 60
				local attempt = 0
				local function try_prepare()
					if not vim.api.nvim_win_is_valid(win) then return end
					attempt = attempt + 1
					local dots = string.rep('.', attempt % 4)
					vim.bo[buf].modifiable = true
					vim.api.nvim_buf_set_lines(buf, 0, -1, false, { '  Waiting for LSP' .. dots })
					vim.bo[buf].modifiable = false
					client:request('textDocument/prepareCallHierarchy', params, function(_, items)
						vim.schedule(function()
							if not vim.api.nvim_win_is_valid(win) then return end
							if not items or #items == 0 then
								if attempt >= max_retries then
									vim.bo[buf].modifiable = true
									vim.api.nvim_buf_set_lines(buf, 0, -1, false, { '  No call hierarchy item at cursor' })
									vim.bo[buf].modifiable = false
								else
									vim.defer_fn(try_prepare, 500)
								end
								return
							end
							local root = make_node(items[1], nil, 0, true, '')
							root.has_children = true
							table.insert(visible, root)
							render()
							expand(1)
						end)
					end, src_buf)
				end
				try_prepare()
			end

			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = ev.buf }
					vim.keymap.set({ 'n', 'v' }, 'ga', function()
						require 'fzf-lua'.lsp_code_actions({ silent = true })
					end, opts)
					vim.keymap.set('n', 'gD', function()
						require 'fzf-lua'.lsp_declarations({ winopts = { preview = { hidden = false } } })
					end, opts)
					vim.keymap.set('n', 'gd', function()
						require 'fzf-lua'.lsp_definitions({ winopts = { preview = { hidden = false } } })
					end, opts)
					vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
					vim.keymap.set('n', 'gi', function()
						require 'fzf-lua'.lsp_implementations({ winopts = { preview = { hidden = false } } })
					end, opts)
					vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
					vim.keymap.set('n', '<leader>i', function()
						local bufnr = vim.api.nvim_get_current_buf()
						vim.lsp.inlay_hint.enable(
							not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
							{ bufnr = bufnr }
						)
					end, opts)
					vim.keymap.set('n', '<leader>Wa', vim.lsp.buf.add_workspace_folder, opts)
					vim.keymap.set('n', '<leader>Wr', vim.lsp.buf.remove_workspace_folder, opts)
					vim.keymap.set('n', '<leader>Wl', function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, opts)
					vim.keymap.set('n', '<leader>D', function()
						require 'fzf-lua'.lsp_typedefs({ winopts = { preview = { hidden = false } } })
					end, opts)
					vim.keymap.set('n', '<leader>S', function()
						require 'fzf-lua'.lsp_document_symbols()
					end, opts)
					vim.keymap.set('n', '<leader>l', function()
						require 'fzf-lua'.lsp_finder({ winopts = { preview = { hidden = false } } })
					end, opts)
					vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
					vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)
					vim.keymap.set('n', 'gr', function()
						require 'fzf-lua'.lsp_references({ winopts = { preview = { hidden = false } } })
					end, opts)
					local lsp_calls_opts = {
						winopts = { preview = { hidden = false } },
						file_ignore_patterns = { "%.rustup/", "%.cargo/registry/", "go/pkg/mod/", "GOROOT", "%/usr/include/c++/%" },
					}
					vim.keymap.set('n', '<leader>ci', function() call_tree('incoming') end, opts)
					vim.keymap.set('n', '<leader>co', function() call_tree('outgoing') end, opts)
					vim.keymap.set('n', '<leader>f', function()
						vim.lsp.buf.format { async = true }
					end, opts)
					local client = vim.lsp.get_client_by_id(ev.data.client_id)

					vim.keymap.set('n', '<leader>ml', require('ferris.methods.view_memory_layout'), opts)
					vim.keymap.set('n', '<leader>me', require('ferris.methods.expand_macro'), opts)
					vim.keymap.set('n', '<leader>mi', function()
						local indent = vim.fn.getline('.'):match('^%s*')
						vim.fn.append(vim.fn.line('.') - 1, indent .. '#[inline(never)]')
					end, opts)
					vim.keymap.set('n', '<leader>ma', function()
						local fn_name = vim.fn.expand('<cword>')
						local crate_name = nil
						local cargo_toml = vim.fn.findfile('Cargo.toml', '.;')
						local cargo_dir = cargo_toml ~= '' and vim.fn.fnamemodify(cargo_toml, ':p:h') or nil
						local has_lib = false
						if cargo_toml ~= '' then
							for line in io.lines(cargo_toml) do
								local name = line:match('^name%s*=%s*"([^"]+)"')
								if name then crate_name = name:gsub('-', '_') end
								if line:match('^%[lib%]') then has_lib = true end
							end
						end
						-- also detect lib target by presence of src/lib.rs
						if not has_lib and cargo_dir then
							has_lib = vim.fn.filereadable(cargo_dir .. '/src/lib.rs') == 1
						end

						-- derive module path and target flags from file location
						local mod_prefix = crate_name or ''
						local file = vim.fn.expand('%:p')
						local integration_test_name = nil
						if cargo_dir then
							local tests_dir = cargo_dir .. '/tests/'
							local src_dir = cargo_dir .. '/src/'
							if file:sub(1, #tests_dir) == tests_dir then
								-- integration test: target is the filename, module prefix is empty
								local rel = file:sub(#tests_dir + 1):gsub('%.rs$', '')
								integration_test_name = rel:gsub('/', '-')
								mod_prefix = rel:gsub('/', '::')
							elseif file:sub(1, #src_dir) == src_dir then
								local rel = file:sub(#src_dir + 1):gsub('%.rs$', ''):gsub('/mod$', '')
								if rel ~= 'lib' and rel ~= 'main' then
									mod_prefix = mod_prefix .. '::' .. rel:gsub('/', '::')
								end
							end
						end

						local function run_asm(query, extra_args)
							local output = {}
							local buf = vim.api.nvim_create_buf(false, true)
							local width = math.floor(vim.o.columns * 0.8)
							local height = math.floor(vim.o.lines * 0.8)
							vim.api.nvim_open_win(buf, true, {
								relative = 'editor',
								width = width,
								height = height,
								row = math.floor((vim.o.lines - height) / 2),
								col = math.floor((vim.o.columns - width) / 2),
								style = 'minimal',
								border = 'rounded',
								title = ' asm: ' .. query .. ' ',
								title_pos = 'center',
							})
							vim.api.nvim_buf_set_lines(buf, 0, -1, false, { 'Running cargo asm...' })
							vim.bo[buf].filetype = 'asm'
							vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf, silent = true })
							local cmd = vim.list_extend({ 'cargo', 'asm', '--no-color' }, extra_args)
							vim.list_extend(cmd, { query })
							vim.fn.jobstart(cmd, {
								stdout_buffered = true,
								stderr_buffered = true,
								on_stdout = function(_, data) if data then vim.list_extend(output, data) end end,
								on_stderr = function(_, data) if data then vim.list_extend(output, data) end end,
								on_exit = function(_, code)
									vim.schedule(function()
										if not vim.api.nvim_buf_is_valid(buf) then return end
										if code ~= 0 then
											local targets = {}
											for _, line in ipairs(output) do
												local flag = line:match('^%s+(%-%-[%w]+[%s%w]*)')
												if flag then table.insert(targets, vim.trim(flag)) end
											end
											if #targets > 0 then
												vim.api.nvim_win_close(vim.api.nvim_get_current_win(), true)
												vim.ui.select(targets, { prompt = 'Select cargo target:' }, function(choice)
													if choice then
														run_asm(query, vim.split(choice, '%s+'))
													end
												end)
												return
											end
										end
										vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
										vim.bo[buf].modifiable = false
									end)
								end,
							})
						end

						-- use documentSymbol to find the full symbol path at the cursor
						local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1
						local lsp_client = vim.lsp.get_clients({ bufnr = 0 })[1]
						local function resolve_and_run(symbols)
							local query
							if not symbols or #symbols == 0 then
								query = mod_prefix .. '::' .. fn_name
							else
								local function find_path(syms, prefix)
									for _, sym in ipairs(syms) do
										local r = sym.range
										if r and cursor_line >= r.start.line and cursor_line <= r['end'].line then
											local child_path = sym.children and find_path(sym.children, prefix .. '::' .. sym.name)
											return child_path or (prefix .. '::' .. sym.name)
										end
									end
								end
								query = find_path(symbols, mod_prefix) or (mod_prefix .. '::' .. fn_name)
							end
							local target_args = integration_test_name and { '--test', integration_test_name }
									or (has_lib and { '--lib' } or {})
							run_asm(query, target_args)
						end
						if lsp_client then
							local params = { textDocument = vim.lsp.util.make_text_document_params() }
							lsp_client:request('textDocument/documentSymbol', params, function(err, symbols)
								resolve_and_run(not err and symbols or nil)
							end, 0)
						else
							resolve_and_run(nil)
						end
					end, opts)

					vim.keymap.set('n', '<leader>mb', function()
						local cargo_dir, bench_names = cargo_bench_targets()
						if not cargo_dir or not bench_names or #bench_names == 0 then
							vim.notify('No [[bench]] targets found', vim.log.levels.WARN)
							return
						end
						local function run(name)
							vim.ui.input({ prompt = 'Filter (empty = all): ' }, function(filter)
								if filter == nil then return end
								local cmd = { 'cargo', 'bench', '--bench', name }
								if filter ~= '' then vim.list_extend(cmd, { '--', filter }) end
								vim.cmd('belowright 15new')
								vim.fn.termopen(cmd, { cwd = cargo_dir })
								vim.cmd('startinsert')
							end)
						end
						local inferred = infer_bench_name(cargo_dir)
						if inferred and vim.tbl_contains(bench_names, inferred) then
							run(inferred)
						elseif #bench_names == 1 then
							run(bench_names[1])
						else
							require('fzf-lua').fzf_exec(bench_names, {
								prompt = 'Bench> ',
								actions = { ['default'] = function(sel) if sel and sel[1] then run(sel[1]) end end },
							})
						end
					end, opts)

					vim.keymap.set('n', '<leader>mf', function()
						local cargo_dir, bench_names = cargo_bench_targets()
						if not cargo_dir or not bench_names or #bench_names == 0 then
							vim.notify('No [[bench]] targets found', vim.log.levels.WARN)
							return
						end
						local function run(name)
							vim.cmd('belowright 15new')
							vim.fn.termopen(
								{ 'sh', '-c', 'cargo flamegraph --bench ' ..
								vim.fn.shellescape(name) .. ' && ' .. open_cmd .. ' flamegraph.svg' },
								{ cwd = cargo_dir }
							)
							vim.cmd('startinsert')
						end
						local inferred = infer_bench_name(cargo_dir)
						if inferred and vim.tbl_contains(bench_names, inferred) then
							run(inferred)
						elseif #bench_names == 1 then
							run(bench_names[1])
						else
							require('fzf-lua').fzf_exec(bench_names, {
								prompt = 'Flamegraph> ',
								actions = { ['default'] = function(sel) if sel and sel[1] then run(sel[1]) end end },
							})
						end
					end, opts)

					vim.keymap.set('n', '<leader>ms', function()
						local cargo_toml = vim.fn.findfile('Cargo.toml', '.;')
						if cargo_toml == '' then
							vim.notify('No Cargo.toml found', vim.log.levels.WARN)
							return
						end
						local cargo_dir = vim.fn.fnamemodify(cargo_toml, ':p:h')
						vim.notify('Running cargo semver-checks…', vim.log.levels.INFO)
						local output = {}
						vim.fn.jobstart({ 'cargo', 'semver-checks', '--baseline-rev', 'HEAD' }, {
							cwd = cargo_dir,
							stdout_buffered = true,
							stderr_buffered = true,
							on_stdout = function(_, data) if data then vim.list_extend(output, data) end end,
							on_stderr = function(_, data) if data then vim.list_extend(output, data) end end,
							on_exit = function(_, code)
								vim.schedule(function()
									local qflist = {}
									local check_desc = nil
									for _, line in ipairs(output) do
										local desc = line:match('^%-%-%- failure [%w_]+: (.+) %-%-%-$')
										if desc then
											check_desc = desc
										else
											local item, path, lnum = line:match('^%s+%w+%s+([^,]+), previously in file ([^:]+):(%d+)$')
											if item and path and lnum then
												local rel = path:match('[/\\]target[/\\]semver%-checks[/\\][^/\\]+[/\\][0-9a-f]+[/\\](.+)$')
												local filename = rel and (cargo_dir .. '/' .. rel) or path
												table.insert(qflist, {
													filename = filename,
													lnum = tonumber(lnum),
													col = 1,
													text = item .. (check_desc and (' — ' .. check_desc) or ''),
													type = 'E',
												})
											end
										end
									end
									if code == 0 or #qflist == 0 then
										vim.notify(
											code == 0 and 'No semver violations' or 'cargo semver-checks failed (no locations parsed)',
											vim.log.levels.INFO)
										return
									end
									vim.fn.setqflist({}, 'r', { title = 'cargo semver-checks', items = qflist })
									require('fzf-lua').quickfix()
								end)
							end,
						})
					end, opts)

					-- None of this semantics tokens business.
					-- https://www.reddit.com/r/neovim/comments/143efmd/is_it_possible_to_disable_treesitter_completely/
					if client then
						client.server_capabilities.semanticTokensProvider = nil
					end

					if client and client.server_capabilities.documentFormattingProvider then
						local bufnr = ev.buf
						local bufname = vim.api.nvim_buf_get_name(bufnr)
						local llvm_root = vim.fn.expand("~/llvm-project/")
						local skip_autoformat = client.name == "clangd" and bufname:sub(1, #llvm_root) == llvm_root

						if not skip_autoformat then
							vim.api.nvim_create_autocmd("BufWritePre", {
								group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = false }),
								buffer = bufnr,
								callback = function()
									vim.lsp.buf.format({ bufnr = bufnr, async = false })
								end,
							})
						end
					end
				end,
			})
		end
	},
	-- LSP-based code-completion
	{
		"hrsh7th/nvim-cmp",
		-- load cmp on InsertEnter
		event = "InsertEnter",
		-- these dependencies will only be loaded when cmp loads
		-- dependencies are always lazy-loaded unless specified otherwise
		dependencies = {
			'neovim/nvim-lspconfig',
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require 'cmp'
			cmp.setup({
				snippet = {
					-- REQUIRED by nvim-cmp. get rid of it once we can
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.abort(),
					-- Accept currently selected item.
					-- Set `select` to `false` to only confirm explicitly selected items.
					['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
				}, {
					{ name = 'path' },
				}),
				experimental = {
					ghost_text = true,
				},
			})

			-- Enable completing paths in :
			cmp.setup.cmdline(':', {
				sources = cmp.config.sources({
					{ name = 'path' }
				})
			})
		end
	},
	-- inline function signatures
	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			-- Get signatures (and _only_ signatures) when in argument lists.
			require "lsp_signature".setup({
				doc_lines = 0,
				handler_opts = {
					border = "none"
				},
			})
		end
	},
	-- language support
	-- terraform
	{
		'hashivim/vim-terraform',
		ft = { "terraform" },
	},
	-- svelte
	{
		'evanleck/vim-svelte',
		ft = { "svelte" },
	},
	-- toml
	{
		'cespare/vim-toml',
		ft = { "toml" },
	},
	-- yaml
	{
		"cuducos/yaml.nvim",
		ft = { "yaml" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},
	-- latex
	{
		"lervag/vimtex",
		ft = { "tex" },
		lazy = false, -- we don't want to lazy load VimTeX
		init = function()
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_mappings_enabled = false
		end
	},
	-- fish
	'khaveesh/vim-fish-syntax',
	-- markdown
	{
		'plasticboy/vim-markdown',
		ft = { "markdown" },
		dependencies = {
			'godlygeek/tabular',
		},
		config = function()
			-- never ever fold!
			vim.g.vim_markdown_folding_disabled = 1
			-- support front-matter in .md files
			vim.g.vim_markdown_frontmatter = 1
			-- 'o' on a list item should insert at same level
			vim.g.vim_markdown_new_list_item_indent = 0
			-- don't add bullets when wrapping:
			-- https://github.com/preservim/vim-markdown/issues/232
			vim.g.vim_markdown_auto_insert_bullets = 0
		end
	},
	-- treesitter
	{
		'nvim-treesitter/nvim-treesitter',
		branch = 'master',
		build = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup({
				ensure_installed = { 'rust', 'lua', 'toml' },
				highlight = { enable = false },
				auto_install = true,
			})
		end,
	},
	-- testing
	{
		'nvim-neotest/neotest',
		dependencies = {
			'nvim-neotest/nvim-nio',
			'nvim-lua/plenary.nvim',
			'antoinemadec/FixCursorHold.nvim',
			'nvim-treesitter/nvim-treesitter',
			'rouge8/neotest-rust',
		},
		config = function()
			require('neotest').setup({
				adapters = {
					require('neotest-rust'),
				},
				output = {
					open_on_run = true,
				},
			})
			vim.keymap.set('n', '<leader>tr', function() require('neotest').run.run() end)
			vim.keymap.set('n', '<leader>tl', function() require('neotest').run.run_last() end)
			vim.keymap.set('n', '<leader>tq', function() require('neotest').run.stop() end)
			vim.keymap.set('n', '<leader>td', function() require('neotest').run.run({ strategy = 'dap' }) end)
			vim.keymap.set('n', '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end)
			vim.keymap.set('n', '<leader>ta', function() require('neotest').run.run(vim.fn.getcwd()) end)
			vim.keymap.set('n', '<leader>ts', function() require('neotest').summary.toggle() end)
			vim.keymap.set('n', '<leader>to', function() require('neotest').output.open() end)
			vim.keymap.set('n', '<leader>tp', function() require('neotest').output_panel.toggle() end)
			vim.keymap.set('n', ']t', function() require('neotest').jump.next({ status = 'failed' }) end)
			vim.keymap.set('n', '[t', function() require('neotest').jump.prev({ status = 'failed' }) end)
		end,
	},
	-- debugging
	{
		'mfussenegger/nvim-dap',
		config = function()
			local dap = require('dap')

			dap.listeners.on_config['codelldb_rust'] = function(config)
				if config.type == 'codelldb' and not config.sourceLanguages then
					config = vim.tbl_extend('force', config, { sourceLanguages = { 'rust' } })
				end
				return config
			end

			dap.adapters.codelldb = {
				type = 'server',
				port = '${port}',
				executable = {
					command = codelldb_cmd,
					args = { '--port', '${port}', '--liblldb', liblldb_path },
				},
			}

			dap.configurations.rust = {
				{
					name = 'Debug',
					type = 'codelldb',
					request = 'launch',
					program = function()
						vim.fn.system('cargo build 2>/dev/null')
						return vim.fn.getcwd() .. '/target/debug/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
					end,
					cwd = '${workspaceFolder}',
					stopOnEntry = false,
					terminal = 'console',
					sourceLanguages = { 'rust' },
				},
				{
					name = 'Debug test',
					type = 'codelldb',
					request = 'launch',
					program = function()
						local output = vim.fn.system('cargo test --no-run --message-format=json 2>&1')
						for line in output:gmatch('[^\n]+') do
							local ok, data = pcall(vim.fn.json_decode, line)
							if ok and data and data.executable
									and data.profile and data.profile.test
									and data.target and data.target.kind
									and vim.tbl_contains(data.target.kind, 'lib') then
								return data.executable
							end
						end
						error('Could not find test binary')
					end,
					args = function()
						local test_name = vim.fn.input('Test filter: ')
						return { test_name, '--nocapture', '--test-threads=1' }
					end,
					cwd = '${workspaceFolder}',
					stopOnEntry = false,
					terminal = 'console',
					sourceLanguages = { 'rust' },
				},
			}

			vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint)
			vim.keymap.set('n', '<leader>dB', function()
				dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
			end)
			vim.keymap.set('n', '<leader>dc', dap.continue)
			vim.keymap.set('n', '<leader>dn', dap.step_over)
			vim.keymap.set('n', '<leader>di', dap.step_into)
			vim.keymap.set('n', '<leader>do', dap.step_out)
			vim.keymap.set('n', '<leader>dh', dap.run_to_cursor)
			vim.keymap.set('n', '<leader>dq', dap.terminate)
		end,
	},
	{
		'rcarriga/nvim-dap-ui',
		dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
		config = function()
			local dap, dapui = require('dap'), require('dapui')
			dapui.setup()
			dap.listeners.after.event_stopped['dapui_config'] = function() dapui.open() end
			dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
			dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end
			vim.keymap.set({ 'n', 'v' }, '<leader>de', dapui.eval)
			vim.keymap.set('n', '<leader>du', dapui.toggle)
		end,
	},
	{
		'Weissle/persistent-breakpoints.nvim',
		dependencies = { 'mfussenegger/nvim-dap' },
		config = function()
			require('persistent-breakpoints').setup({ load_breakpoints_event = { 'BufReadPost' } })
			local pb = require('persistent-breakpoints.api')
			vim.keymap.set('n', '<leader>db', pb.toggle_breakpoint)
			vim.keymap.set('n', '<leader>dB', function()
				pb.set_conditional_breakpoint(vim.fn.input('Breakpoint condition: '))
			end)
			vim.keymap.set('n', '<leader>dx', pb.clear_all_breakpoints)
		end,
	},
	{
		'vxpm/ferris.nvim',
		opts = {},
		ft = 'rust',
	},
	{
		'saecki/crates.nvim',
		event = { "BufRead Cargo.toml" },
		config = function()
			require('crates').setup()
			local crates = require("crates")
			local opts = { silent = true }

			vim.keymap.set("n", "<leader>ct", crates.toggle, opts)
			vim.keymap.set("n", "<leader>cr", crates.reload, opts)

			vim.keymap.set("n", "<leader>cv", crates.show_versions_popup, opts)
			vim.keymap.set("n", "<leader>cf", crates.show_features_popup, opts)
			vim.keymap.set("n", "<leader>cd", crates.show_dependencies_popup, opts)

			vim.keymap.set("n", "<leader>cu", crates.update_crate, opts)
			vim.keymap.set("v", "<leader>cu", crates.update_crates, opts)
			vim.keymap.set("n", "<leader>ca", crates.update_all_crates, opts)
			vim.keymap.set("n", "<leader>cU", crates.upgrade_crate, opts)
			vim.keymap.set("v", "<leader>cU", crates.upgrade_crates, opts)
			vim.keymap.set("n", "<leader>cA", crates.upgrade_all_crates, opts)

			vim.keymap.set("n", "<leader>ce", crates.expand_plain_crate_to_inline_table, opts)
			vim.keymap.set("n", "<leader>cE", crates.extract_crate_into_table, opts)

			vim.keymap.set("n", "<leader>cH", crates.open_homepage, opts)
			vim.keymap.set("n", "<leader>cR", crates.open_repository, opts)
			vim.keymap.set("n", "<leader>cD", crates.open_documentation, opts)
			vim.keymap.set("n", "<leader>cC", crates.open_crates_io, opts)
			vim.keymap.set("n", "<leader>cL", crates.open_lib_rs, opts)
		end,
	},
	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		config = true,
		keys = {
			{ "<leader>cc",  "<cmd>ClaudeCode<cr>",           desc = "Toggle Claude" },
			{ "<leader>ccs", "<cmd>ClaudeCodeSend<cr>",       mode = "v",            desc = "Send to Claude" },
			-- Diff management
			{ "<leader>cad", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
			{ "<leader>cdd", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
		},
	},
	{
		'rhart92/codex.nvim', -- depends on codex CLI. Make sure it is installed
		config = function()
			require('codex').setup {
				split = 'vertical',
				size = 0.3,
				float = {
					width = 1,
					height = 0.6,
					border = 'rounded',
					row = nil,
					col = nil,
					title = 'codex',
				},
				codex_cmd = { 'codex' },
				focus_after_send = true,
				log_level = 'debug',
				autostart = false,
			}

			local group = vim.api.nvim_create_augroup('CodexHideStatusColumn', { clear = true })
			vim.api.nvim_create_autocmd('BufWinEnter', {
				group = group,
				callback = function(args)
					if vim.bo[args.buf].filetype ~= 'codex' then
						return
					end
					local win = vim.api.nvim_get_current_win()
					if not vim.api.nvim_win_is_valid(win) then
						return
					end
					vim.api.nvim_set_option_value('statuscolumn', '', { win = win })
					vim.api.nvim_set_option_value('number', false, { win = win })
					vim.api.nvim_set_option_value('relativenumber', false, { win = win })
				end,
			})

			vim.keymap.set('v', '<leader>cxs', function()
				require('codex').actions.send_selection()
			end, { desc = 'Codex: Send selection' })

			vim.keymap.set('n', '<leader>cx', function()
				require('codex').toggle()
			end, { desc = 'Codex: Toggle' })
		end,
	}
})
