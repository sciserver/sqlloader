'==============================================================
' take a csv file as its input, and remove duplicate lines
'--------------------------------------------------------------
' Alex Szalay, 05-26-04, Baltimore
'==============================================================
Option Explicit
'-----------------------------------------
Dim fso, rg
Set rg			= New RegExp
rg.IgnoreCase	= True
'
Set fso			= WScript.CreateObject("Scripting.FileSystemObject")
'----------------------------------------
Dim vbQ, Root, iDebug
'
vbQ				= Chr(34)
Root			= fso.GetAbsolutePathName("..\schema")
'
getArgs		' get command line arguments, like -d
'
'----------------------------------------
Dim hStream
Dim totalcount, dcount
'
Set hStream = fso.OpenTextFile(Root & "\csv\loaddependency.sql",2,True)
'
Dim s1,s2,s3
s1 = "-----------------------------" & vbCrLf & "--  "
s2 = ".sql" & vbCrLf & "-----------------------------" & vbCrLf
s2 = s2 & "SET NOCOUNT ON" & vbCrLf & "GO" & vbCrLf & "TRUNCATE TABLE "
s3 = vbCrLf & "GO" & vbCrLf & "--" & vbCrLf & vbCrLf
'
hStream.Write s1 + "Dependency" & s2 & "Dependency" & s3
'
totalcount	= 0
dcount		= 0
FindFiles "d2.sql"
'

s1 = "GO" & vbCrLf & vbCrLf & "------------------------------------" & vbCrLf &  "PRINT '"
s2 = vbCrLf & "------------------------------------" & vbCrLf & "GO" & vbCrLf

hStream.Write  s1 & dcount & " lines inserted into Dependency'" & s2
hStream.Close
'----------------------------------------
WScript.Echo "remove-dups.vbs has scanned " & totalcount & " lines" & vbCrLf
'
WScript.Quit

'<<<<<<<<<<<<<<<<<<<<<<<<<<<End>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

Public Sub FindFiles (filter)
	Dim f, m, match
	'	
	If Not fso.FolderExists(Root) Then Fatal "Cannot find " & Root
	'
	For Each f In fso.GetFolder(Root & "\csv").Files
		rg.Pattern = filter
		For Each m in rg.Execute(f.Name)
			If getExt(f) = "sql" Then parseFile f
		Next		
	Next
	'	
End Sub


Public Sub parseFile (f)
	Dim inStream, buf, last
	'
	Set inStream = fso.OpenTextFile(f.Path)
	Debug "<" & f.Name & ">"
	last    = ""
	Do While Not (inStream.atEndOfStream)
		totalCount = totalCount + 1
		buf = inStream.ReadLine
		If buf <> last Then
			hStream.WriteLine buf
			dcount = dcount +1
		End If
		last = buf
	Loop				
	inStream.Close	
End Sub

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
		If rg.Test(Lcase(argv)) Then iDebug = 1
	Next
End Sub
