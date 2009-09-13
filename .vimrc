" jd AT vauguet DOT org
" available at http://github.com/chikamichi/config-files/

" {{{ Génériques

" reload the buffer if edited -- never played well for me
"autocmd! BufWritePost .vimrc source ~/.vimrc

" automatically read in external changes if we haven't modified the buffer
set autoread

" automatically flush to disk when using :make, etc.
set autowrite

" if you :q with changes it asks you if you want to continue or not
" drived me mad with vim-taglist on
"set confirm

" default encoding
set encoding=utf-8
set fileencoding=utf-8

" auto +x
"au BufWritePost *.{sh,pl} silent exe "!chmod +x %"

" When editing a file, always jump to the last cursor position
autocmd BufReadPost *
\  if line("'\"") > 0 && line("'\"") <= line("$") |
\    exe "normal g`\"" |
\  endif

" formats de fichiers pour lesquels l'autocomplétion est désactivée
set wildignore=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif

" add : as a file-name character (allow gf to work with http://foo.bar/)
set isfname+=:

" accélère le rendu graphique dans les terminaux véloces
set ttyfast

" faster!
set timeout timeoutlen=3000 ttimeoutlen=100

" le système d'exploitation décide à la place de Vim le bon moment pour vider le cache
set nofsync

" hauteur de la ligne de status (utile pour les plugins de library hints,
" notifications diverses et variées type mlint, VCS…)
set ch=2

" une ligne de status avec plus d'information !
" attention :
" - au %{VimBuddy()} qui nécessite le plugin VimBuddy
" - au VCS qui nécessite le plugin vcscommand
" - au %{Tlist_Get_Tagname_By_Line()} qui nécessite le plugin Vim-taglist
set laststatus=2
set statusline=%F\ %{VCSCommandGetStatusLine()}\ %m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]\ %{Tlist_Get_Tagname_By_Line()}\ %=\ %{VimBuddy()}

" messages plus courts de la part de Vim
set shortmess=asTI

" conserve du contexte autour du curseur d'édition
set scrolloff=3
set sidescrolloff=3

" gestion des lignes longues (:help wrap)
set wrap
set sidescroll=5
set listchars+=precedes:<,extends:>

" affiche les numéros de ligne sur le coté
set number

" met en évidence la ligne actuellement éditée
set cursorline

" place le curseur là où il était lors de la fermeture du fichier
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

" la touche backspace peut supprimer tout et n'importe quoi, *dans tous les modes*
set backspace=2

" pas de compatiblité avec vi afin d'activer les fonctionnalités de Vim
set nocompatible

" pas de bip! relou lors d'une erreur
set noerrorbells

" ne PAS faire clignoter l'écran lors d'une erreur (relou^2)
set novisualbell

" active les plugins et les indentations par type de fichier
filetype on
filetype plugin indent on

" quand on tape par ex. un ")", Vim montre le "(" correspondant
set showmatch

" définitions de ce que sont les commentaires
set com& " reset to default
set com^=sr:*\ -,mb:*\ \ ,el:*/ com^=sr://\ -,mb://\ \ ,el:///

" ajoute une marge à gauche pour afficher les +/- des replis (folds)
if has("gui_running")
    set foldcolumn=2
endif

" autorise le folding
set foldenable

" critère par défaut pour replier les blocs : marqueurs explicites {{{ … }}}
set foldmethod=marker

" prévisualisation dans Firefox
command! Preview :!firefox %<CR>

" navigation parmi les onglets « à la Firefox »
nmap <C-S-tab>       :tabprevious<CR>
nmap <C-tab>         :tabnext<CR>
map  <C-S-tab>       :tabprevious<CR>
map  <C-tab>         :tabnext<CR>
imap <C-S-tab> <Esc> :tabprevious<CR>i
imap <C-tab> <Esc>   :tabnext<CR>i
nmap <C-t>           :tabnew<CR>
imap <C-t> <Esc>     :tabnew<CR>
map  <C-M-w>         :tabclose<CR>

" se placer automatiquement dans le dossier du fichier actuellement édité
" désactivé pour conserver la fonctionnalité d'OmniCompletion
"autocmd BufEnter * lcd %:p:h

" mouse support in terminals
if !has("gui_running")
    set mouse=a
endif

" don't move the cursor to the start of the line when changing buffers
set nostartofline

" hide the mouse in the gui while typing
set mousehide

" {{{ correction orthographique

" French everywhere
set nospell spelllang=fr

" automatique pour les fichiers .txt et .tex
augroup filetypedetect
  au BufNewFile,BufRead *.txt setlocal spell spelllang=fr
  au BufNewFile,BufRead *.tex setlocal spell spelllang=fr
augroup END

" painless spell checking (F10)
function s:spell()
    if !exists("s:spell_check") || s:spell_check == 0
        echo "Spell check on"
        let s:spell_check = 1
        setlocal spell spelllang=en_us
    else
        echo "Spell check off"
        let s:spell_check = 0
        setlocal spell spelllang=
    endif
endfunction
noremap <F10> :call <SID>spell()<CR>
inoremap <F10> <C-o>:call <SID>spell()<CR>
vnoremap <F10> <C-o>:call <SID>spell()<CR>

" correction orthographique }}}

" Génériques }}}

" {{{ Indentation
" à lire avant toute copier/coller stupide : http://vim.wikia.com/wiki/Indenting_source_code
" compte tenu du 'filetype plugin indent on' précédent, pas de smartindent !

" indentation automatique en l'absence de réglages pour le filetype courant
set autoindent

" des espaces à la place du caractère TAB
set tabstop=8
set softtabstop=2
set shiftwidth=2
set expandtab

" < and > will hit indentation levels instead of always -4/+4
set shiftround

" some nice options for cindenting, by FOLKE
set cinoptions={.5s,+.5s,t0,n-2,p2s,(03s,=.5s,>1s,=1s,:1s

" keep the current selection when indenting (thanks cbus)
vnoremap < <gv
vnoremap > >gv

" {{{ pour le plugin surround
" permet de redonner la main à vim pour gérer l'indentation automatique
let b:surround_indent = 1
" surround }}}

" Indentation }}}

" {{{ Recherche et substitution

" ignorer la casse des caractères dans les recherches de chaînes
set ignorecase

" mais ne pas l'ignorer s'il y a explicitement des majuscules
set scs

" regexp version magic
set magic

" recherche circulaire (pour couvrir tout le fichier, quel que soit le point
" de départ de la recherche)
set wrapscan

" résultats dynamiques au cours de la recherche (amène le curseur sur le
" résultat pour le motif actuellement recherché)
set sm

" surlignage des résultats
set hls

" … y compris en cours de frappe
set incsearch

" !!! use 'g'-flag when substituting (subst. all matches in that line, not only first)
" to turn off, use g (why is there no -g ?)
" set gdefault

" Touche TAB améliorée
vmap <tab> >gv
vmap <bs> <gv

" auto-complete avec <tab>
function! TabAlign()
    " Cette fonction, lorsqu'aucun mot n'est tapé, cherche à recopier le dernier caractère de la ligne d'avant
    " Idéal pour aligner des backslash avant des retour à la ligne
    let col  = col('.')
    let lnum = line('.')
    " recherche de la première ligne ayant une longueur supérieure à la ligne courante
    while lnum > 1 " chercher la ligne 
        let lnum = lnum - 1
        let ln = strpart(getline(lnum), col-1)
        let ms = matchstr(ln, '[^ ]*  *[^ ]')
        if ms != ""
            break
        endif
    endwhile

    if lnum == 1
        return "\<Tab>"
    else
        " Copie dans le registre z du dernier caractère de la ligne de longueur supérieure trouvée
        let @z = substitute(strpart(ms, 0, strlen(ms)-1), '.', ' ', 'g')
        " Si au dernier caractère de la ligne :
        if col > strlen(getline('.'))
            " Copie du registre z après le caractère courant (CTRL-O échappe du mode insertion pour une instruction)
            return "\<C-O>\"zp"
        else
            " Copie du registre z avant le caractère courant (idem)
            return "\<C-O>\"zP"
        endif
    endif
endfunction

function! CleverTab()
    let c = strpart(getline('.'), col('.')-2, 1)
    " Si aucun mot n'a été partiellement saisi
    if c == ' ' || c == '\t' || c == ''
        " Utiliser la fonction précédente
        return TabAlign()
    else
        " Complétion automatique
        return "\<C-P>"
    endif
endfunction

inoremap <Tab> <C-R>=CleverTab()<CR>
inoremap <S-Tab> <C-R>=TabAlign()<CR>

" <espace> deux fois en mode normal efface les messages et les résultats de recherche
nnoremap <silent> <Space><Space> :silent noh<Bar>echo<CR>

" expliciter les espaces insécables
set listchars=nbsp:·,tab:>-
set list

" Recherche et subsitution }}}

" {{{ Coloration syntaxique, couleurs, polices

" active la coloration syntaxique quand c'est possible
"if &t_Co > 2 || has("gui_running")
        "syntax on
"endif

" thème de coloration syntaxique par défaut
colorscheme zenburn

if has("gui_running")
        " tente de maximiser la fenêtre GVim (problème avec Gnome et Metacity
        " non solvable par la configuration de Vim seule)
        set lines=99999 columns=99999

        " police par défaut
        if has("win32")
                set guifont=Fixedsys:h9:cANSI
                "set guifont=Courier:h10:cANSI
        else
                "set guifont=Deja\ Vu\ Sans\ Mono\ 12
                " you'll need ttf-droid:
                set guifont=Droid\ Sans\ Mono\ 14
                " réglages de l'interface
                set guioptions+=ace
                set guioptions-=mT
        endif
endif

" couleurs des numéros de lignes, en accord avec zenburn
hi LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
" couleurs des numéros des folds, en accord avec zenburn
hi Folded ctermbg=LightGreen ctermfg=white guibg=DarkOliveGreen guifg=ivory

" couleurs plus sympas pour les pop-up et menus, en accord avec le thème zenburn
:highlight Pmenu    guibg=brown   gui=bold
:highlight PmenuSel guibg=DarkRed gui=bold

" how many lines to sync backwards
syn sync minlines=10000 maxlines=10000

" export HTML (:TOhtml) *avec CSS*
let html_use_css = 1

" Recherche et substitution }}}

" {{{ Statusline, menu, onglets

" use tab for auto-expansion in menus
set wc=<TAB>

" show a list of all matches when tabbing a command
set wmnu

" how command line completion works
set wildmode=list:longest,list:full

" ignore some files for filename completion
set wildignore=*.o,*.r,*.so,*.sl,*.tar,*.tgz,*.pyc,*~

" some filetypes got lower priority
set su=.h,.bak,~,.o,.info,.swp,.obj

" enhanced command-line completion mode
set wildmenu

" remember last 2000 typed commands
set hi=2000

" afficher la position du curseur
set ruler

" display more information in the ruler
set rulerformat=%40(%=%t%h%m%r%w%<\ (%n)\ %4.7l,%-7.(%c%V%)\ %P%)

" toujours afficher le mode courant
set showmode

" affichage dynamique des commandes
set showcmd

" a - terse messages (like [+] instead of [Modified]
" o - don't show both reading and writing messages if both occur at once
" t - truncate file names
" T - truncate messages rather than prompting to press enter
" W - don't show [w] when writing
" I - no intro message when starting vim fileless
set shortmess=aotTWI

" la ligne de status est toujours visible
set laststatus=2

" display as much of the last line as possible if it's really long
" also display unprintable characters as hex
set display+=lastline,uhex

" onglets, fritzophrenic mood
" http://groups.google.com/group/vim_use/browse_thread/thread/9bbfb7f6ec651438
set showtabline=2

" highlight matching parens for .2s
set showmatch
set matchtime=2

" word wrapping -- don't cut words
set linebreak

" set up tab labels with tab number, buffer name, number of windows
function! GuiTabLabel()
    let label = ''
    let bufnrlist = tabpagebuflist(v:lnum)

    " Add '+' if one of the buffers in the tab page is modified
    for bufnr in bufnrlist
    if getbufvar(bufnr, "&modified")
        let label = '+'
        break
    endif
    endfor

    " Append the tab number
    let label .= tabpagenr().': '

    " Append the buffer name
    let name = bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])
    if name == ''
        " give a name to no-name documents
        if &buftype=='quickfix'
            let name = '[Quickfix List]'
        else
            let name = '[Non enregistré]'
        endif
    else
        " get only the file name
        let name = fnamemodify(name,":t")
    endif
    let label .= name

    " Append the number of windows in the tab page
    let wincount = tabpagewinnr(v:lnum, '$')
    return label . '  [' . wincount . ']'
endfunction

" set up tab tooltips with every buffer name
function! GuiTabToolTip()
    let tip = ''
    let bufnrlist = tabpagebuflist(v:lnum)

    for bufnr in bufnrlist
        " separate buffer entries
        if tip!=''
            let tip .= ' | '
        endif

        " Add name of buffer
        let name=bufname(bufnr)
        if name == ''
            " give a name to no name documents
            if getbufvar(bufnr,'&buftype')=='quickfix'
                let name = '[Quickfix List]'
            else
                let name = '[Non enregistré]'
            endif
        endif
        let tip.=name

        " add modified/modifiable flags
        if getbufvar(bufnr, "&modified")
            let tip .= ' [+]'
        endif
        if getbufvar(bufnr, "&modifiable")==0
            let tip .= ' [-]'
        endif
    endfor

    return tip
endfunction

set guitablabel=%!GuiTabLabel()
set guitabtooltip=%!GuiTabToolTip()

" Statusline, menu, onglets }}}

" {{{ Gestion du fenêtrage

if has("gui_running")
    " le focus suit la souris
    set mousef
    " le bouton droit affiche une popup
    set mousemodel=popup_setpos
endif

"Toggle Menu and Toolbar
set guioptions-=m
set guioptions-=T
map <silent> <F2> :if &guioptions =~# 'T' <Bar>
\set guioptions-=T <Bar>
\set guioptions-=m <bar>
\else <Bar>
\set guioptions+=T <Bar>
\set guioptions+=m <Bar>
\endif<CR>

" minimal number of lines used for the current window
set wh=1

" minimal number of lines used for any window
set wmh=0

" make all windows the same size when adding/removing windows
set noequalalways

" les nouvelles fenêtres sont crées sous l'actuelle
set splitbelow

" Gestion du fenêtrage }}}

" {{{ Sauvegarde

" activation de la sauvagarde
set backup

" répertoire de sauvegarde automatique
set backupdir=~/.vim/backup

" le swap est mis à jour aprés 50 caractères saisies
"set updatecount=500
" suppression de l'utilisation du fichier d'échange
set updatecount=0

" force save with "W" using sudo
command W w !sudo tee % > /dev/null

" Sauvegarde }}}

" {{{ Mapping
" certains mapping sont définis dans la section Plugins

" modifie le <leader> (« \ » par défaut)
" j'utilise la virgule car sur le clavier bépo, elle est située en plein
" centre du clavier !
let   mapleader = ","
let g:mapleader = ","

" easily cancel hitting the leader key once
nnoremap <Leader><Leader> <Leader>

" pratique pour ouvrir des fichiers, à défaut d'un auto-cd
map ,cd :cd %:p:h<CR>

" navigation spéciale clavier bépo (dvorak)
" ie. en mode normal/commande, maintenir Alt et utiliser les doigts au
" repos pour des déplacements rapides sans flèches
" éventuellement à étendre pour les modes insertion, visuel…
set winaltkeys=no
nmap <A-t> gj
nmap <A-s> l
nmap <A-e> gk
nmap <A-i> h

" navigation alternatives dans les lignes coupées
map  <A-DOWN>        gj
map  <A-UP>          gk
imap <A-UP>   <ESC>  gki
imap <A-DOWN> <ESC>  gkj

" raccourci classique pour sauvegarder
nmap <c-s> :w<CR>
imap <c-s> <Esc>:w<CR>a
nmap <leader>w :w!<CR>

" collage propre depuis le buffer extérieur (indentations)
" pas besoin pour ma part, à l'usage
"inoremap <C-v> <esc>:set paste<cr>mui<C-R>+<esc>mv'uV'v=:set nopaste<cr>

" raccourci pratique pour rechercher
nmap <leader>f :find<CR>

" supprime tout les blancs en debut de ligne
nmap _S :%s/^\s\+//<CR>

" déplace la ligne courante vers le bas
nmap _t :move .+1<CR>
" déplace la ligne courante vers le haut
nmap _e :move .-2<CR>

" converts file format to/from unix
command! Unixformat :set ff=unix
command! Dosformat  :set ff=dos

" raccourcis classiques pour annuler
inoremap <C-Z> <C-O>u
noremap  <C-Z> u

" raccourcis classiques pour refaire
" (supprimé car en confit avec le scroll montant)
"noremap <C-Y> <C-R>
"inoremap <C-Y> <C-O><C-R>

" scroll vers le bas sans bouger le curseur
map <C-DOWN> <C-E>
" scroll vers le haut sans bouger le curseur
map <C-UP> <C-Y>

" tout séléctionner
noremap <C-A> gggH<C-O>G
"inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
cnoremap <C-A> <C-C>gggH<C-O>G

" indentation automatique (à la Emacs)
vnoremap <C-F>   =$
vnoremap <tab>   =
nnoremap <tab>   =$
nnoremap <C-tab> mzvip=`z

" <F1> lance la commande d'aide au lieu d'afficher l'intro de l'aide
nnoremap <F1> :help<Space>
vmap <F1> <C-C><F1>
omap <F1> <C-C><F1>
map! <F1> <C-C><F1>

" forcer la fermeture d'un tampon
map  <F4> :bd!<cr>
imap <F4> <C-O>:bd!<cr>
cmap <F4> <c-c>:bd!<cr>

" active/désactive la navigation par tags
nnoremap <silent> <F8> :Tlist<CR>

if has("gui_running")
   " Shift-[flèche] pour sélectionner un bloc
    map  <S-Up>    vk
    vmap <S-Up>    k
    map  <S-Down>  vj
    vmap <S-Down>  j
    map  <S-Right> v
    vmap <S-Right> l
    map  <S-Left>  v
    vmap <S-Left>  h
endif

" gestion du caractère NULL dans tous les modes
imap <Nul> <Space>
map  <Nul> <Nop>
vmap <Nul> <Nop>
cmap <Nul> <Nop>
nmap <Nul> <Nop>

" FuzzyFinder
" http://github.com/jamis/fuzzyfinder_textmate/
map <leader>t :FuzzyFinderTextMate<CR>

" Mapping }}}

" {{{ Plugins

" my plugins in ~/.vim/plugin/:
" |-- AlignMapsPlugin.vim
" |-- AlignPlugin.vim
" |-- AutoAlign.vim
" |-- NERD_commenter.vim
" |-- SearchComplete.vim
" |-- SearchPosition.vim
" |-- a.vim
" |-- bufexplorer.vim
" |-- cecutil.vim
" |-- fuzzyfinder.vim
" |-- fuzzyfinder_textmate.vim
" |-- imaps.vim
" |-- libList.vim
" |-- matchit.vim -> /usr/share/vim/vim72/macros/matchit.vim
" |-- obviousmode.vim
" |-- prtdialog.vim
" |-- rails.vim
" |-- rainbow_parenthsis.vim
" |-- remoteOpen.vim
" |-- scmdiff.vim
" |-- snipMate.vim
" |-- supertab.vim
" |-- surround.vim
" |-- taglist.vim
" |-- vcscommand.vim
" |-- vcscvs.vim
" |-- vcsgit.vim
" |-- vcssvk.vim
" |-- vcssvn.vim
" |-- vimballPlugin.vim
" |-- vimbuddy.vim
" `-- vimwiki.vim

" interesting but not tested yet:
" - coding style per project: http://www.vim.org/scripts/script.php?script_id=2633

" {{{ Commandes automatiques
if has("autocmd")
  augroup augroup_autocmd
    au!
    filetype plugin on

    " se placer à la position du curseur lors de la fermeture du fichier
    autocmd BufReadPost *
          \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \   exe "normal g`\"" |
          \ endif

    " par type de fichier
    autocmd FileType text        setlocal textwidth=78 nocindent
    autocmd FileType html        set      formatoptions+=tl
    " plugin autoclosetag
    au FileType xhtml,xml so ~/.vim/ftplugin/html_autoclosetag.vim
    autocmd FileType c,cpp,slang set      cindent

    " par extension, pour les cas tricky
    autocmd BufNewFile,BufRead *.pc           set ft=proc
    autocmd BufNewFile,BufRead *.phtm,*.phtml set ft=php
    au      BufNewFile,BufRead *.asy          setf asy
    au!     BufRead,BufNewFile *.haml         setfiletype haml 
    au!     BufRead,BufNewFile *.sass         setfiletype sass 

    " tabulation stricte dans les Makefile
    autocmd FileType make     set noexpandtab
  augroup END
endif

" always cd to the current file/buffer directory
"if exists('+autochdir')
"set autochdir
"else
"autocmd BufEnter * silent! lcd %:p:h:gs/ /\\ /
"endif

" Commandes automatiques }}}

" {{{ SuperTab continued
" http://www.vim.org/scripts/script.php?script_id=1643

" allow to trigger completion from within a word
let g:SuperTabMidWordCompletion = 0

" smart completion (let SuperTab decide how to complete) 
let g:SuperTabDefaultCompletionType = 'context'

" you may want to change
" let g:SuperTabMappingTabLiteral = '<c-tab>'
" to something else so it you can insert tabs within a console/tty!

" SuperTab }}}

" {{{ LaTeX avec le plugin latex-suite
" http://vim-latex.sourceforge.net/

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a single file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" petits raccourcis en plus pour les IMAP persos de latexsuite
imap <C-B> <Plug>IMAP_JumpForward
imap <C-M-B> <Plug>IMAP_JumpBack
" supprime le raccourci qui transforme ^a en \mathbf{} et crée un raccourci <Alt-B> qui écrit \mathbf{}
imap <Alt-B> <Plug>Tex_MathBF

" }}}

" {{{ ctags, vim-taglist, OmniCompletion

" Le plugin vim-taglist est vivement conseillé !
" http://vim-taglist.sourceforge.net
"
" I changed it the following way so it won't bother me with R/W rights:
"
" comment this (3920-3927):
    "if filereadable(sessionfile)
    "    let ans = input('Do you want to overwrite ' . sessionfile . ' (Y/N)?')
    "    if ans !=? 'y'
    "        return
    "    endif
    "
    "    echo "\n"
    "endif
"
" add this instead (uncomment!):
"
    "if !filereadable(sessionfile)
    "  return
    "endif

" open tags on Vim startup
let Tlist_Auto_Open = 1
" fetch tags for closed files/buffer in the background
let Tlist_Process_File_Always = 1
" close inactive files tags folds
let Tlist_File_Fold_Auto_Close = 1
" order tags by name
let Tlist_Sort_Type = "name"
" change colors for zenburn integration
":highlight MyTagListTagName guifg=blue ctermfg=blue
":highlight MyTagListFileName guifg=blue ctermfg=blue
" do not alter window size on toggling
let Tlist_Inc_Winwidth = 0
" don't care about the folding charts
let Tlist_Enable_Fold_Column = 0

" toggle tags
nnoremap <silent> <F12> :TlistToggle<cr>
" http://vim-taglist.sourceforge.net/manual.html#:TlistAddFilesRecursive
" takes two arguments!
" so, hit <C-F12>, hit <space>, type the directory,
" hit <space> again, type a pattern like *.c (* is default value)
" and <Enter> to add tags from files within a directory,
" without actually opening them in numerous buffers
nnoremap <silent> <C-F12> :TlistAddFilesRecursive
" update the tags for the current buffer
nnoremap <silent> <F11> :TlistUpdate<cr>

" OmniCompletion

" pour plus d'infos sur les autocmd,
" http://vim.dindinx.net/traduit/html/autocmd.txt.php
if has("autocmd")
  augroup augroup_omni
    au!
    " display menu even if there is only one match
    " (so you can accept or reject it)
    :set completeopt+=menuone

    " http://vim.wikia.com/wiki/VimTip1228
    inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
    inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
    inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
    inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
    inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
    inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

    " binding
    setlocal                        omnifunc=syntaxcomplete#Complete
    autocmd FileType ada        set omnifunc=adacomplete#Complete
    autocmd FileType python     set omnifunc=pythoncomplete#Complete
    autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType html       set omnifunc=htmlcomplete#CompleteTags
    autocmd FileType css        set omnifunc=csscomplete#CompleteCSS
    autocmd FileType xml        set omnifunc=xmlcomplete#CompleteTags
    autocmd FileType php        set omnifunc=phpcomplete#CompletePHP
    autocmd FileType c          set omnifunc=ccomplete#Complete
    
    " un peu plus complet pour Ruby et affiliés : http://vim-ruby.rubyforge.org
    autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
    autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
    autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
    autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
  augroup END
endif

" }}}

" {{{ MATLAB
" http://www.vim.org/scripts/script.php?script_id=2378

" utiliser le correcteur mlint embarqué avec :make
let g:mlint_path_to_mlint = $HOME . '/bin/mlint'
autocmd BufEnter *.m compiler mlint

" MATLAB }}}

" {{{ VCS
" http://www.vim.org/scripts/script.php?script_id=90
" actually I don't use it ;)

" le mapping par défaut entre en conflit avec le plugin NERDCommenter
" s comme send (en général, c'est pour du commit ;))
let VCSCommandMapPrefix='<Leader>s'

" }}}

" {{{ snipMate
" http://www.vim.org/scripts/script.php?script_id=2540
" actually the latest version is on GitHub: http://github.com/msanders/snipmate.vim/tree/master

nmap <silent> <Leader>,n <Plug>SearchPositionOperator
nmap <silent> <Leader>n <Plug>SearchPositionCurrent
vmap <silent> <Leader>n <Plug>SearchPositionCurrent
nmap <silent> <Leader>m <Plug>SearchPositionCword
vmap <silent> <Leader>m <Plug>SearchPositionCword

" snipMate }}}

" {{{ Rainbow
" http://code.google.com/p/vim-scripts/wiki/RainbowParenthsisBundle

let g:rainbow = 1
let g:rainbow_paren = 1
let g:rainbow_brace = 1
" just loading this directly from the plugin directory fails because language
" syntax files override the highlighting
" using BufWinEnter because that is run after modelines are run (so it catches
" modelines which update highlighting)
autocmd BufWinEnter * runtime plugin/rainbow_paren.vim

" Rainbow }}}

" Plugins }}}

" {{{ Sessions

" http://vim.wikia.com/wiki/VimTip450
" Ces fonctions permettent de récupérer un état particulier de Vim.
"
" Si on souhaite pouvoir réouvrir tout un ensemble de fichiers, avec leurs
" réglages propres, la répartition en onglets et fenêtres, etc. il suffit de
" faire :SetSession "truc bidule" avant de quitter Vim (:qa).
" > attention aux guillemets autour du nom ! <
" Au prochain lancement, une liste permettra de réouvrir "truc bidule", ou
" toute autre session enregistrée par ailleurs, ou continuer avec un Vim
" vierge.
"
" Il faut créer un répertoire ~/.vim/sessions/ accessible en +rw
"
" cette version est légèrement modifiée :
" - full-text, même avec la GUI
" - en français
" - une commande de chargement à la volée (LastSession)
" - support du plugin Vim-taglist (à désactiver si vous n'utilisez pas)

au VimLeave * call VimLeave()
au VimEnter * call VimEnter()
let g:PathToSessions = $HOME . "/.vim/sessions/"

function! VimEnter() 
    if argc() == 0 " si aucun nom de fichier donné, on peut proposer d'ouvrir une session
        let result       = "Sessions disponibles :"
        let sessionfiles = glob(g:PathToSessions . "*.vim")
        while stridx(sessionfiles, "\n") >= 0
            let index        = stridx(sessionfiles, "\n")
            let sessionfile  = strpart(sessionfiles, 0, index)
            let result       = result . "\n " . fnamemodify(sessionfile, ":t:r")
            let sessionfiles = strpart(sessionfiles, index + 1)
        endwhile
        let result      = result . "\n " . fnamemodify(sessionfiles, ":t:r")
        let result      = result . "\n" . "\n" . "Donnez un nom de session (ou aucun pour démarrer avec un nouveau buffer vide) : "
        let sessionname = input(result)
        if sessionname != ""
            exe "source " . g:PathToSessions . sessionname . ".vim"
            exec "TlistSessionLoad " . g:PathToSessions . sessionname . ".vim.tags"
        endif
    endif
endfunction

function! VimLeave()
    exe "mksession! " . g:PathToSessions . "LastSession.vim"

    if exists("g:SessionFileName") == 1
        if g:SessionFileName != ""
            exe "mksession! " . g:SessionFileName
            exec "TlistSessionSave " . g:SessionFileName . ".tags"
        endif
    else
        exec "TlistSessionSave " . g:PathToSessions . "LastSession.vim.tags"
    endif
endfunction

" création d'une nouvelle session avec :SetSession "[nom]"
command! -nargs=1 SetSession   :let g:SessionFileName = g:PathToSessions . <args> . ".vim"
" suppression des sessions enregistrées avec :UnsetSession "[nom]"
" pour en supprimer une définitivement, il faut le faire à la main dans le
" dossier des sessions
command! -nargs=0 UnsetSession :let g:SessionFileName = ""
" ouverture à la volée d'une session dont on connaît le nom
command! -nargs=1 OpenSession  :exe "source" . g:PathToSessions . <args> . ".vim"
" ces commandes peuvent être mappées…

" Sessions }}}

" {{{ Tips

" http://vim.wikia.com/wiki/Display_shell_commands'_output_on_Vim_window
" say, :Shell ls -la
command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
  echo a:cmdline
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')
     if part[0] =~ '\v[%#<]'
        let expanded_part = fnameescape(expand(part))
        let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
     endif
  endfor
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1, 'You entered:    ' . a:cmdline)
  call setline(2, 'Expanded Form:  ' .expanded_cmdline)
  call setline(3,substitute(getline(2),'.','=','g'))
  execute '$read !'. expanded_cmdline
  setlocal nomodifiable
  1
endfunction

" shortcuts
" say:
" :Git add %                (The "%" expands to the current filename)
" :Svn diff -c 1234
command! -complete=file -nargs=* Git call s:RunShellCommand('git '.<q-args>)
command! -complete=file -nargs=* Svn call s:RunShellCommand('svn '.<q-args>)

" Tips }}}

" vim: set foldmethod=marker nonumber:

