Mootes
======

Simple note taking inside vim. Nothing fancy, each note is just a markdown file
in a given directory, with the plugin just giving quick access and search
capabilities.

Usage
-----

-   `:M [noteName]` opens a vsplit for the note. If no name is given, opens the
    default `g:defaultNote`
-    `:Ml` lists notes
-    `:Mg search` searches in the notesnote
-    `:Mz` fuzzy searching using [vim-fzf](https://github.com/junegunn/fzf.vim)


Configuration
-------------

-   `g:defaultNote` to set the default note file (default is `scratch`)
-   `g:notesDir` to set the notes directory (default `~/notes`)
