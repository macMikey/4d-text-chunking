# 4d-text-chunking version history



## 1.1.2 24.02.16

* Fix bug in _tokenize



## 1.1.1 24.02.14

### Convert to Component

* rename

* update docs

* fix .gitignore

  

## 1.1.0 24.02.14

* first public version

* docs updated

* redone with .**split** for speed, removed recursion

* added progress boxes, because big files take big time

* added **lineItems()**

* add **lineItem()**

* switch item delimiter from comma to tab

* all functions that return text trim the text, first. all functions that return collections return them, untrimmed

* so the devs can deal with collections (which are untrimmed), easier, make **trim** part of the public api

* change **line**'s return value from an object to (trimmed) text

  