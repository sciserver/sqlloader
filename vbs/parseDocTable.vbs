'==============================================================
' parse the glossary input file to create the SQL to load the
' Algorithm table in the database
'--------------------------------------------------------------
' Object level markup tags:
'	--/H	one-line header
'	--/A	admin object, not visible to users
'	--/T	block of HTML description
' column level markup tags:
'	--/D	one-line description
'       --/G    glossary entry
'       --/L    algorithm link
'	--/U	units
'	--/K	UCD keywords
'	--/R	reference to enumerated
'
' all descriptions should be in HTML, no special characters
'--------------------------------------------------------------
' Ani Thakar, 2003-07-21
'==============================================================
Option Explicit
'-----------------------------------------
Dim fso, rg, rgquote, rgtabcol, table
'
Set fso		= WScript.CreateObject("Scripting.FileSystemObject")
Set rg		= New RegExp
rg.IgnoreCase	= True
Set rgquote	= New RegExp
rgquote.IgnoreCase	= True
rgquote.Global	= True
Set rgtabcol	= New RegExp
rgtabcol.IgnoreCase	= True
rgtabcol.Global	= True
'----------------------------------------
Dim vbC, vbQ, Root, iDebug
'
Dim vbW
'
vbQ		= Chr(34)
vbC		= vbQ & "," & vbQ
vbW		= "','"
Root		= fso.GetAbsolutePathName("..")
'
getArgs		' get command line arguments, like -d
'
'----------------------------------------
Dim gStream
Dim gCount
Dim state, group, head, text, access, mode, nlist, src, desc, dname, oldstate, totalcount
' 
'
Set gStream = fso.OpenTextFile(Root & "\schema\csv\load" & table & ".sql",2,True)
'
totalcount	= 0
state		= 0
'
gCount		= 0
' iDebug		= 1
'
WriteHeaders
ProcessFile table & ".txt"
WriteCounts
'
gStream.Close
'----------------------------------------
WScript.Echo totalcount & vbCrLf & gCount
'
WScript.Quit

'<<<<<<<<<<<<<<<<<<<<<<<<<<<End>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Public Sub WriteHeaders
Dim s, go, echo
	echo    = vbCrLf & "----------------------------- " & vbCrLf
	go = vbCrLf & "GO" & vbCrLf
	s = "SET NOCOUNT ON" & go & "TRUNCATE TABLE "

	' 
	gStream.WriteLine echo & "--  load" & table & ".sql" & echo & s & table & go
	'
End Sub

Public Sub WriteCounts
Dim echo,go
	go = vbCrLf & "GO" & vbCrLf
	echo    = "----------------------------- " & vbCrLf
	'
	gStream.WriteLine go & echo & "PRINT '" & gCount & " lines inserted into " & table & "'" & vbCrLf & echo 
	'
End Sub

Public Sub ProcessFile (name)
	Dim f, m, match
	'	
	If Not fso.FolderExists(Root) Then Fatal "Cannot find " & Root
	'
	For Each f In fso.GetFolder(Root & "\schema\doc").Files
		if( f.Name = name ) Then
			If getExt(f) = "txt" Then parseFile f
			Exit Sub
		End If
	Next
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
	'WScript.Echo buf
	'WScript.Echo "<" & state & "," & mode & "> ###" & buf & "###"
	'
	totalcount= totalcount+1
	'
	if len(buf)=0 then exit sub
	'
	If state=-1 Then Exit Sub
	If state=0 Then 
		isKey buf
	Else
		If state=1 Then 
			isName buf
		Else
			If state=2 Then 
				inText buf
			End If
		End If
	End If
	'
End Sub


Public Sub isKey(buf)
Dim t
	Debug "<<" & state & "| isKey " & buf & ">>"
	'
	rg.Pattern = "<keyword>"
	If rg.Test(buf) Then
		Debug "<<" & state & "|" & buf & ">>"
		buf	 = rg.Replace(buf,"INSERT " & table & " VALUES('")
		'<
		rg.Pattern = "</keyword>"
		If rg.Test(buf) Then
		    	buf = rg.Replace(buf,"',")
			Debug "<<" & state & "| Writing " & buf & ">>"
			gStream.Write buf
                    	state = 1
		Else
                    	state = -1
		End If
	End If
End Sub


Public Sub isName(buf)
Dim t
	Debug "<<" & state & "| isName " & buf & ">>"
	'
	rg.Pattern = "<entry>"
	If rg.Test(buf) Then
		Debug "<<" & state & "|" & buf & ">>"
		buf	 = rg.Replace(buf,"'")
		'
		rg.Pattern = "</entry>"
		If rg.Test(buf) Then
			buf = rg.Replace(buf,"','',")
                    	state = 2
			Debug "<<" & state & "| Writing " & buf & ">>"
			gStream.Write buf
		Else
			state = -1
		End If
	End If
End Sub


Public Sub inText(buf)
Dim t

	Debug "<<" & state & "| inText " & buf & ">>"
	'
	rg.Pattern = "<def>"
	If rg.Test(buf) Then
	        Debug "<<" & state & "|" & buf & ">>"
		buf	 = rg.Replace(buf,"'")
		Debug "<<" & state & "| Writing " & buf & ">>"
		gStream.Write buf
	Else
		rg.Pattern = "</def>"
		If rg.Test(buf) Then
		        buf	 = rg.Replace(buf,"' );")
			Debug "<<" & state & "| Writing " & buf & ">>"
			gStream.WriteLine buf
			gCount = gCount + 1
			state = 0
		Else
			' fix all problems with single quotes and back-ticks
			rgquote.Pattern = "'"
			if rgquote.Test(buf) Then
			        buf = rgquote.Replace(buf,"''")
			End If
			rgquote.Pattern = "``"
			if rgquote.Test(buf) Then
			        buf = rgquote.Replace(buf,"""")
			End If
			rgquote.Pattern = "`"
			if rgquote.Test(buf) Then
			        buf = rgquote.Replace(buf,"''")
			End If
			' next fix possible empty table cols
			rgtabcol.Pattern = "<td></td>"
			if rgtabcol.Test(buf) Then
			        buf = rgtabcol.Replace(buf,"<td>&nbsp;</td>")
			End If
			' finally deal with the glossary/algorithm/tableref tags
			rg.Pattern = "<algorithm>"
			Do While rg.Test(buf) 
				buf = rg.Replace(buf,"<a href=''algorithm.asp?key=")
			Loop
			rg.Pattern = "</algorithm>"
			Do While rg.Test(buf)
			       	buf = rg.Replace(buf,"''><img src=''images/algorithm.gif'' border=0></a>")
			Loop
			rg.Pattern = "<glossary>"
			Do While rg.Test(buf) 
				buf = rg.Replace(buf,"<a href=''glossary.asp?key=")
			Loop
			rg.Pattern = "</glossary>"
			Do While rg.Test(buf)
			       	buf = rg.Replace(buf,"''><img src=''images/glossary.gif'' border=0></a>")
			Loop
			rg.Pattern = "<tableref>"
			Do While rg.Test(buf) 
				buf = rg.Replace(buf,"<a href=''tabledesc.asp?key=")
			Loop
			rg.Pattern = "</tableref>"
			Do While rg.Test(buf)
			       	buf = rg.Replace(buf,"''><img src=''images/tableref.gif'' border=0></a>")
			Loop
			Debug "<<" & state & "| Writing " & buf & ">>"
'			gStream.Write buf+" "
			gStream.WriteLine buf
		End If
	End If
End Sub


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
	table = ""
	rg.Pattern = "-d"
	For Each argv In WScript.Arguments
		If rg.Test(Lcase(argv)) Then 
		       iDebug = 1
		Else
		       table = Lcase(argv)
		End If
	Next
End Sub
