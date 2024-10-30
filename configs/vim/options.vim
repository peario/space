" Header: Options

" Section: General

set autowrite
set mouse=nv
set encoding=UTF-8
set termguicolors
set clipboard+=unnamedplus
set splitright
set splitbelow
set splitkeep=screen
set timeoutlen=300
set updatetime=200
set winminwidth=5
set completeopt=menu,menuone,noselect

" Section: Tabs and indentation

set softtabstop=2
set tabstop=2
set shiftround
set shiftwidth=2
set autoindent
set smartindent
set smarttab
set expandtab

" Section: Words and scrolling

set linebreak
set nowrap
set scrolloff=4
set sidescrolloff=8
set conceallevel=2
set foldlevel=99
set formatoptions=jcroqln " tcqj

" Section: Side column

set number
set relativenumber
set signcolumn=yes

" Section: Undo, backup and swap

" For backups
if isdirectory('~/.vim/backup')
  set backupdir=~/.vim/backup
endif

" For persistent undos across sessions
if has('persistent_undo')
  set undodir=~/.vim/backup/undo
  set undofile

  set undoreload=10000
endif

" For swapfiles
if isdirectory('~/.vim/swap')
  set directory=~/.vim/swap
  set swapfile
endif

" Section: Search

set incsearch
set hlsearch
set ignorecase
set smartcase
set infercase

set grepformat=%f:%l:%c:%m
set grepprg="rg --vimgrep"

" Section: Handle annoyances

set novisualbell
set noerrorbells
set belloff=esc
set confirm
set noshowcmd

" Section: Visual cues

set noshowmode
set pumheight=10

" Section: Command mode

set history=1000
set wildmenu
set wildmode=longest:full,full
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx,*.un~

" Section: Visual mode

set virtualedit=block
