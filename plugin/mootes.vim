" Vim plugin for simple note management
" Author: Diego Guerra <https://github.com/dgsuarez>
" License: www.opensource.org/licenses/bsd-license.php

if exists("loaded_mootes")
  finish
endif
let loaded_mootes = 1

let g:notesDir = '~/notes/'
let g:defaultNote = 'scratch'

function! s:Note(...)
  let note = a:0 ? a:1 : g:defaultNote
  let safeNote = substitute(note, ' ', '_', 'ge')
  let emptyWindow = bufname('%') == ''
  let hasSplits = winnr('$') > 1
  let openCommand = (emptyWindow ||  hasSplits) ? 'edit' : 'vsplit'

  execute openCommand . ' ' . g:notesDir . safeNote . '.md'

  if line('$') == 1 && getline(1) == ''
    call s:AddNoteTitle(note)
    normal jo
  end
endfunction

function! s:AddNoteTitle(note)
  call append(line('1'), '# ' . a:note)
  1s/_/ /ge
  1s/\<./\u&/ge
endfunction

function! s:NoteListCommand()
  return "ls -t " . g:notesDir . " | grep -v '.archived.md$' | sed 's/\.md$//'"
endfunction

function! s:NoteComplete(...)
  return system(s:NoteListCommand())
endfunction

function! s:COpenNoteList()
  let list = map(systemlist(s:NoteListCommand()), {_, p -> { 'text': p, 'filename': fnamemodify(g:notesDir . p . '.md', ':p:.')}})
  call setqflist(list)
  copen
endfunction

function! s:NoteGrep(...)
  let saved_shellpipe = &shellpipe
  let saved_wildignore = &wildignore
  let &shellpipe = '>'
  let &wildignore = saved_wildignore . ',*.archived.md'
  try
    execute('silent grep! ' . a:1 . ' ' . g:notesDir .'/*')
    copen
  finally
    let &shellpipe = saved_shellpipe
    let &saved_wildignore = saved_wildignore
  endtry
endfunction

function! s:NoteArchive()
  let full_file = expand("%")
  let archived_file = expand("%:r") . '.archived.md'

  system('mv ' . full_file . ' ' . archived_file)
  bdelete
endfunction

command! -nargs=? -complete=custom,s:NoteComplete M call s:Note(<f-args>)
command! -nargs=0 Ml call s:COpenNoteList()
command! -nargs=1 Mg call s:NoteGrep(<f-args>)
command! -nargs=0 Mz call execute('Files ' . g:notesDir)
command! -nargs=0 Marchive call s:NoteArchive()
