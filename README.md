# 4d-text-chunking



## Description

* Designed to be used as a component/submodule

* Text routines for giving me text chunk management (words, items, lines, and collections of those)

For example, if I want to manage a .csv/.tsv/.txt file (export from a db), the file will be composed of a number of records, terminated by a line-delimiter (typically `\r`, `\n`, or `\r\n`), and a column/item delimter, typically `\t`, or `,`.



* The class attempts to figure out what the line delimiter is
* All three types of chunks (lines, items, and words) terminate at a line-delimiter.

* Line and item delimiters can be manually set. The word delimiter is limited to the space character.

* Functions that return text will be trimmed
  * Trimming removes certain character strings from the beginning and ending of text
  * The trim string can be set by you
  * The trim string can be any number of characters
  * Example: If you set the trim string to double-quote, then `"test"` will be trimmed to `test`. This makes it easy to handle classic csv files, which are comma-delimited, and each "cell" is surrounded by double-quotes.



### See the class documentation for the API.



## Installation

1. I prefer submoduing this repo so updates to the code base trigger notifications in the repos that use it. I usually put them into a folder like **Submodules** in the parent project, or **Resources/Submodules**, etc. I do that because 4D does not like to have submodules directly in the **Components** folder, but it will be ok with having aliases/shortcuts in that folder.

2. Copy/Alias/Shortcut *4d-text-chunking.4dProject* to the parent project's **Components** folder.

   * The **Components** folder and the **Project** folder of the source database should be at the same level.

   * If this has worked, when you go into your parent project, in the 4D Explorer, you should see *4d-text-chunking* and its methods and classes in the **Component Methods** section.




## Notes

* The classes are available via the **cs.chunk** namespace.  Example: `$textO:=cs.chunk.text.new($text)`
