Class constructor($text : Text; $trimChars : Variant)
	This.setText($text)
	This.setItemDelimiter("\t")
	
	
	Case of 
		: (Is macOS)
			$lineDelimiter:="\n"
		: (Is Windows)
			$lineDelimiter:="\r\n"
		Else 
			TRACE
			ALERT("Platform unknown.")
			ABORT
	End case 
	This.setLineDelimiter($lineDelimiter)
	This.setTrimChars($trimChars)
	// ===============================================================================================================
	
	
/*
===============================================================================================================
=                                                                                                             = 
=                                          P U B L I C    A P I                                               = 
=                                                                                                             = 
===============================================================================================================
*/
	
	
	
Function getItemDelimiter()->$delimiter : Text
	return This._getItemDelimiter()
	// _______________________________________________________________________________________________________________
	
	
	
Function getItems()->$items : Collection
	return This._getItems()
	// _______________________________________________________________________________________________________________
	
	
	
Function getLineDelimiter()->$delimiter : Text
	return This._getLineDelimiter()
	// _______________________________________________________________________________________________________________
	
	
	
Function getText()->$text : Text
	return This.trim(This._getText())
	// _______________________________________________________________________________________________________________
	
	
	
Function getTrimChars()->$text : Text
	return This._getTrimChars()
	// _______________________________________________________________________________________________________________
	
	
	
Function item($itemNumber : Integer)->$item : Text
	return This.trim(This._getItem($itemNumber))
	// _______________________________________________________________________________________________________________
	
	
	
Function itemOffset($text : Text; $wholeItem : Variant)->$offset : Integer
	If (Undefined($wholeItem))
		$wholeItem:=True
	End if 
	
	$offset:=0
	For ($i; 1; This.numItems())
		$item:=This.item($i)
		
		If (($item=$text) || (Not($wholeItem) & (Position($text; $item)>0)))
			return $i
		End if   //(This.item($i)=$text)
	End for   //($i; 1; This.numItems())
	// _______________________________________________________________________________________________________________
	
	
	
Function items()->$items : Collection
	return This._getItems()
	// _______________________________________________________________________________________________________________
	
	
	
Function line($lineNumber : Integer)->$line : Text
	return This.trim(This._getLine($lineNumber))
	// _______________________________________________________________________________________________________________
	
	
	
Function lineItem($lineNumber : Integer; $itemNumber : Integer) : Text
	var $lineC : Collection
	
	$lineC:=This.lineItems($lineNumber)
	return This.trim($lineC[($itemNumber-1)])
	// _______________________________________________________________________________________________________________
	
	
	
Function lineItems($lineNumber : Integer) : Collection
	return This._getLineItems($lineNumber)
	// _______________________________________________________________________________________________________________
	
	
	
	
Function lineOffset($what : Text; $wholeLine : Variant)->$offset : Integer
	If (Undefined($wholeLine))
		$wholeLine:=True
	End if 
	
	$offset:=0
	For ($i; 1; This.numLines())
		$theLine:=This.line($i)
		If (($theLine=$what) || (Not($wholeLine) & (Position($what; $theLine)>0)))  // if we match the entire line or if we don't care if we match the entire line and we are on the line
			return $i
		End if   //(($theLine=$what) | (Not($wholeLine) & (position ($what;$theLine)>0)))
	End for   // ($i;1;this.NumLines())
	// _______________________________________________________________________________________________________________
	
	
	
Function numItems()->$numItems : Integer
	return This._getNumItems()
	// _______________________________________________________________________________________________________________
	
	
	
Function numLines()->$numLines : Integer
	return This._getNumLines()
	// _______________________________________________________________________________________________________________
	
	
	
Function setItemDelimiter($what : Text)
	This._setItemDelimiter($what)
	// _______________________________________________________________________________________________________________
	
	
	
Function setLineDelimiter($what : Text)
	This._setLineDelimiter($what)
	// _______________________________________________________________________________________________________________
	
	
	
Function setText($what : Text)
	This._setText($what)
	// _______________________________________________________________________________________________________________
	
	
	
Function setTrimChars($what : Text)
	This._setTrimChars($what)
	// _______________________________________________________________________________________________________________
	
	
	
Function trim($what : Text)->$trimmed : Text
	$ofWhat:=This._getTrimChars()
	
	While (Length($what)>0 && (Position($what[[1]]; $ofWhat)>0))
		$what:=Substring($what; 2; Length($what))
	End while 
	
	While (Length($what)>0 && (Position($what[[Length($what)]]; $ofWhat)>0))
		$what:=Substring($what; 1; (Length($what)-1))
	End while 
	
	return $what
	// _______________________________________________________________________________________________________________
	
	
Function word($number : Integer)->$word : Text
	return This.trim(This._getWord($number))
	// _______________________________________________________________________________________________________________
	
	
	
/*
================================================================================================================
=                                                                                                             = 	
=                                           P R I V A T E    A P I                                            = 
=                                                                                                             = 
 ===============================================================================================================
*/
	
	
	
Function _tokenize($retokenize : Variant)
	
	var $progressBoxEnabled : Boolean
	var $progressBoxID; $counter; $numLines : Integer
	var $lineDelimiter; $itemDelimiter; $line : Text
	var $linesC; $itemsC; $wordsC : Collection
	var $lineObject : Object
	
	//<skip tokenizing if not told to redo it AND we have already tokenized>
	If (Undefined($retokenize))
		$retokenize:=True
	End if 
	
	If (Not($retokenize) & (This._lines#Null))
		return 
	End if 
	//</skip tokenizing if not told to redo it AND we have already tokenized>
	
	This._lines:=New collection()
	This._items:=New collection()
	This._words:=New collection()
	
	$lineDelimiter:=This._getLineDelimiter()
	$itemDelimiter:=This._getItemDelimiter()
	
	$rawText:=This._getText()
	
	
	
	//<apply the line and item splits>
	$linesC:=Split string($rawText; $lineDelimiter)
	$numLines:=$linesC.length
	$progressBoxEnabled:=($numLines>1000)
	If ($progressBoxEnabled)
		$progressBoxID:=Progress New()
		Progress SET TITLE($progressBoxID; "Tokenizing...")
		Progress SET BUTTON TITLE($progressBoxID; "Cancel")
		Progress SET BUTTON ENABLED($progressBoxID; True)
		Progress SET PROGRESS($progressBoxID; -1)
		$counter:=0
	End if   //$progressBoxEnabled
	For each ($line; $linesC)
		If ($progressBoxEnabled)
			$counter+=1
			Case of 
				: (Progress Stopped($progressBoxID))
					Progress QUIT($progressBoxID)
					This._setDirty(True)  // undo any work we've already done in tokenizing the data so we don't wind up with partially-tokenized data
					This._lines:=New collection()
					This._items:=New collection()
					This._words:=New collection()
					return Null
				: (($counter%100)=0)
					Progress SET PROGRESS($progressBoxID; ($counter/$numLines))
					Progress SET MESSAGE($progressBoxID; "On line "+String($counter; "###,##0")+" / "+String($numLines; "###,##0"))
			End case 
		End if   //$progressBoxEnabled
		$lineObject:=New object("raw"; $line; "items"; Null)
		$itemsC:=Split string($line; $itemDelimiter)
		$wordsC:=Split string($line; " ")
		$lineObject.items:=$itemsC
		$lineObject.words:=$wordsC
		This._lines.push($lineObject)
	End for each   //($line;$linesC)
	//</apply the line and item splits>
	If ($progressBoxEnabled)
		Progress QUIT($progressBoxID)
	End if   //progressBoxEnabled
	This._setDirty(False)
	// _______________________________________________________________________________________________________________
	
	
	
/*
===============================================================================================================
=                                                                                                             = 
=                                     P R I V A T E    G E T T E R S                                          = 
=                                                                                                             = 
===============================================================================================================
*/
	
	
	
Function _getDirty()->$dirty : Boolean
	return This._dirty
	// _______________________________________________________________________________________________________________
	
	
	
Function _getItemDelimiter()->$delimiter : Text
	return This._itemDelimiter
	// _______________________________________________________________________________________________________________
	
	
	
Function _getItem($itemNumber : Integer)->$item : Text
	$itemNumber:=($itemNumber || 1)-1  // working on a collection
	This._tokenize(This._getDirty())
	If ($itemNumber>(This._items.length-1))
		return Null
	End if 
	return This._items[$itemNumber]
	// _______________________________________________________________________________________________________________
	
	
	
Function _getItems()->$items : Collection
	This._tokenize(This._getDirty())
	return This._items
	// _______________________________________________________________________________________________________________
	
	
	
Function _getLine($lineNumber : Integer) : Variant
	$lineNumber:=($lineNumber || 1)-1  // working on a collection
	This._tokenize(This._getDirty())
	If ($lineNumber>(This._lines.length-1))
		return Null
	End if 
	return This._lines[$lineNumber].raw
	// _______________________________________________________________________________________________________________
	
	
	
Function _getLineDelimiter()->$delimiter : Text
	return This._lineDelimiter
	// _______________________________________________________________________________________________________________
	
	
	
Function _getLineItems($lineNumber : Integer) : Collection
	$lineNumber:=($lineNumber || 1)-1  // working on a collection
	This._tokenize(This._getDirty())
	If ($lineNumber>(This._lines.length-1))
		return Null
	End if 
	return This._lines[$lineNumber].items
	// _______________________________________________________________________________________________________________
	
	
	
Function _getNumItems()->$numItems : Integer
	This._tokenize(This._getDirty())
	return This._items.length
	// _______________________________________________________________________________________________________________
	
	
	
Function _getNumLines()->$numLines : Integer
	// don't tokenize a large file, since we're returning text, not a line object
	
	This._tokenize(This._getDirty())
	return This._lines.length
	// _______________________________________________________________________________________________________________
	
	
	
Function _getText()->$text : Text
	return This._rawText
	// _______________________________________________________________________________________________________________
	
	
	
Function _getTrimChars()->$chars : Text
	return This._trimChars
	// _______________________________________________________________________________________________________________
	
	
	
Function _getWord($wordNumber)->$word : Text
	$wordNumber:=$wordNumber || 1
	This._tokenize(This._getDirty())
	$wordNumber-=1
	If ($wordNumber>(This._words.length-1))
		return Null
	End if 
	return This._words[$wordNumber]
	// _______________________________________________________________________________________________________________
	
	
	
/* 
===============================================================================================================
=                                                                                                             = 
=                                     P R I V A T E    S E T T E R S                                          = 
=                                                                                                             = 
===============================================================================================================
*/
	
	
	
Function _setDirty($bool : Variant)
	If (Undefined($bool))
		$bool:=True
	End if 
	This._dirty:=$bool
	If ($bool)
		This._lines:=New collection()
		This._items:=New collection()
		This._words:=New collection()
	End if   //$bool
	// _______________________________________________________________________________________________________________
	
	
	
Function _setItemDelimiter($delimiter : Text)
	If (This._itemDelimiter=Null) || (This._itemDelimiter#$delimiter)
		This._itemDelimiter:=$delimiter
		This._setDirty()
	End if 
	// _______________________________________________________________________________________________________________
	
	
	
Function _setLineDelimiter($delimiter : Text)
	If (This._lineDelimiter=Null) || (This._lineDelimiter#$delimiter)
		This._lineDelimiter:=$delimiter
		This._setDirty()
	End if 
	// _______________________________________________________________________________________________________________
	
	
Function _setText($text : Text)
	This._rawText:=$text
	This._setDirty()
	// _______________________________________________________________________________________________________________
	
	
	
Function _setTrimChars($chars : Text)
	$chars:=$chars || ""
	This._trimChars:=$chars