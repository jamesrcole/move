

":those associated with jumping to indent parent

" jump the cursor to the parent of the current line, based on indentation.
" this line is the line that starts with a number of chars of whitespace
" between 0 and (currAmount - 1) 
" new version supporting a count
" and also displays number of lines jumped
function! JumpToIndentParent()
    execute "normal m'"
    let origLineNum = getpos(".")[1]
    for i in range(1, v:count1)
        let currLine = getline(".")
        let indentAmt = strlen( matchstr( currLine, "^\\s\\+") ) - 1
        if indentAmt < 0
            let indentAmt = 0
        endif
        let parentHeadingSearchPat = "^ \\{0," . indentAmt . "\\}\\S"
        " the e flag (end of match) will put cursor on 
        " 1st non-whitespace char on tt line
        call search(parentHeadingSearchPat, "bWe")
    endfor
    let newLineNum = getpos(".")[1]
    let diff = origLineNum - newLineNum
    redraw   " so the following echo isn't overwritten by scrolling
    echo( diff . " line" . SOnPlural(diff) . " up")
endfunction
nnoremap <C-U> :<C-U>call JumpToIndentParent()<CR>
onoremap <C-U> :<C-U>call JumpToIndentParent()<CR>

function! V_JumpToIndentParent()
    normal! gv
    call JumpToIndentParent()
endfunction
vnoremap <C-U> :<C-U>call V_JumpToIndentParent()<CR>




":those associated w/ jumping to the next non-child item 

" jump cursor to next non-whitespace line with 
" same or lesser amount of indenting as present line
function! JumpToNextNonChildItem()    
    execute "mark '" 
    let origLineNum = getpos(".")[1]
    for i in range(1, v:count1)
        let currLine = getline(".")
        let indentAmt = strlen( matchstr( currLine, "^\\s\\+") )
        let parentHeadingSearchPat = "^ \\{0," . indentAmt . "\\}\\S"
        " the e flag (end of match) will put cursor on 
        " 1st non-whitespace char on tt line
        call search(parentHeadingSearchPat, "We")
    endfor
    let newLineNum = getpos(".")[1]
    let diff = newLineNum - origLineNum
    redraw   " so the following echo isn't overwritten by scrolling
    echo( diff . " line" . SOnPlural(diff) . " down")
endfunction
nnoremap <C-N> :<C-U>call JumpToNextNonChildItem()<CR>
onoremap <C-N> :<C-U>call JumpToNextNonChildItem()<CR>


function! V_JumpToNextNonChildItem()
    normal! gv
    call JumpToNextNonChildItem()
endfunction
vnoremap <C-N> :<C-U>call V_JumpToNextNonChildItem()<CR>




":bring the destination of a movement comamnd to the top of the screen


nmap <silent> ,t :set opfunc=Top<CR>g@

" see 'help map-operator'
" 
" note that this doesn't work quite right!
"
"      if you type ",t5j" it seems to ignore the count.
"
"      and sometimes that <C-E> is necess, othertimes not!
"
"           like it is if the movement command is /<patt>
"           but it's not if it's 2/<patt>
"
"   ...might also check whether setting selection to inclusive fixes the
"   issue...
"
" also, check to see if it needs the param list it has...
"
" it helps in understanding the following to know that
"
"  '[ is the start (in doc order) pos
"  '] is the last (in doc order) pos
"
" (i.e. the 'start' and 'end' is not relative the cursor's starting
"   position)
function! Top(type, ...)
   let origLinePos = getpos("''")[1]
   let targetBelowCursorPos = ( origLinePos == getpos("'[")[1] )
   if targetBelowCursorPos
       let targetPos = getpos("']")
   else
       let targetPos = getpos("'[")
   endif
   call setpos(".", targetPos)
   normal! zt
   if targetBelowCursorPos
       exec "normal! \<C-E>"
   endif
endfunction





":'frozen-cursor' scrolling


if has("win16") || has("win32") || has("win64")|| has("win95")
    unmap <C-y>
    " ^ give C-Y its 'orig' behavior of scrolling down 1 line
endif
map <A-k> <C-Y>
noremap <A-k> <C-Y>k
map <C-Y> <C-R>       " this makes C-Y redo again,
noremap <A-j> <C-E>j



