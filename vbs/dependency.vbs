'==============================================================
' parse the .sql files in order to create a dependency tree
'--------------------------------------------------------------
' Alex Szalay, 06-22-01, Baltimore
' 2001-11-26 Alex: dropped coltype, added glossary key and header
' 2004-02-10 Alex: modified to find function dependencies
' 2006-12-21 Ani: Added CL param schemaListFile and made list of
'                 schema files readable from that.
'==============================================================
Option Explicit
'-----------------------------------------
Dim fso, rg, rx, rw, rq
'
Set fso		= WScript.CreateObject("Scripting.FileSystemObject")
Set rg		= New RegExp
Set rx		= New RegExp
Set rw		= New RegExp
Set rq		= New RegExp
rg.IgnoreCase	= True
rx.IgnoreCase	= True
rq.IgnoreCase	= True
rw.IgnoreCase 	= True
rw.Global	= True
rq.Global	= True
'----------------------------------------
Dim vbQ, vbC, vbW, Root, iDebug, schemaListFile
'
vbW			= "','"
vbQ			= Chr(34)
vbC			= vbQ & "," & vbQ
Root		= fso.GetAbsolutePathName("..\schema")
schemaListFile  = "xschema.txt"
'
getArgs		' get command line arguments, like -d
'
'----------------------------------------
Dim hStream, iStream, dStream
Dim state, group, head, text, access, mode, nlist, hist, when, who
Dim src, desc, dname, oldstate, totalcount, fname, oldname
'
Set dStream = fso.OpenTextFile(Root & "\csv\d1.sql",2,True)
Set iStream = fso.OpenTextFile(Root & "\csv\loadinventory.sql",2,True)
Set hStream = fso.OpenTextFile(Root & "\csv\loadhistory.sql",2,True)
'
Dim s1,s2,s3, icount, hcount
s1 = "-----------------------------" & vbCrLf & "--  "
s2 = ".sql" & vbCrLf & "-----------------------------" & vbCrLf
s2 = s2 & "SET NOCOUNT ON" & vbCrLf & "GO" & vbCrLf & "TRUNCATE TABLE "
s3 = vbCrLf & "GO" & vbCrLf & "--" & vbCrLf & vbCrLf
'
iStream.Write s1 + "Inventory" & s2 & "Inventory" & s3
hStream.Write s1 + "History" & s2 & "History" & s3
'
totalcount	= 0
icount	= 0
hcount	= 0
state		= 0
when		= ""
oldname	= ""
FindFiles ".sql"
'
s1 = "GO" & vbCrLf & vbCrLf & "------------------------------------" & vbCrLf &  "PRINT '"
s2 = vbCrLf & "------------------------------------" & vbCrLf & "GO" & vbCrLf

iStream.Write  s1 & icount & " lines inserted into Inventory'" & s2
hStream.Write  s1 & hcount & " lines inserted into History'" & s2

hStream.Close
iStream.Close
dStream.Close
'----------------------------------------
WScript.Echo "dependency.vbs has scanned " & totalcount & " lines" & vbCrLf
'
WScript.Quit

'<<<<<<<<<<<<<<<<<<<<<<<<<<<End>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

Public Sub FindFiles (filter)
	Dim f, m, match
	'	
	If Not fso.FolderExists(Root) Then Fatal "Cannot find " & Root
	'
'	For Each f In fso.GetFolder(Root & "\sql").Files
'	For Each f In fso.GetFolder(Root & "\tmp").Files
	'	rg.Pattern = filter
	'	For Each m in rg.Execute(f.Name)
	'		If getExt(f) = "sql" Then parseFile f
	'	Next		
'	Next
	Const ForReading = 1
	Dim schemaFiles, fName, comment
	Set schemaFiles = fso.OpenTextFile(Root & "\sql\" & schemaListFile, ForReading)
	'WScript.Echo schemaListFile

	Do Until schemaFiles.AtEndOfStream
	    rg.Pattern = "^--*"
	    fName = schemaFiles.Readline
	    If rg.Test(fName) Then
		comment = fName
	    Else
		rg.Pattern = ".sql"
		If rg.Test(fName) Then
			Set f = fso.GetFile(Root & "\sql\" & fName)
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
	rw.Pattern = "(^sp?:[^e])|(\.sql$)"
	fname = rw.Replace(f.Name,"")

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
	'  state = 2	table
	'  state = 4	view
	'  state = 6	function
	'  state = 8	procedure
	'----------------------------------------
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
	' look for --* denoting history line
	'
	rg.Pattern = "^--\*\s+"
	If rg.Test(buf) Then
	    isHistory buf
	End If
	'
	' get rid of whitespace at the beginning
	'
	rg.Pattern = "^\s*"
	buf = rg.Replace(buf,"")
	'
End Sub


Public Sub checkQuote(buf)
	'
	' change any occurence of the quotation mark
	'
	rg.Global  = true
	' fix all problems with single quotes and back-ticks
	rg.Pattern = "'"
	if rg.Test(buf) Then
		buf = rg.Replace(buf,"''")
	End If
	rg.Pattern = "``"
	if rg.Test(buf) Then
		buf = rg.Replace(buf,"""")
	End If
	rg.Pattern = "`"
	if rg.Test(buf) Then
		buf = rg.Replace(buf,"''")
	End If
	'
  	rg.Global  = false
End Sub


Public Sub isHistory(buf)
Dim matches, match
	'
	' processes lines with the history tag (--*)
	'
    buf = rg.Replace(buf,"")
    '
    ' check for date and names
    '
    rq.Pattern = "^(20[0-9]{2}-[0-9]{2}-[0-9]{2})(\s+)([A-Za-z+]+)(:)\s+"
	'
	Set matches = rq.Execute(buf)
	If matches.Count>0 Then
		'
		buf = rq.Replace(buf,"")
		'
		' write output except the first time around
		'
		If when <> "" Then
			checkQuote hist
'			hStream.WriteLine vbQ & fname & vbC & when & vbC & who & vbC & buf & vbQ
			hStream.WriteLine "INSERT History VALUES('" & oldname & vbW & when & vbW & who & vbW & hist & "');"
			hcount = hcount + 1
		End If
		'
		Set match = matches(0)
		'
		when = match.SubMatches(0)
		who  = match.SubMatches(2)
		hist = ""
		'
	End If    
    '
	' append to the end of line
	'
	oldname = fname
	hist	= hist & buf & " "
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

'--------------< inX subs >----------------------------

Public Sub inTable(buf)
    Dim name, dtype, desc, key, unit, echo, matches, refs
	'
	' we are inside a table
	'
	If left(buf,1) = ")" Then 
		'
		' print the output
		'
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
	rg.Pattern = "SELECT .*"
	Set matches = rg.Execute(str)
	For each m in matches
		str = m
	Next
	rg.Pattern = "SELECT "
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


Public Sub inFunc(buf)
Dim s, str, match, matches
	'
	' inside a FUNC or PROC
	'
	If inHead(buf) Then Exit Sub
	'
	rg.Pattern = "^\s*GO\s*$"
	If rg.Test(buf) Then
		Debug ">>>>>" & buf	
		endGroup buf
		Exit Sub
	End If

	' get rid of the comment part of the line first
	rw.Pattern		= "(\s*--.*$)"
	buf = rw.Replace(buf,"")

	rw.Pattern		= "(PRINT.*$)"
	buf = rw.Replace(buf,"")

	rw.Pattern	= "\("
	buf = rw.Replace(buf,"( ")

	rx.Pattern = "^(floor|float|space|sphere|spatial|sponding|.*['=\+\*]|from\S+|sp_\S*$|spt_\S*$|spec\S*$|sproc.*)"
	rq.Pattern = "(\s|(dbo\.)|=)(f\S+\(+|sp\S+)\s*"

	If rq.Test(buf) Then
		'
		Debug "<"&buf&">"
		'
	    Set matches = rq.Execute(buf)
	    For Each match in matches
			'
			rw.Pattern="(\s|(dbo\.)|=)"
			s = rw.Replace(match.Value,"")
'			rw.Pattern	= "\s"
'			s = rw.Replace(match.Value,"")
			rw.Pattern  = "(^dbo\.|\(\S*)"
			s = rw.Replace(s,"")
			rw.Pattern	= "[;\]]"
			s = rw.Replace(s,"")
			'
			If not rx.Test(s) Then
'				str   = vbQ & fname & vbC & group & vbC & s & vbQ
				str   = "INSERT Dependency VALUES('" & fname & vbW & group & vbW & s & "');"
				'			
				dStream.WriteLine str
				'
				Debug "@@@@@@@@@@@@@@@@@"
				Debug str
				Debug "@@@@@@@@@@@@@@@@@"
			End If
	    Next
	End If
End Sub


Public Sub endGroup(buf)
Dim otype, str
	If state = 2 Then otype = "U"
	If state = 4 Then otype = "V"
	If state = 6 Then otype = "F"
	If state = 8 Then otype = "P"	
	state = 0
	mode  = 0
	buf   = ""
'	str   = vbQ & fname & vbQ & ","
'	str   = str & vbQ & group & vbQ & ","
'	str   = str & vbQ & otype & vbQ & "," 
	str   = "INSERT Inventory VALUES('" & fname & vbW & group & vbW & otype & "');"
	iStream.WriteLine str
	icount = icount + 1
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
Dim names, n
	'
	' end of view, print attribute list if any
	'
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


Public Sub Echo(msg)
    WScript.Echo msg    
End Sub

Public Sub Warning(msg)
    WScript.Echo "Warning: " & msg    
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

Public Function getCategory(f)
	getCategory  = LCase(Left(f.Name,Len(f.Name)-InStrRev(f.Name,".")))					
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
