" Maintainer: Sam DeFabbia-Kane (sam@defabbiakane.com)
" Last Change:	Dec 28 2009
" 
" loosely based on `wombat' by Lars H. Nielsen and the
" Notepad++ `Obsidian' theme.

set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "vimsidian"


" Vim >= 7.0 specific colors
if version >= 700
  hi CursorLine guibg=#2d2d2d
  hi CursorColumn guibg=#2d2d2d
  hi MatchParen guifg=#D2DD00 guibg=NONE gui=bold
  hi Pmenu 		guifg=#f6f3e8 guibg=#444444
  hi PmenuSel 	guifg=#000000 guibg=#cae682
endif

" General colors
hi Cursor 		guifg=NONE    guibg=#5A5A5A gui=none
hi Normal 		guifg=#C0C0C0 guibg=#2B2E2F gui=none
hi NonText 		guifg=#808080 guibg=#303030 gui=none
hi LineNr 		guifg=#857b6f guibg=#000000 gui=none
hi StatusLine 	guifg=#f6f3e8 guibg=#444444 gui=italic
hi StatusLineNC guifg=#857b6f guibg=#444444 gui=none
hi VertSplit 	guifg=#444444 guibg=#444444 gui=none
hi Folded 		guibg=#384048 guifg=#a0a8b0 gui=none
hi Title		guifg=#f6f3e8 guibg=NONE	gui=bold
hi Visual		guifg=#f6f3e8 guibg=#444444 gui=none
hi SpecialKey	guifg=#808080 guibg=#343434 gui=none

" Syntax highlighting
hi Comment 		guifg=#878376 gui=italic
hi Todo 		guifg=#8f8f8f gui=italic
hi Constant 	guifg=#e5786d gui=none
hi String 		guifg=#EC7600 gui=none
hi Identifier 	guifg=#B36EBF gui=none
hi Function 	guifg=#5A81A8 gui=bold
hi Type 		guifg=#A082BD gui=bold
hi Statement 	guifg=#93C763 gui=bold
hi Keyword		guifg=#93C763 gui=bold
hi PreProc 		guifg=#e5786d gui=none
hi Number		guifg=#EEC438 gui=bold
hi Special		guifg=#e7f6da gui=none


