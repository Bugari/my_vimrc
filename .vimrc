"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintained by:
"       Bugari
"
" Based on:
"       Amir Salihefendic
"       http://amix.dk/blog/post/19691#The-ultimate-Vim-configuration-on-Github
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" proper font
"set gfn=M+\ 1m\ Medium\ 12
"set gfn=Anonymous\ Pro\ for\ Powerline\ 12
"set gfn=Inconsolata-dz\ for\ Powerline\ 12
"set gfn=Ttyp0\ 13
"set gfn=Fira\ Mono\ for\ Powerline\ 12
set gfn=monofur\ for\ Powerline\ 14

" copy file path to register
nmap cp :let @+ = expand("%")<cr>

" fixdel, so backspace works as it should -.-
:fixdel

" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Fast saving
nmap <leader>w :update<cr>
nmap <leader>W :w!<cr>

" Persistent undo
set undofile                " Save undo's after file closes
set undodir=$HOME/.vim/undo " where to save undo histories
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" netrw settings
let g:netrw_liststyle=3
let g:netrw_winsize=-26
" let g:netrw_banner=0

" Set 7 lines to the cursor - when moving vertically using j/k
set so=4

set cursorline

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

"Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=

" sets timeout for leader (default 1000)
set tm=500



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts

" Enable syntax highlighting
syntax enable

"let g:lucius_contrast='medium'
"let g:lucius_contrast_bg='high'
"colorscheme lucius

set background=dark
"let g:solarized_termcolors=256
"colorscheme solarized
"colorscheme hybrid
"colorscheme vividchalk
"colorscheme distinguished
colorscheme jellybeans

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions+=e
    set t_Co=256
    set guitablabel=%M\ %t

endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == i spaces
"set shiftwidth=2
"set tabstop=2
"set softtabstop=2
set shiftwidth=4
set tabstop=4
set softtabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{ Bdelete script

"here is a more exotic version of my original Kwbd script
"delete the buffer; keep windows; create a scratch buffer if no buffers left
function s:Kwbd(kwbdStage)
  if(a:kwbdStage == 1)
    if(!buflisted(winbufnr(0)))
      bd!
      return
    endif
    let s:kwbdBufNum = bufnr("%")
    let s:kwbdWinNum = winnr()
    windo call s:Kwbd(2)
    execute s:kwbdWinNum . 'wincmd w'
    let s:buflistedLeft = 0
    let s:bufFinalJump = 0
    let l:nBufs = bufnr("$")
    let l:i = 1
    while(l:i <= l:nBufs)
      if(l:i != s:kwbdBufNum)
        if(buflisted(l:i))
          let s:buflistedLeft = s:buflistedLeft + 1
        else
          if(bufexists(l:i) && !strlen(bufname(l:i)) && !s:bufFinalJump)
            let s:bufFinalJump = l:i
          endif
        endif
      endif
      let l:i = l:i + 1
    endwhile
    if(!s:buflistedLeft)
      if(s:bufFinalJump)
        windo if(buflisted(winbufnr(0))) | execute "b! " . s:bufFinalJump | endif
      else
        enew
        let l:newBuf = bufnr("%")
        windo if(buflisted(winbufnr(0))) | execute "b! " . l:newBuf | endif
      endif
      execute s:kwbdWinNum . 'wincmd w'
    endif
    if(buflisted(s:kwbdBufNum) || s:kwbdBufNum == bufnr("%"))
      execute "bd! " . s:kwbdBufNum
    endif
    if(!s:buflistedLeft)
      set buflisted
      set bufhidden=delete
      set buftype=
      setlocal noswapfile
    endif
  else
    if(bufnr("%") == s:kwbdBufNum)
      let prevbufvar = bufnr("#")
      if(prevbufvar > 0 && buflisted(prevbufvar) && prevbufvar != s:kwbdBufNum)
        b #
      else
        bn
      endif
    endif
  endif
endfunction

command! Kwbd call s:Kwbd(1)
nnoremap <silent> <Plug>Kwbd :<C-u>Kwbd<CR>
nnoremap <leader>bd :<C-u>Kwbd<cr>

" Create a mapping (e.g. in your .vimrc) like this:
"nmap <C-W>! <Plug>Kwbd




" }}} Bdelete script


" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
"map <space> /
"map <c-space> ?

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
"
"nawigacja po splitach
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

" relative row counting
set relativenumber

" next buffer / previous buffer
map <leader>bn :bn<cr>
map <leader>bp :bp<cr>

" Close all the buffers
map <leader>ba :1,1000 bd<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>tl :tabnext<cr>
map <leader>th :tabprevious<cr>


" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
    set switchbuf=useopen
    ",usetab,newtab
    set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif
" Remember info about open buffers on close
set viminfo^=%


""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line. Airline ignores this feature
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l:%c


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Remap VIM 0 to first non-blank character
map 0 ^

" moving the line up and down
function! s:swap_lines(n1, n2)
    let line1 = getline(a:n1)
    let line2 = getline(a:n2)
    call setline(a:n1, line2)
    call setline(a:n2, line1)
endfunction

function! s:swap_up()
    let n = line('.')
    if n == 1
        return
    endif

    call s:swap_lines(n, n - 1)
    exec n - 1
endfunction

function! s:swap_down()
    let n = line('.')
    if n == line('$')
        return
    endif

    call s:swap_lines(n, n + 1)
    exec n + 1
endfunction

noremap <silent> <c-s-up> :call <SID>swap_up()<CR>
noremap <silent> <c-s-down> :call <SID>swap_down()<CR>

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimgrep searching and cope displaying
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv')<CR>

" Open vimgrep and put the cursor in the right position
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

" Vimgreps in the current file
" map <leader><space> :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>

" When you press <leader>r you can search and replace the selected text
" vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with vimgrep, display your results in cope by doing:
"   <leader>cc
"
"map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>p :cp<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>
set spelllang=pl

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scripbble
map <leader>q :e ~/buffer<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

" so the "+yy copy to system clipboard
" maybe should add also set clipboard=unnamed
set clipboard=unnamedplus

" delete without yanking
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" replace currently selected text with default register
" without yanking it
vnoremap <leader>p "_dP

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

inoremap <F2> <C-R>=strftime("%Y-%m-%d %H:%M")<CR>
inoremap <F3> <C-R>=strftime("%Y-%m-%d")<CR>
inoremap <F4> <C-R>=strftime("%H:%M")<CR>

" not all terminals handle <Fx> keys
nnoremap <leader>it <C-R>=strftime("%Y-%m-%d %H:%M")<CR>
nnoremap <leader>id <C-R>=strftime("%Y-%m-%d")<CR>
nnoremap <leader>iT <C-R>=strftime("%H:%M")<CR>

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction



" zamykanie gdy zostanie tylko NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"podkreślanie podczas wyszukiwania
:nnoremap <CR> :nohlsearch<cr>

"łatwiejsze taby
"imap ,t <Esc>:tabnew<CR>
"skrót okazał się zaklepany

"maczowanie nawiasów <>
set mps+=<:>

"magia, zamieniająca %% na current directory
cnoremap %% <C-R>=expand('%:h').'/'<cr>

"edit w aktualnym folderze
" map <leader>e :edit %%
" map <leader>v :view %%

""" ZAMIANA LINII MIEJSCAMI BEGIN

function! s:swap_lines(n1, n2)
    let line1 = getline(a:n1)
    let line2 = getline(a:n2)
    call setline(a:n1, line2)
    call setline(a:n2, line1)
endfunction

function! s:swap_up()
    let n = line('.')
    if n == 1
        return
    endif

    call s:swap_lines(n, n - 1)
    exec n - 1
endfunction

function! s:swap_down()
    let n = line('.')
    if n == line('$')
        return
    endif

    call s:swap_lines(n, n + 1)
    exec n + 1
endfunction

noremap <silent> <c-s-up> :call <SID>swap_up()<CR>
noremap <silent> <c-s-down> :call <SID>swap_down()<CR>

""" ZAMIANA LINII MIEJSCAMI END


"automatyczne ustalanie typu pliku
au BufNewFile,BufRead *.dump set filetype=sql
au BufNewFile,BufRead *.tmpl set filetype=html

"numerowanie wierszy
set nu
set mouse=a "bo myszka być musi!
set mousemodel=extend

set omnifunc=syntaxcomplete#Complete

call plug#begin('~/.vim/plugged')
" My Plugins here:
"
" original repos on github
" USABILITY
Plug 'manicmaniac/betterga'
Plug 'tpope/vim-fugitive'
Plug 'Lokaltog/vim-easymotion'
Plug 'scrooloose/nerdtree'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'Valloric/MatchTagAlways'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'kien/ctrlp.vim'
Plug 'FelikZ/ctrlp-py-matcher'
Plug 'mattn/emmet-vim'
Plug 'mbbill/undotree'
Plug 'manicmaniac/betterga'
Plug 'wincent/terminus'
Plug 'tpope/vim-unimpaired'
Plug 'scrooloose/nerdcommenter'
Plug 'bling/vim-airline'
Plug 'Rykka/riv.vim'
Plug 'Rykka/InstantRst'
Plug 'Rykka/clickable.vim'
Plug 'jeetsukumaran/vim-indentwise'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'farseer90718/vim-taskwarrior'
Plug 'xolox/vim-misc'
Plug 'dhruvasagar/vim-table-mode'
Plug 'wesQ3/vim-windowswap'
"Plug 'Shougo/neocomplcache.vim'
"Plug 'fholgado/minibufexpl.vim'
"Plug 'Raimondi/delimitMate'

" COMPLETION
Plug 'Valloric/YouCompleteMe'
Plug 'marijnh/tern_for_vim'
Plug 'scrooloose/syntastic'
Plug 'majutsushi/tagbar'
Plug 'xolox/vim-easytags'
" Plug 'ahayman/vim-nodejs-complete' " seems abandonded?
Plug 'ervandew/supertab'

" LANGUAGE SUPPORT
Plug 'kchmck/vim-coffee-script'
Plug 'wavded/vim-stylus'
Plug 'briancollins/vim-jst'
Plug 'lukaszkorecki/CoffeeTags'
Plug 'derekwyatt/vim-scala'
Plug 'gre/play2vim'
Plug 'kchmck/vim-coffee-script'
Plug 'pangloss/vim-javascript'
Plug 'mustache/vim-mustache-handlebars'
Plug 'plasticboy/vim-markdown'
Plug 'jaxbot/syntastic-react'

" COLOR THEMES
Plug 'w0ng/vim-hybrid'
Plug 'altercation/vim-colors-solarized'
Plug 'nanotech/jellybeans.vim'
Plug 'tpope/vim-vividchalk'
Plug 'xolox/vim-notes'
Plug 'jonathanfilip/vim-lucius'

Plug 'wincent/terminus' "small terminal enchancements, like shape of cursor in replace/insert modes
"Plug 'tpope/vim-vinegar' "used with netrw - not used
" vim-scripts repos
"Plug 'ConfirmQuit.vim' "makes mess with 'x' button
Plug 'L9'
Plug 'FuzzyFinder'

call plug#end()

filetype plugin indent on     " required!

"""Ctrl-p

"nmap  :CtrlP<cr>
"let g:ctrlp_cmd = 'CtrlPBuffer'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_extensions = ['line', 'mixed']

let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_max_files = 0

""" mini buf explorer
"map <F3> :MBEbb<CR>
"map <F4> :MBEbf<CR>

""" Buffergator

let g:buffergator_viewport_split_policy = "B"
let g:buffergator_hsplit_size = 10
let g:buffergator_autoexpand_on_split = 0

""" Vim plug
let g:plug_threads=4

""" Vim notes
let g:notes_suffix = '.note'
let g:notes_smart_quotes = 0
let g:notes_list_bullets = ['*','+','-']

""" Indent guides 
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1

let g:indent_guides_exclude_filetypes = ['help', 'note', 'nerdtree'] 

let g:indent_guides_color_change_percent = 6

""" Tagbar config and friends
nmap <F8> :TagbarToggle<CR>
let g:CoffeeAutoTagDisabled=1
let g:CoffeeAutoTagIncludeVars=1

let g:tagbar_compact = 1
" tag for coffee
if executable('coffeetags')
  let g:tagbar_type_coffee = {
        \ 'ctagsbin' : 'coffeetags',
        \ 'ctagsargs' : '',
        \ 'kinds' : [
        \ 'f:functions',
        \ 'o:object',
        \ ],
        \ 'sro' : ".",
        \ 'kind2scope' : {
        \ 'f' : 'object',
        \ 'o' : 'object',
        \ }
        \ }

  let g:tagbar_type_markdown = {
    \ 'ctagstype' : 'markdown',
    \ 'sort' : 0,
    \ 'kinds' : [
        \ 'h:sections'
    \ ]
    \ }
endif


"""MatchTagAlways config:
" obsługiwane formaty:
let g:mta_filetypes = {
    \ 'html' : 1,
    \ 'xhtml' : 1,
    \ 'xml' : 1,
    \ 'jinja' : 1,
	\ 'tmpl' : 1,
    \}

"     NerdTree {
       map <C-E> :NERDTreeToggle<CR>
       map <leader>e :NERDTreeFind<CR>
       map <F2> :NERDTreeToggle<CR>
       "map <C-e> <plug>NERDTreeTabsToggle<CR>

        let NERDTreeShowBookmarks=1
        let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
        let NERDTreeChDirMode=0
        let NERDTreeQuitOnOpen=1
        let NERDTreeMouseMode=2
        let NERDTreeShowHidden=1
        let NERDTreeKeepTreeInNewTab=1
        let g:nerdtree_tabs_open_on_gui_startup=0
"     }
set listchars=eol:¬,tab:▸\ ,trail:⋅,extends:>,precedes:<
set list
nmap <leader>l :set list!<CR>
"→
"eol:¬

"Invisible character colors
"highlight NonText guifg=#4a4a59
"highlight SpecialKey guifg=#4a4a59
"


" set coffeescript lint file
let coffee_lint_options = '-f ~/.vim/coffeelint.json'
let g:coffee_lint_options = '-f ~/.vim/coffeelint.json'

"------------SYNTASTIC-----------
let g:syntastic_enable_signs=1
let g:syntastic_mode_map={ 'mode': 'active',
                     \ 'active_filetypes': ['coffee', 'js', 'php'],
                     \ 'passive_filetypes': ['html', 'java'] }
let g:syntastic_coffee_checkers = ['coffeelint', 'coffee']
let g:syntastic_coffee_coffeelint_args = "--file ~/.vim/coffeelint.json"
let g:syntastic_enable_signs=1
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_javascript_jslint_args = "-esnext"

let g:syntastic_javascript_checkers = ['jsxhint', 'eslint']
let g:syntastic_javascript_jsxhint_exec = 'jsx-jshint-wrapper'


let g:gitgutter_max_signs=1200

" undotree toggle pod <f5>
nnoremap <F5> :UndotreeToggle<cr>:wincmd j<CR>

" replacing normal search with easymotion one
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)


" shows currently imputted command
set showcmd

""" airline
" Enable the list of buffers
"let g:airline#extensions#tabline#enabled = 1

"let g:airline#extensions#tabline#buffer_nr_show = 1
"let g:airline#extensions#tabline#buffer_nr_format = '%s: '

let g:airline_powerline_fonts = 1

" ycm YouCompleteMe
let g:ycm_disable_for_files_larger_than_kb=50000


" show tabline only when there's at least one tab
" 0 = never
" 1 = at least one
" 2 = always
set showtabline=1


" Experimental
"autocmd FocusLost * :set norelativenumber
"autocmd FocusGained * :set relativenumber
"autocmd InsertEnter * :set norelativenumber
"autocmd InsertLeave * :set relativenumber


" temporary workarounds over omni completion
"autocmd FileType * setlocal omnifunc=syntaxcomplete#Complete
"autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
"autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
"autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
"autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete

let g:SuperTabCrMapping = 0
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextDefaultCompletionType = '<c-x><c-u>'
autocmd FileType *
    \ if &omnifunc != '' |
    \     call SuperTabChain(&omnifunc, '<c-p>') |
    \ endif

"""""""""
" notes "
"""""""""

" for javascript development:
" `apt-get install exuberant-ctags`
" `apt-get install node`
"
" `git clone https://github.com/mozilla/doctorjs.git`
" and inside: `git submodule update --init --recursive`
" and then `make install`
"
" YouCompleteMe requires `./install.py --clang-completer --tern-completer` in plugin folder
"
" tern-for-vim requires `npm install` in plugin folder

