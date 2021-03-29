"-- PLUGIN SETTING --
call plug#begin('~/.vim/plugged')

"Syntax highlight for many language
Plug 'sheerun/vim-polyglot'

"color scheme
Plug 'rakr/vim-one'
Plug 'ayu-theme/ayu-vim'
Plug 'git@gitlab.com:yorickpeterse/happy_hacking.vim.git'
Plug 'jacoborus/tender.vim'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'gosukiwi/vim-atom-dark'
Plug 'trusktr/seti.vim'
Plug 'mhartington/oceanic-next'
Plug 'dracula/vim', { 'name': 'dracula' }

Plug 'vim-airline/vim-airline'
Plug 'mattn/emmet-vim'
Plug 'preservim/nerdtree'

"Plug 'Xuyuanp/nerdtree-git-plugin'
"Plug 'airblade/vim-gitgutter'

"plug fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'

"zen mode
Plug 'junegunn/goyo.vim'

"all useful snippet
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

"Coc plugin for intellesense
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

"-- SHOW LINE NUMBER --
set number
set rnu "relative line number

"-- AUTO INDENTION --
"augroup autoindent
"au!
"autocmd BufWritePre * :normal migg=G`i
"augroup End

"-- COLOR SCHEME CONFIG --
"true color support
if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
  set termguicolors
endif

syntax on
"set background=dark
"let g:one_allow_italics=1
"let ayucolor="light"
set t_Co=256
set cursorline
colorscheme dracula 
"aslo change the airline theme to one
let g:airline_theme='dracula'

"-- EMMET CONFIG --
"redefine key for trigger emmet
let g:user_emmet_leader_key=','
"emmet only installed for this related file
let g:user_emmet_install_global=0
autocmd FileType html,css,tsx,svelte,vue EmmetInstall

"-- KEY MAPPING --
"opening nerd treee
nmap <C-b> :NERDTreeToggle<CR>
"close buffer and go to prev buffer
nnoremap <C-c> :bp\|bd #<CR>
"go to next buff
nmap <C-N> :bn <CR>
"set backspace to work normaly
set backspace=indent,eol,start

"-- NERDTree Config --
let g:NERDTreeIgnore=['^node_modules$']
"close nerd tree if only nerd tree open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"-- Git Gutter CONFIG --
"let g:gitgutter_enabled=1
"let g:gitgutter_async=0

"-- airline CONFIG --
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

"-- fzf CONFIG --
let g:fzf_history_dir = '~/.local/share/fzf-history'

map <C-p> :Files<CR>
map <C-f> :BLines<CR>
map <leader>b :Buffers<CR>
nnoremap <leader>g :Rg<CR>
"nnoremap <leader>t :Tags<CR>
"nnoremap <leader>m :Marks<CR>


"let g:fzf_tags_command = 'ctags -R'
" Border color
let g:fzf_layout = {'up': '90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }

let $FZF_DEFAULT_OPTS = '--layout=reverse --info=inline'
let $FZF_DEFAULT_COMMAND='rg --files --hidden'

" Customize fzf colors to match your color scheme
let g:fzf_colors =
      \ { 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }

"Get Files
command! -bang -nargs=? -complete=dir Files
      \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)

" Get text in files with Rg
command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
      \   fzf#vim#with_preview(), <bang>0)

" Ripgrep advanced
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" organize swap file to one folder
set directory^=$HOME/.vim/tmp//
