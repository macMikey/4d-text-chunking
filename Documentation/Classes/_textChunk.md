<!-- _textChunk is a class for parsing text -->

# class _textChunk



## Description

* Text routines for giving me more LC-ish chunk management
* Automatically tries to guess what the line-delimiter will be (`\r`, `\n`, or `\r\n`). You can override this, after you instantiate the object.
* Both items and words are assumed to terminate at the end of line.
* The text is not tokenized until a function is called. This allows you to instantiate and set properties like **lineDelimiter** or **itemDelimiter**, first
* Uses Base-1 indicies (1..n, not 0..n-1) - line 1 is the first line, not line 0.



## Constructor

| Parameter | Type | Required | Default | Description |
| -- | -- | -- | -- | -- |
| $text | Text | No | Null | The text that we are going to process |
| $trimString | Variant | No | Null | A string of characters to be stripped from the beginning and the end of each item.<br/>To handle classic .csv files, for example, set it to `\"` (which will strip the `"`from the beginning and ending of each text item returned. |



## Instantiation Examples



### Instantiate, using a text file

* Line deimiter will be automatically determined
* Item delimiter will default to `\t`
* Trim characters will be *Null*

```4d
	var $text : cs._textChunk
	$dataO:=cs._textChunk.new ( File($filename).getText() )
```



### Instantiate a **CLASSIC** .csv file (each item is surrounded in quotes, and items are separated by commas)

CSV files originally were of this format...

```
"line 1 item 1","line 1 item 2"
"line 2 item 1","line 2 item 2"
```
...instead of using a `\t` between the items

**textChunk** can handle this format like this:


```4d
	var $text : Text
	var $dataO : cs._textChunk
	$text := File($filename).getText()
	$dataO := cs._textChunk.new ( $text ; "\"" )
	$dataO.setItemDelimiter ( "," )
```



### Instantiate, assign values, afterwards

```4d
var $text : Text
var $dataO : cs._textChunk
$dataO:= cs._textChunk.new()
...
$dataO.setText ( $text )
$dataO.setLineDelimiter ( "\r\n" )
$dataO.setItemDelimiter ( "," )
$dataO.setTrimChars ( "/"" )
```



## Public Properties

None



## Public API



### getItemDelimiter() -> $delimiter : text

Returns the current item delimiter



### getItems() -> $items : collection

* Returns the current items as a collection
* The elements in the collection are not trimmed.



### getLineDelimiter() -> $delimiter : text

Returns the current line delimiter



### getText() -> $text : text

Returns the trimmed text of the object



### getTrimChars() -> $chars:text

Returns the current characters being used to trim the beginning and end of **strings** returned by calls to the object. Collections are not trimmed.



### item ( $number : text ) -> $valueOfItem : text

* Default delimiters are `\t` and the end-of-line delimiter
* Trims the text before returning it



### line ( $lineNumber : integer  ) -> $text : text

* Base 1

* Returns the trimmed text of line $lineNumber of the object



### lineItem ( $lineNumber : integer ; $itemNumber : integer ) -> $text : text

* Base 1
* Returns the trimmed text of item **$itemNumber** of line **$lineNumber**



### lineItems ( $lineNumber : integer ) -> $items : collection

* Returns the collection of tokenized items from line **$lineNumber**
* The collection is not trimmed before being returned.




### lineOffset ( $what : text { ; $wholeLine : boolean } ) -> $lineNumber : integer

* **$wholeLine** defaults to **True**
* Base 1
* Returns the line number that **$what** is/is on or **0**, otherwise



### numItems ( ) -> $count : integer

Returns the number of delimiter-separated items. There will always be at least one item, even if the delimiter is not present. If the delimiter is present, there will always be at least two items, even if the last item is blank.



### numLines () -> $count : integer

* Base 1

* Returns the number of lines in the text. This is always at least one line. **Blank/null final lines are counted**



### setItemDelimiter( $delimiter : text )

Sets the item delimiter



### setLineDelimiter ( $delimiter : text)

Sets the line delimiter



### setText ( $text : text )

* Sets the text of the object
* Marks the object as needing to be tokenized before the next operation that will return data



### setTrimChars ( $chars : text)

* Sets the string to be removed from the beggining and end of all text values returned by the object's functions.
* If a function returns a collection, the values inside the collection are not trimmed.

```4D
$trimChars := char(space) + char(double quote)
$dataO.setTrimChars ( $trimChars )
```



### trim( $what : text ) -> $trimmed : text

Removes 1..n **this.getTrimChars()** characters from the front and back of *$what*



### word ( $number : longint ) -> $word : text

* Returns word **$number** of the text, using space as the delimiter
* **$word** is trimmed, before being returned.



## Private Properties
name | datatype | description
--|--|--
._dirty | boolean | whether the object needs to be re-tokenized before use
._items | collection | the text separated into items
._itemDelimiter | text | the item delimiter
._lines | collection | collection of objects representing each line:<br>**.raw** (text): the raw text of the line ***untrimmed***<br>**.items** (collection): The items of the line 
._lineDelimiter | text | the current line delimiter
._rawText | text | the text
._trimChars | text | string of chars to be trimmed from text returned by the functions
._words | collection | the words of each line 



## Private API



### _tokenize()

* Creates the **this._lines** and **this._items** properties
