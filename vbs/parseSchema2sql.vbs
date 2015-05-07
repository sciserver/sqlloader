'==============================================================
' parse the .sql files in order to create a metadata table
' to be loaded into SQL Server
'--------------------------------------------------------------
' Object level markup tags:
'	--/H	one-line header
'	--/A	admin object, not visible to users
'	--/T	block of HTML description
' column level markup tags:
'	--/D	one-line description
'	--/U	units
'	--/K	UCD keywords
'	--/R	reference to enumerated
'
' all descriptions should be in HTML, no special characters
'--------------------------------------------------------------
' Alex Szalay, 06-22-01, Baltimore
' 2001-11-26 Alex: dropped coltype, added glossary key and header
' 2002-12-01 Alex: switched to SQL output to work around DTS 255 char bug
' 2013-08-16 Ani: Added HTML_Encode function and invoked it to escape
'                 special characters in column descriptions.
' 2013-10-23 Ani: Modified getName to ignore schema name in [] preceding
'                 object names.
'==============================================================
Option Explicit
'-----------------------------------------
Dim fso, rg
'
Set fso		= WScript.CreateObject("Scripting.FileSystemObject")
Set rg		= New RegExp
rg.IgnoreCase	= True
'----------------------------------------
Dim vbC, vbQ, vbW, Root, iDebug, schemaListFile
'
vbQ		= Chr(34)
vbW		= "','"
vbC		= vbQ & "," & vbQ
schemaListFile  = "xschema.txt"
Root		= fso.GetAbsolutePathName("..")
'
getArgs		' get command line arguments, like -d
'
'----------------------------------------
Dim vStream, tStream, hstream
Dim vCount, tCount, hCount
Dim state, group, head, text, access, mode, nlist, src, desc, dname, oldstate, totalcount
' 
'
Set vStream = fso.OpenTextFile(Root & "\schema\csv\loaddbviewcols.sql",2,True)
Set tStream = fso.OpenTextFile(Root & "\schema\csv\loaddbcolumns.sql",2,True)
Set hStream = fso.OpenTextFile(Root & "\schema\csv\loaddbobjects.sql",2,True)
'
totalcount	= 0
state		= 0
'
vCount		= 0
tCount		= 0
hCount		= 0
'
WriteHeaders
FindFiles ".sql"
WriteCounts
'
hStream.Close
tStream.Close
vStream.Close
'----------------------------------------
WScript.Echo totalcount & vbCrLf & tCount &"," & hCount & "," & vCount
'
WScript.Quit

'<<<<<<<<<<<<<<<<<<<<<<<<<<<End>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Public Sub WriteHeaders
Dim s, go, echo
	echo    = vbCrLf & "----------------------------- " & vbCrLf
	go = vbCrLf & "GO" & vbCrLf
	s = "SET NOCOUNT ON" & go & "TRUNCATE TABLE "

	' 
	hStream.WriteLine echo & "--  DBObjects.sql " & echo & s & "DBObjects " & go
	tStream.WriteLine echo & "--  DBColumns.sql " & echo & s & "DBColumns " & go
	vStream.WriteLine echo & "--  DBViewcols.sql" & echo & s & "DBViewcols" & go
	'
End Sub

Public Sub WriteCounts
Dim echo,go
	go = vbCrLf & "GO" & vbCrLf
	echo    = "----------------------------- " & vbCrLf
	'
	hStream.WriteLine go & echo & "PRINT '" & hCount & " lines inserted into DBObjects '" & vbCrLf & echo 
	tStream.WriteLine go & echo & "PRINT '" & tCount & " lines inserted into DBColumns '" & vbCrLf & echo 
	vStream.WriteLine go & echo & "PRINT '" & vCount & " lines inserted into DBViewcols'" & vbCrLf & echo 
	'
End Sub

Public Sub FindFiles (filter)
	Dim f, m, match
	'	
	If Not fso.FolderExists(Root) Then Fatal "Cannot find " & Root
	'
	'For Each f In fso.GetFolder(Root & "\schema\sql").Files
	'	rg.Pattern = filter
	'	For Each m in rg.Execute(f.Name)
	'		If getExt(f) = "sql" Then parseFile f
	'	Next		
	'Next

	Const ForReading = 1
	Dim schemaFiles, fName, comment
	Set schemaFiles = fso.OpenTextFile(Root & "\schema\sql\" & schemaListFile, ForReading)
	WScript.Echo schemaListFile

	Do Until schemaFiles.AtEndOfStream
	    rg.Pattern = "^--*"
	    fName = schemaFiles.Readline
	    If rg.Test(fName) Then
		comment = fName
	    Else
		rg.Pattern = ".sql"
		If rg.Test(fName) Then
			Set f = fso.GetFile(Root & "\schema\sql\" & fName)
			parseFile f
		End If
	    End If
	Loop
	'	
End Sub


Public Sub parseFile (f)
	Dim inStream
	'
	Set inStream = fso.OpenTextFile(f.Path)
	Debug "<" & f.Name & ">"
	state	= 0
	mode	= 0
	group	= ""
	Do While Not (inStream.atEndOfStream)
		parseLine inStream.ReadLine
	Loop				
	inStream.Close	
End Sub



Public Sub parseLine (buf)
	'----------------------------------------
	'  state = 0	open
	'  state = 1	comment
	'  state = 2    table
	'  state = 4    view
	'  state = 6	function
	'  state = 8	procedure
	'----------------------------------------
	'WScript.Echo buf
	'WScript.Echo "<" & state & "," & mode & "> ###" & buf & "###"
	'
	totalcount= totalcount+1
	'
	cleanLine buf
	if state=0 then isCreate buf
	'
	if len(buf)=0 then exit sub
	'
	if state=2 then inTable buf
	if state=4 then inView buf
	if state=6 then inFunc buf
	if state=8 then inFunc buf
	'
End Sub


Public Sub isCreate(buf)
Dim t
	'
	rg.Pattern = "CREATE "
	If rg.Test(buf) Then
		Debug "<<" & state & "|" & buf & ">>"
		buf	 = rg.Replace(buf,"")
		'
		t	 = UCase(getName(buf))
		'
		If t = "TABLE"		Then state = 2
		If t = "VIEW"		Then state = 4
		If t = "FUNCTION"	Then state = 6
		If t = "PROCEDURE"	Then state = 8
		'	
		group	= getName(buf)
		'
		' ignore temp tables, inside PROCEDUREs
		'
		rg.Pattern = "#"
		If rg.Test(group) Then
			state = 0
			Exit Sub
		End If
		'
		buf		= ""
		head	= ""
		text	= ""
		nlist	= ""
		access  = "U"
	End If
End Sub


Public Sub cleanLine(buf)
Dim matches, m
	'----------------------------------------
	' will clean the file of comments
	' but it is watching for the table/view description
	'----------------------------------------
	'
	' replace text inside /*...*/, then look for /* and */
	'
	if (state and 1) = 1 then
		inComment buf
	else
		rg.Pattern = "/\*.+\*/"
		buf = rg.Replace(buf,"") 
		buf = isBeginComment(buf)
	end if
	'
	' get rid of whitespace at the beginning
	'
	rg.Pattern = "^\s*"
	buf = rg.Replace(buf,"")
	'
End Sub

'--------------< inX subs >----------------------------
Public Function HTML_Encode(byVal string)
	Dim tmp, i 
	tmp = string
	tmp = Replace(tmp, "&", "&amp;")
	tmp = Replace(tmp, "<", "&lt;")
	tmp = Replace(tmp, ">", "&gt;")
	HTML_Encode = tmp
End Function


Public Sub inTable(buf)
    Dim name, dtype, desc, ucd, unit, echo, matches, refs, rank
    Dim rsx
	Set rsx = New RegExp
	rsx.Pattern = "'"
	rsx.Global  = true

	'
	' we are inside a table
	'
	If left(buf,1) = ")" Then 
		endGroup buf
		Exit Sub
	End If
	'
	If inHead(buf) Then Exit Sub
	'
	If mid(buf,1,2) = "--" Then buf = "": Exit Sub
	'
	name  = getName(buf)
	'
	' ignore the following commands, if any
	'
	if UCase(name) = "CONSTRAINT" then exit sub
	if UCase(name) = "PRIMARY" then exit sub
	if UCase(name) = "ON" then exit sub
	'
	' get the remaining items
	'
	dtype	= rsx.Replace(getNext(buf),"''")
	desc	= rsx.Replace(getTag(buf,"--/D"),"''")
	unit	= rsx.Replace(getTag(buf,"--/U"),"''")
	refs	= rsx.Replace(getTag(buf,"--/R"),"''")
	ucd 	= rsx.Replace(getTag(buf,"--/K"),"''")
	rank    = 0
	'
	' escape special characters for HTML output
	'
	desc = HTML_Encode( desc )
	'
	' enclose everything in quotation marks for safety
	'
	echo 	= "INSERT DBColumns VALUES('"
	echo	= echo & group & vbW & name & vbW & unit & vbW
	echo	= echo & ucd & vbW & refs & vbW & desc & vbW & rank
	echo = echo & "');"
	'
	tCount = tCount+1
	tStream.WriteLine echo
	'
End Sub


Public Sub inView(buf)
	'
	If inHead(buf) Then buf = "": Exit Sub
	If mid(buf,1,2) = "--" Then buf = "": Exit Sub
	'
	rg.Pattern = "GO.*"
	If rg.Test(buf) Then
		buf = rg.Replace(buf,"")
		nlist = nlist & " " & buf	
		endView nlist
	End If
	rg.Pattern = ".* AS "
	If rg.Test(buf) Then
		buf = rg.Replace(buf,"")
	End If
	nlist = nlist & " " & buf
End Sub


Public Sub endView (str)
Dim matches,m
	endGroup ""
	rg.Pattern = "WHERE .*"
	str = rg.Replace(str,"")
	'
	' find the from clause
	'
	rg.Pattern = "[ \t]+WITH[ \t]*\(NOLOCK\)"
	str = rg.Replace(str,"")
	rg.Pattern = "FROM .*"
	If Not rg.Test(str) Then	Exit Sub
	Set matches = rg.Execute(str)
	For each m in matches
		src = m
	Next
	str = rg.Replace(str,"")
	'	
	rg.Pattern = "FROM "
	src = rg.Replace(src,"")
	'
	rg.Pattern = "SELECT[ \t]+.*"
	Set matches = rg.Execute(str)
	For each m in matches
		str = m
	Next
	rg.Pattern = "SELECT[ \t]"
	nlist = rg.Replace(str,"")
	endofView
End Sub


Public Function inHead(buf)
	'
	inHead = False
	'
	rg.Pattern = "--/A"
	if rg.Test(buf) Then 
		buf = rg.Replace(buf,"")
		checkQuote buf
		access = "A"
		inHead = True
	End If
	'
	rg.Pattern = "--/H"
	if rg.Test(buf) Then 
		buf = rg.Replace(buf,"")
		checkQuote buf
		head  = head & buf & " "
		inHead = True
	End If
	'
	rg.Pattern = "--/T"
	if rg.Test(buf) Then 
		buf = rg.Replace(buf,"")
		checkQuote buf
		text  = text & buf & " "
		inHead = True
	End If
	
	'
End Function


Public Sub checkQuote(buf)
	'
	' change any occurence of the quotation mark
	'
	rg.Pattern = vbQ
	rg.Global  = true
		buf = rg.Replace(buf,"'")
  	rg.Global  = false
End Sub


Public Sub inFunc(buf)
	'
	' inside a FUNC or PROC
	'
	If inHead(buf) Then Exit Sub
	'
	rg.Pattern = "^GO$"
	If rg.Test(buf) Then
		Debug ">>>>>" & buf
		endGroup buf
		Exit Sub
	End If
'	rg.Pattern = "AS"
'	If rg.Test(buf) Then
'		endGroup buf
'		Exit Sub
'	End If
'	rg.Pattern = "RETURN"
'	If rg.Test(buf) Then
'		endGroup buf
'		Exit Sub
'	End If
End Sub


Public Sub endGroup(buf)
Dim otype, echo
Dim rsx
Dim rank
	Set rsx = New RegExp
	rsx.Pattern = "'"
	rsx.Global  = true

	If state = 2 Then otype = "U"
	If state = 4 Then otype = "V"
	If state = 6 Then otype = "F"
	If state = 8 Then otype = "P"	
	state = 0
	mode  = 0
	rank  = 0
	buf   = ""
	'
	head  = rsx.Replace(head,"''")
	text  = rsx.Replace(text,"''")
	'
	echo  = "INSERT DBObjects VALUES('"
	echo  = echo & group & vbW & otype & vbW 
	echo  = echo & access & vbW & head  & vbW 
	echo  = echo & text & vbW & rank & "');"
	'
	hStream.WriteLine echo
	hCount = hCount+1
	'
	Debug "  " & group & " : " & otype
End Sub


Public Sub inComment(buf)
Dim matches, m, i
	'
	' ignore the stuff inside a comment
	'
	rg.Pattern = "\*/"
	Set matches = rg.Execute(buf)
	For Each m in matches
		state = oldstate
		i = m.firstindex
		buf = ""
	Next
End Sub


Public Sub endOfView
Dim names, n, s1, s2
	'
	' end of view, print attribute list if any
	'
	s1 = "INSERT DBViewCols VALUES('"
	s2 = "');"
	'
	names = Split(nlist,",",-1,1)
	for n=LBound(names) to Ubound(names)
		vStream.WriteLine s1 & getName(names(n)) & vbW & group & vbW & src & s2
		vCount = vCount+1
	next
End Sub


Public Function isBeginComment(buf)
Dim matches, m, i
	isBeginComment = ""
	rg.Pattern = "/\*"
	Set matches = rg.Execute(buf)
	i = len(buf)
	For Each m in matches
		oldstate = state
		state = 1
		i = m.firstindex
		exit for
	Next
	isBeginComment = mid(buf,1,i)
End Function


'---------------<  Utilities >-------------


Public Function getName(buf)
Dim name
	name		= getNext(buf)
	rg.Pattern	= "\[.*\]\."
	name		= rg.Replace(name,"")
	rg.Pattern	= "\["
	name		= rg.Replace(name,"")
	rg.Pattern	= "\]"
	name		= rg.Replace(name,"")
	rg.Pattern	="\("
	name		= rg.Replace(name,"")
	rg.Pattern	="\)"
	name		= rg.Replace(name,"")
	rg.Pattern	="\@.*"
	name		= rg.Replace(name,"")
	getName		= name
	'
End Function


Public Function getNext(buf)
Dim matches, m, name
	'--------------------------------
	' get the next word from buf
	'--------------------------------
	rg.Pattern = "([^, \f\t\n\r\v]+)"
	set matches = rg.Execute(buf)
	for each m in matches
		name = m.Value
	next
	rg.Pattern = "(\S+)(\s+)"
	buf = rg.Replace(buf,"")
	getNext = name
End Function


Public Function getEtc(buf)
Dim matches, m, name
	rg.Pattern = "(\s*),"
	buf = rg.Replace(buf,"")
	rg.Pattern = "\s*$"
	getEtc = rg.Replace(buf,"")
End Function


Public Function getEsc(buf,esc)
Dim matches, m, txt
	'
	' Return text following the pattern 
	' The text is removed from the end
	'
	rg.Pattern = esc & ".*"
	set matches = rg.Execute(buf)
	for each m in matches
		txt = m.Value
	next
	buf = rg.Replace(buf,"")
	rg.Pattern = esc
	getEsc = rg.Replace(txt,"")
End Function


Public Function getTag(buf,tag)
Dim matches, m, txt
	'
	' Return text matching the tag.
	'
	rg.Pattern = tag & ".*"
	Set matches = rg.Execute(buf)
	For Each m In matches
		txt = m.Value
	Next
	'
	rg.Pattern = tag & "\s"
	txt = rg.Replace(txt,"")
	'
	rg.Pattern = "\s*--/.*"
	txt = rg.Replace(txt,"")
	'
	rg.Pattern = "\s*$"
	txt = rg.Replace(txt,"")
	'
	rg.Pattern = "^\s*"
	txt = rg.Replace(txt,"")
	'
	getTag = txt
End Function


Public Sub Warning(msg)
    WScript.Echo run & ": " & msg    
End Sub


Public Sub Debug(msg)
	If iDebug <> 0 Then WScript.Echo msg
End Sub


Public Sub Fatal(msg)
	WScript.Echo "FATAL ERROR: " & msg
	WScript.Quit
End Sub


Public Function getExt(f)
	getExt  = LCase(Right(f.Name,Len(f.Name)-InStrRev(f.Name,".")))					
End Function


Public Sub GetArgs ()
'------------------------------------------------
' set iDebug from the command line
'------------------------------------------------
	Dim argv
	iDebug  = 0
	rg.Pattern = "-d"
	For Each argv In WScript.Arguments
		If rg.Test(Lcase(argv)) Then 
			iDebug = 1
		Else
			schemaListFile = argv
		End If
	Next
End Sub
