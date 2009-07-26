" {{{ Génériques

" recharger ce fichier s'il a été modifié (et sauvegardé)
" pour moi, ça n'a jamais vraiment bien fonctionné ^^
"autocmd! BufWritePost .vimrc source ~/.vimrc

" mise-à-jour automatique si le fichier en cours d'édition a été modifié ailleurs que dans Vim
set autoread

" encodage par défaut
set encoding=utf-8
set fileencoding=utf-8

" formats de fichiers pour lesquels l'autocomplétion est désactivée
set wildignore=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif

" accélère le rendu graphique dans les terminaux véloces
set ttyfast

" le système d'exploitation décide à la place de Vim le bon moment pour vider le cache
set nofsync

" hauteur de la ligne de status (utile pour les plugins de library hints,
" notifications diverses et variées type mlint, VCS…)
set ch=2

" une ligne de status avec plus d'information !
" attention au %{VimBuddy()} qui nécessite le plugin VimBuddy
" et au VCS qui nécessite le plugin vcscommand
set laststatus=2
set statusline=%F\ %{VCSCommandGetStatusLine()}\ %m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]\ %=\ %{VimBuddy()}

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

" la touche backspace peut supprimer tout et n'importe quoi, dans tous les modes
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

" gestion de la souris en console
if !has("gui_running")
    set mouse=a
endif

" correction orthographique
" version Nemolivier
set nospell spelllang=fr
" automatique pour les fichiers .tex
augroup filetypedetect
au BufNewFile,BufRead *.tex setlocal spell spelllang=fr
augroup END
" F10 active/desactive la correction orthographique
function! ToggleSpell()
  if &spell
     set nospell
  else
     set spell
  end
endfunction
noremap <F10> :call ToggleSpell()<cr>
inoremap <F10> <Esc> :call ToggleSpell()<cr>
vnoremap <F10> <Esc> :call ToggleSpell()<cr>

" Génériques }}}

" {{{ Indentation

" indentation automatique
set autoindent

" des espaces à la place du caractère TAB
" :h tabstop pour les détails
set tabstop=2
set shiftwidth=2
set expandtab

" some nice options for cindenting, by FOLKE
set cinoptions={.5s,+.5s,t0,n-2,p2s,(03s,=.5s,>1s,=1s,:1s

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
if &t_Co > 2 || has("gui_running")
        syntax on
endif

if has("gui_running")
        " tente de maximiser la fenêtre GVim (problème avec Gnome et Metacity
        " non solvable par la configuration de Vim seule)
        set lines=99999 columns=99999

        " police par défaut
        if has("win32")
                set guifont=Fixedsys:h9:cANSI
                "set guifont=Courier:h10:cANSI
        else
                set guifont=Deja\ Vu\ Sans\ Mono\ 12
                " réglages de l'interface
                set guioptions+=ace
                set guioptions-=mT
        endif

        " thème de coloration syntaxique par défaut
        colorscheme zenburn
endif

" couleurs des numéros de lignes
:highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

" des couleurs plus sympas pour le pop-up, en accord avec le thème desert
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

" toujours afficher le mode courant
set showmode

" affichage dynamique des commandes
set showcmd

" utiliser des messages courts
set shm=a

" la ligne de status est toujours visible
set laststatus=2

" onglets, fritzophrenic mood
" http://groups.google.com/group/vim_use/browse_thread/thread/9bbfb7f6ec651438
set showtabline=2

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

" répertoire de sauvegarde automatique
set backupdir=$HOME/.vim/backup

" activation de la sauvagarde
set backup

" activation du plugin de gestion de backup numéroté
"set patchmode=.bak

" conservation de l'historique de 10 sauvegardes
"let savevers_max=10

" … avec le même répertoire de sauvegarde que pour le backup classique
"let savevers_dirs = &backupdir

" le swap est mis à jour aprés 50 caractères saisies
"set updatecount=500
" suppression de l'utilisation du fichier d'échange
set updatecount=0

" Sauvegarde }}}

" {{{ Mapping
" certains mapping sont définis dans la section Plugins

" modifie le <leader> (« \ » par défaut)
" j'utilise la virgule car sur le clavier bépo, elle est située en plein
" centre du clavier !
let   mapleader = ","
let g:mapleader = ","

" pratique pour ouvrir des fichiers, à défaut d'un auto-cd
map ,cd :cd %:p:h<CR>

" navigation spéciale clavier bépo (dvorak)
" ie. en mode normal/commande, maintenir espace et utiliser les doigts au
" repos pour des déplacements rapides sans flèches
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

"Use TAB "to complete when typing words, else inserts TABs as usual.
""Uses dictionary and source files to find matching words to complete.

""See help completion for source,
""Note: usual completion is on <C-n> but more trouble to press all the time.
""Never type the same word twice and maybe learn a new spellings!
""Use the Linux dictionary when spelling is in doubt.
""Window users can copy the file to their machine.
"function! Tab_Or_Complete()
  "if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    "return "\<C-N>"
  "else
    "return "\<Tab>"
  "endif
"endfunction
":inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>
":set dictionary="/usr/share/dict/french"

" FuzzyFinder
" http://github.com/jamis/fuzzyfinder_textmate/
map <leader>t :FuzzyFinderTextMate<CR>

" Mapping }}}

" {{{ Plugins

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
" Commandes automatiques }}}

" {{{ LaTeX avec le plugin latex-suite

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

" {{{ ctags, OmniCompletion

"" pour OmniCompletion
"" à créer, par exemple, avec : ctags -R -f ~/.vim/systags /usr/include /usr/local/include
"" sans oublier de lui donner les droits de lecture !
""
"" pour créer une base « locale » (fichiers du répertoire courant, par
"" exemple), dans le cas du C/C++ avec le plugin OmniCppComplete :
"" ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .
""
"" perso, j'utilise :
"" ctags -R --c++-kinds=+p --fields=+iaS --extra=+q -f ~/.vim/systags /usr/include /usr/local/include
"" puis je map Ctrl+F12 pour recharger une liste locale (crée un fichier tags
"" dans le répertoire du fichier en édition)
"" attention, cela entre en conflit avec l'auto-cd défini plus haut !

"" mapping
"" penser à faire un <leader>cd avant ;)
"map <C-F12> :!ctags -R *<CR>
"map <Maj><C-F12> :!ctags -R -f ~/.vim/systags /usr/include /usr/local/include

"" tags système
"set tags+=~/.vim/systags
"" tags locaux
"set tags+=tags;

"if has("autocmd")
    "augroup augroup_omni
    "au!
        "autocmd BufRead * echo "File read!"
        "setlocal                        omnifunc=syntaxcomplete#Complete
        "autocmd FileType ada        set omnifunc=adacomplete#Complete
        "autocmd FileType python     set omnifunc=pythoncomplete#Complete
        "autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
        "autocmd FileType html       set omnifunc=htmlcomplete#CompleteTags
        "autocmd FileType css        set omnifunc=csscomplete#CompleteCSS
        "autocmd FileType xml        set omnifunc=xmlcomplete#CompleteTags
        "autocmd FileType php        set omnifunc=phpcomplete#CompletePHP
        "autocmd FileType c          set omnifunc=ccomplete#Complete
        "" un peu plus complet pour Ruby et affiliés : http://vim-ruby.rubyforge.org
        "autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
        "autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
        "autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
        "autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
    "augroup END
"endif

" }}}

" {{{ MATLAB

" indentation
source /usr/share/vim/addons/plugin/matchit.vim

" correcteur avec :make
let g:mlint_path_to_mlint='/home/jd/bin/mlint'
autocmd BufEnter *.m    compiler mlint

" MATLAB }}}

" {{{ VCS

" le mapping par défaut entre en conflit avec le plugin NERDCommenter
" s comme send (en général c'est pour du commit ;))
let VCSCommandMapPrefix='<Leader>s'

" }}}

" {{{ snipMate

nmap <silent> <Leader>,n <Plug>SearchPositionOperator
nmap <silent> <Leader>n <Plug>SearchPositionCurrent
vmap <silent> <Leader>n <Plug>SearchPositionCurrent
nmap <silent> <Leader>m <Plug>SearchPositionCword
vmap <silent> <Leader>m <Plug>SearchPositionCword

" snipMate }}}

" Plugins }}}

" {{{ Sessions

" http://vim.wikia.com/wiki/VimTip450
" ces fonctions permettent de récupérer un état particulier de Vim.
"
" si on souhaite pouvoir réouvrir tout un ensemble de fichiers, avec leurs
" réglages propres, la répartition en onglets et fenêtres, etc. il suffit de
" faire :SetSession "truc bidule" avant de quitter Vim (:qa)
" > attention aux guillemets autour du nom ! <
" au prochain lancement, une liste permettra de réouvrir "truc bidule", ou
" toute autre session enregistrée par ailleurs, ou continuer avec un Vim
" vierge
"
" il faut créer un répertoire ~/.vim/sessions/ accessible en +rw
"
" cette version est très légèrement modifiée, pour rester full-text, en
" français, avec une commande de chargement à la volée sus

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
        let result      = result . "\n" . "\n" . "Donnez un nom de session (ou aucun pour démarrer normalement) : "
        let sessionname = input(result)
        if sessionname != ""
            exe "source " . g:PathToSessions . sessionname . ".vim"
        endif
    endif
endfunction

function! VimLeave()
    exe "mksession! " . g:PathToSessions . "LastSession.vim"
    if exists("g:SessionFileName") == 1
        if g:SessionFileName != ""
            exe "mksession! " . g:SessionFileName
        endif
    endif
endfunction

" création d'une nouvelle session avec :SetSession "[nom]"
command! -nargs=1 SetSession   :let g:SessionFileName = g:PathToSessions . <args> . ".vim"
" suppression des sessions enregistrées avec :UnsetSession "[nom]"
" pour en supprimer une en particulier, à la main…
command! -nargs=0 UnsetSession :let g:SessionFileName = ""
" ouverture à la volée d'une session dont on connaît le nom
command! -nargs=1 OpenSession  :exe "source" . g:PathToSessions . <args> . ".vim"

" Sessions }}}

"nnoremap gf <C>

" http://vim.wikia.com/wiki/Display_shell_commands'_output_on_Vim_window
" Run a shell command and open results in a horizontal split
command! -complete=file -nargs=+ Split call s:RunShellCommandInSplit(<q-args>)
function! s:RunShellCommandInSplit(cmdline)
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1,a:cmdline)
  call setline(2,substitute(a:cmdline,'.','=','g'))
  execute 'silent $read !'.escape(a:cmdline,'%#')
  setlocal nomodifiable
  1
endfunction

" Copy of the above that opens results in a new tab.
command! -complete=file -nargs=+ Tab call s:RunShellCommandInTab(<q-args>)
function! s:RunShellCommandInTab(cmdline)
  tabnew
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1,a:cmdline)
  call setline(2,substitute(a:cmdline,'.','=','g'))
  execute 'silent $read !'.escape(a:cmdline,'%#')
  setlocal nomodifiable
  1
endfunction
" Issue a find command using regex and open results in a new tab.
command! -nargs=+ I call s:RunShellCommandInTab('find . -name *'.<q-args>.'*')

" vim: set foldmethod=marker nonumber:

