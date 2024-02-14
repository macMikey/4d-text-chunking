# 4d-text-chunking



## Description

Text routines for giving me text chunk management

For example, if I want to manage a .csv/.tsv/.txt file (export from a db), the file will be composed of a number of records, terminated by a line-delimiter (typically `\r`, `\n`, or `\r\n`), and a column/item delimter, typically `\t`, or `,`.

This repo will allow me to easily tokenize that text, into lines, items, and words, so that I can iterate over them.



All three types (lines, items, and words) terminate at a line-ending.

Line and item delimiters can be manually set. The word delimiter is limited to the space character.

By default, lines/items/words will be trimmed of beginning or trailing characters whitespace (whitespace can be set/overridden, too).

See the class documentation for the API.
