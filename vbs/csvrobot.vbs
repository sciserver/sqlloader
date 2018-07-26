'==============================================================
' csvrobot.vbs
' In order to run:
' 	cscript csvrobot.vbs 5 [-d] [-n] [-S]
'
' Arguments:
'	tasknumber
'	-d: debug flag, for verbose log
'	-n: nolog, do not write into database
'       -S: DB server name
'
' -------------------------------------------------------------
' 2002-04-09:	Dennis Dinge
' 2002-07-23:	Alex Szalay, modularized checking, and reporting
' 2002-08-08:	Alex Szalay, merge schema log file into main
' 2002-08-10:   Alex Szalay, handle the Chunk file in top directory
' 2002-08-10:   Alex Szalay, moved database creation into SQL part
' 2003-05-16:   Alex Szalay, added CL parameter for DB server name
' 2003-05-20:   Ani Thakar, changed PhotoObj CSV filename to PhotoObjAll
' 2003-08-14:   Ani Thakar, changed tiling table names as per PR #5560
'               and 5561.
' 2004-01-27:   Ani Thakar, added check for existence of backup folder
'               (PR #5476).
' 2007-05-11:   Ani Thakar, added check so if there are no zooms, there
'               is no entry added to the Files table for the zooms.
'               This prevents fatal error in the preload step later.
' 2008-03-28:   Ani Thakar, added case for PsObjAll CSV file (PR #7014).
' 2009-02-23:   Ani Thakar, changes for SDSS-III:
'               Removed CSV file search for First, Mask, ObjMask, 
'               PsObjAll, Segment, Rosat, USNO.
'               Removed check for zoom directory.
' 2010-01-14:   Ani Thakar, added AtlasOutline to replace ObjMask
'               for SDSS-III.
' 2010-10-15:   Naren Buddana, added CSVs for tables FIRST, RC3, ROSAT, 
'               2MASS, 2MASSXSC and USNOB.
' 2010-10-27:   Naren Buddana, Added sqlTargetParam, and removed "sdss"
'               prefix from tiling CSV file names.
' 2010-12-08:   Ani Thakar, added segueTargetAll to sspp.
' 2012-05-31:   Ani Thakar, added galaxy product tables to PLATES.
' 2012-05-31:   Ani Thakar, corrected galaxy product CSV names.
' 2012-06-19:   Ani Thakar, updated galaxy product CSV names.
' 2013-03-19:   Ani Thakar, added APOGEE tables.
' 2013-05-02:   Ani Thakar, created new galprod export type for
'               galaxy product tables and updated galaxy product 
'               CSV names for DR10.
' 2013-05-20:   Ani Thakar, added WISE tables.
' 2013-05-22:   Ani Thakar, added aspcapStarCovar table for APOGEE.
' 2013-07-03:   Ani Thakar, added apogeeDesign, apogeeField and 
'               apogeeObject tables for APOGEE.
' 2013-07-09    Ani Thakar: added apogeeStarVisit and apogeeStarAllVisit.
' 2013-12-11    Ani Thakar: fixed typo in iDebug check and removed
'               call to FatalError.
' 2016-03-03    Replaced theExportType" with skyvsersion (2) in
'               photo batch file names, and added new export 
'               type "mask".
' 2016-03-10    Added WISE forced photometry batch in export type "forced".
' 2016-03-29    Added MaNGA batch in export type "manga".
' 2016-05-04    Added NSA batch in export type "nsa".
' 2018-06-08    Added MangaDAPall, MangaHI* to MaNGA batch.
' 2018-07-19    Added mastar batch.
'==============================================================

Option Explicit

Dim fso, oConn, iDebug, iNolog, sep, folder, fDebug
Dim themessage, thetaskid, thedbname, thedbsize, thelogsize, thestep 
Dim theid, theuser, thestatus, theexporttype, thepath, theroot
Dim thestepid, thefilename, thebackupfile
Dim dbserver
	

Set fso		= WScript.CreateObject("Scripting.FileSystemObject")
iDebug		= 1
sep		= "','"

'-------------<Main>---------------------------------------- 
	'
	GetArgs			' get the taskid and server from the command line
	'
	Connect "Server=" & dbserver & ";Driver=SQL Server;Database=loadsupport;UID=webagent;Password=loadsql;"
	'
	GetTask			' get the parameters of the task
	'
	' check whether the task directory exists
	'
	If fso.FolderExists(thepath) Then 
		CsvLog "Check root","Found root directory", "OK"
	Else
		FatalError "Data directory does not exist " & thepath
	End If
	'
	If fso.FolderExists(fso.GetParentFolderName(thebackupfile)) Then 
		CsvLog "Check backup folder","Folder exists", "OK"
	Else
		FatalError "Backup folder does not exist " & fso.GetParentFolderName(thebackupfile)
	End If
	'
	Set theroot = fso.GetFolder(thepath)
	'
	iDebug		= 0
'	If iDebug = 1 Then
		Set fDebug = fso.OpenTextFile( "C:\temp\csvRobotDbg.txt", 8, True)
		CsvLog "Open debug file c:\temp\csvRobotDbg.txt", "File opened", "OK"
'	End If

	If LCase(theroot.ParentFolder.Name) <> theexporttype Then
		FatalError "Data path and exporttype mismatch"
	End If
	'
	CheckDir theroot, 0
	'
	If theexporttype <> "tiles" and theexporttype <> "plates" Then
		For Each folder In theroot.SubFolders
			CheckDir folder, 1
		Next
	End If
	fDebug.Close
	'
	WScript.Quit
	'
'------<End of Main>------------------------------------------


Public Sub CheckDir (root,level)
'----------------------------------------------------------------
' check directory status - has ready to load semaphore been set
'----------------------------------------------------------------
' possible errors returned from CheckDir:
'	ready to load semaphore not properly set
'	bad filename detected
'	0 length file detected
'	no files beyond the semaphore file
'	all necessary files are not present 
'----------------------------------------------------------------
  Dim csvcount, filecount, rootname, fname, folder 
  Dim s, f, rg, buf, comment
  Dim inStream, a, cmd, zoom
	'
	rootname = root.Name
	CheckSemaphore root
	'
	' get database size, and update the Task entry
	'
	If level=0 Then 
		thedbsize = CLng(0.75*root.Size/1000000)
		If thedbsize<20 Then thedbsize=20
		thelogsize = thedbsize
		If thelogsize>10000 Then thelogsize=10000
		Debug rootname & " dbsize  :" & thedbsize & "MB"
		Debug rootname & " logsize :" & thelogsize & "MB"
		TaskUpdate
	End If
	'
	' Gather up all the files in the folder
	'
	Debug "theexporttype = " & theexporttype & "::"
	s = "("
	If ( theexporttype = "plates" ) Then
		s = s & "(^sql(PlateX|SpecObj|SppLines|SppParams|StellarMassPCAWisc|StellarMassPassivePort|StellarMassStarformingPort|EmissionLinesPort)"
		s = s & "*\.csv$)"
	ElseIf ( theexporttype = "galprod" ) Then
		s = s & "(^sql(StellarMassPCAWiscBC03|StellarMassPCAWiscM11|StellarMassFSPSGranEarlyDust|StellarMassFSPSGranEarlyNoDust|StellarMassFSPSGranWideDust|StellarMassFSPSGranWideNoDust|StellarMassPassivePort|StellarMassStarformingPort|EmissionLinesPort)"
		s = s & "*\.csv$)"
	ElseIf ( theexporttype = "galspec" ) Then
		s = s & "(^sqlGalSpec(Extra|Indx|Info|Line)" & "_*[0-9]*\.csv$)"
	ElseIf ( theexporttype = "tiles" ) Then
		s = s & "(^sql(TargetParam|TileAll|TilingGeometry|TiledTargetAll|TilingInfo|TilingRun)" & "_*[0-9]*\.csv$)"
	ElseIf ( theexporttype = "window" ) Then
		s = s & "(^sqlsdss(ImagingHalfSpaces|Polygon2Field|Polygons)" & "_*[0-9]*\.csv$)"
	ElseIf ( theexporttype = "sspp" ) Then
		s = s & "(^sql(Plate2Target|SppLines|SppParams|SppTargets|SegueTargetAll)" & "_*[0-9]*\.csv$)"
	ElseIf ( theexporttype = "pm" ) Then
		s = s & "(^sqlProperMotions" & "-" & theid & "-[0-9]*-[0-9]*\.csv$)"
	ElseIf ( theexporttype = "mask" ) Then
		s = s & "(^sqlMask" & "-2-" & rootname & "-[0-9]*\.csv$)"
	ElseIf ( theexporttype = "resolve" ) Then
		s = s & "(^sql(ThingIndex|DetectionIndex).csv" & "_*[0-9]*\.csv$)"
	ElseIf ( theexporttype = "apogee" ) Then
		s = s & "(^sql(ApogeeVisit|ApogeeStar|aspcapStar|aspcapStarCovar|ApogeePlate|ApogeeDesign|ApogeeField|ApogeeObject|ApogeeStarVisit|ApogeeStarAllVisit)" & "_*[0-9]*\.csv$)"
	ElseIf ( theexporttype = "wise" ) Then
		s = s & "(^sqlWise(XMatch|AllSky)" & "_[0-9]*\.csv$)"
	ElseIf ( theexporttype = "forced" ) Then
		s = s & "(^sqlWISE_forced_target-2-" & rootname & "-*[0-9]*_*[0-9]*\.csv$)"
	ElseIf ( theexporttype = "manga" ) Then
		s = s & "(^sql(MangaDAPall|MangaDRPall|MangaTarget|MangaHIall|MangaHIbonus|MastarGoodStars|MastarGoodVisits)" & "-v[0-9]*_[0-9]*_[0-9]*\.csv_[0-9]*\.csv$)"
	ElseIf ( theexporttype = "mastar" ) Then
		s = s & "(^sql(MastarGoodStars|MastarGoodVisits)" & "-v[0-9]*_[0-9]*_[0-9]*\.csv_[0-9]*\.csv$)"
	ElseIf ( theexporttype = "nsa" ) Then
		s = s & "(^sqlNSA" & "-v[0-9]*_[0-9]*_[0-9]*\.csv_[0-9]*\.csv$)"
	Else
			s = s & "(^sql(AtlasOutline|Field|FieldProfile|PhotoObjAll|PhotoProfile|Run|2MASS|2MASSXSC|First|RC3|ROSAT|USNOB)"
			s = s & "-2-" & rootname & "-[0-9]*_*[0-9]*\.csv$)"
	End If
'	s = s & "-" & theexporttype & "-" & rootname & "-[0-9]*_*[0-9]*\.csv$)"
	s = s & ")"
	'
	Debug "search pattern = " & s
	Set rg = New Regexp
	rg.Pattern = s
	'
	csvcount = 0
	For Each f In root.Files
		fname = f.name
		Debug csvcount & "|" & fname
		If rg.Test(fname) Then 
			csvcount = csvcount+1
		End If
	Next
	'
	' compare to the csv_ready file
	'
	filecount = 0
	comment   = ""
	rg.Pattern = "^#"
	Set inStream = fso.OpenTextFile(root.Path & "\csv_ready")       
	Do While Not (inStream.atEndOfStream)
		buf = inStream.ReadLine
		If rg.Test(buf) Then
			comment = comment & Mid(buf,2) & " "
		Else		
			a = Split(buf,",")
			fname = root.Path & "\" & a(0)
			If Not fso.FileExists(fname) Then 
				FatalError "File "& a(0) & " not found"
			End If
			' CheckHeader root, a
			filecount = filecount+1
		End If
	Loop
	inStream.Close
	'
	If (level>0 And filecount>0 And csvcount=0) Then FatalError "No csv files found in " & root.Path
	'
	If filecount <> csvcount Then
		Debug "filecount: " & filecount & ", csvcount: " & csvcount 
		FatalError "Mismatch in number of files from csv_ready in " & root.path & ": pattern=" & s & ", filecount=" & filecount & ", csvcount=" & csvcount
	Else 
		CsvLog "File count","Number of CSV files is " & filecount, "OK"
	End If
	'
	' it is good enough so far, now let us check things into the database
	'
	rg.Pattern = "^#"
	Set inStream = fso.OpenTextFile(root.Path & "\csv_ready")       
	Do While Not (inStream.atEndOfStream)
		buf = inStream.ReadLine
		If Not rg.Test(buf) Then
			LogFile root, buf
		End If
	Loop
	inStream.Close
    '
    ' now check if there is a Zoom directory
    '
    rg.Pattern = "(best|runs|target)" 
    If rg.Test(theexporttype) and level=1 Then
		If fso.FolderExists(root.Path & "\zoom") Then
			Set zoom = fso.GetFolder(root.Path & "\zoom")
			CheckZoom zoom
		Else
			FatalError "Zoom directory not found in " & root.Path
		End If
	End If
    '
    ' check if there are plates with gif directories
    '
    rg.Pattern = "[0-9]+"
    If theexporttype="plates" Then
		For Each folder In root.SubFolders
			If rg.Test(folder.Name) Then
				CheckPlate folder
			End If
		Next
    End If
    '
	Exit Sub
	'
End Sub


Public Sub CheckPlate(root) 
	'
	Debug root.name
	If Not fso.FolderExists(root.Path & "\gif") Then
		FatalError "\" & root.name & "\gif missing"
	End If	
	'
End Sub


Public Sub CheckZoom(zoom)
'----------------------------------------------------
' check the zoom folder, and get the count of files
'----------------------------------------------------
Dim camcol, file, rg, rgc
Dim dircount, filecount, field0, fieldcount
	'
	Set rg = New RegExp
	rg.Pattern = "(Segment)"
	'
	' read the no of fields from the Segment file
	'
	For Each file In zoom.ParentFolder.Files
		If rg.Test(file.Name) Then
			ReadSegment file, field0, fieldcount
		End If
	Next
	'
	filecount=0
	dircount=0
	'
	Set rgc = New RegExp
	rgc.Pattern = "^[1-6]"
	'
	For Each camcol In zoom.SubFolders
	    If rgc.Test(camcol.name) Then
			dircount= dircount+1
			filecount = filecount + camcol.Files.count
			'========================
			' maybe verify the existence of the first file
			'========================
		Else 
			FatalError "Illegal camcol value in " & camcol.Path
		End If
	Next
	'
	thefilename = zoom.Path
	'
	If dircount <> 6 Then FatalError "Camcol count is not 6 in " & zoom.Path
	'
	If filecount < fieldcount Then 
		Warning "JPG test", "No of JPG files is " & fileCount & ", less than the expected " & fieldCount
	Else
		CsvLog "JPG count","Number of JPG files is " & filecount, "OK"
	End If
	'
	' Add the zoom dir to the file list only if there are some zooms.
	' This check was added for the RUNSDB where there may be no zooms.
	'
	If filecount > 0 Then
	        LogFile zoom, "," & filecount & ",Frame,zoom"
	End If
	'
	thefilename = theroot.Path
	'
End Sub


Public Sub ReadSegment(file, field0, fieldcount)
'---------------------------------------------------
' read the number of fields in Segment
'---------------------------------------------------
Dim a, start, inStream, buf, rg
	'
	Set rg = New RegExp
	rg.Pattern = "[0-9]*"

	Set inStream = fso.OpenTextFile(file.Path)       
	field0 = 16000
	fieldcount=0
	'
	' read the header line first
	'
	buf = inStream.ReadLine
	'
	Do While Not (inStream.atEndOfStream)
		buf = inStream.ReadLine
		a = Split(buf,",")
		If rg.Test(a(0)) Then
			start = a(5)
			If start < field0 Then field0 = start
			fieldcount = fieldcount + a(6)*7
		End If
	Loop
	inStream.Close
End Sub



Public Sub CheckHeader(root, a)
'---------------------------------------------------
' verify that the first header line matches DB schema
'---------------------------------------------------
Dim cmd, o, h1, i
	'
	Debug "Checking the headers"
	'
	cmd = "select top 0 * from " & thedbname & ".dbo." & a(2)
	Set o = oConn.Execute(cmd)
	h1 = ""
	For Each i In o.Fields
		h1 = h1 & i.name & ","
	Next
	'
	h1 = Mid(h1,1,Len(h1)-1)
	'
	'Echo "<"&a(2)&"> " & h1
	'
End Sub


Public Sub CheckSemaphore (Directory)
'----------------------------------------
' Check semaphore files
'----------------------------------------
	thefilename = Directory.Path

	CsvLog "Dir check","Checking directory", "OK"
	If fso.FileExists(Directory & "\csv_loading" ) Then 
		FatalError "Semaphore indicates loading status"
	End If   
	If fso.FileExists(Directory & "\csv_queued" ) Then 
		FatalError "Semaphore indicates queued status"
	End If
	If fso.FileExists(Directory & "\csv_error" ) Then 
		FatalError "Semaphore indicates error"
	End If
	If Not fso.FileExists(Directory & "\csv_ready" ) Then 
		FatalError "Missing csv_ready file in " & Directory
	End If
	'
End Sub


'****************************************************************************************************

Public Sub GetArgs
'------------------------------------------------
' read the command line arguments and set iDebug
' and the optional drivespec
'------------------------------------------------
	Dim a, rgt, rgd, rgn, rgs
	'
	Set rgt	= New RegExp
	Set rgd	= New RegExp
	Set rgn	= New RegExp
	Set rgs = New RegExp
	rgt.Pattern="^[0-9]+"
	rgd.Pattern="^-[dD]$"
	rgn.Pattern="^-[nN]$"
	rgs.Pattern="^-[sS].*"
	'
	iDebug  = 0
	iNolog  = 0
	thetaskid = 0
	'
	For each a in WScript.Arguments
		if rgd.Test(a) Then iDebug=1
		if rgn.Test(a) Then iNolog=1
		if rgt.Test(a) Then thetaskid=a
		if rgs.Test(a) Then 
		   a = Replace(a,"-S","")
		   a = Replace(a,"-s","")
		   if a <> "" Then 
			dbserver = a
		   else
		   end if
		end if
	Next
	' 
	If dbserver="" Then ErrorMsg "No database server specified"
	If thetaskid=0 Then ErrorMsg "No taskid specified, use cscript csvrobot.vbs <taskid> -sSERVER [-d] for debug [-n] for no dblog"
	'
End Sub


Public Sub GetTask
'---------------------------------------
' get the details of the task
'---------------------------------------
Dim cmd, o
	'
	Debug "Read task details "
	'
	If IsEmpty(thetaskid) Then
		ErrorMsg "You must supply a taskid on the command line!"
	End If
	'
	cmd = "SELECT taskid, dbname, step, taskstatus,type,id,path,user,backupfilename "
	cmd = cmd & " FROM task where taskid = "  & thetaskid
	If iNolog=1 Then Debug cmd
	'
	Set o = oConn.Execute(cmd)    
	'
	if Not o.EOF Then
		thetaskid		= o.Fields.Item(0)
		thedbname		= o.Fields.Item(1)
		thestep			= o.Fields.Item(2)
		thestatus		= o.Fields.Item(3)
		theexporttype		= o.Fields.Item(4)
		theid 			= o.Fields.Item(5)
		thepath			= o.Fields.Item(6)
		theuser			= o.Fields.Item(7)
		thebackupfile		= o.Fields.Item(8)
	Else
		WScript.Echo	"No Tasks to Load"
		WScript.Quit	
	End If
	'
	Debug "   taskid:   " & thetaskid
	Debug "   dbname:   " & thedbname
	Debug "   step:     " & thestep
	Debug "   status:   " & thestatus
	Debug "   xtype:    " & theexporttype
	Debug "   id:       " & theid
	Debug "   path:     " & thepath
	Debug "   user:     " & theuser
	Debug "   backup:   " & thebackupfile
	'
	theexporttype = LCase(theexporttype)
	thefilename = thepath
	'	
	' get the stepid now
	'
	cmd = "SELECT max(stepid) FROM Step"
	cmd = cmd & " WHERE taskid=" & thetaskid & " AND stepname='CHECK'"
	If iNolog=1 Then Debug cmd
	'
	Set o = oConn.Execute(cmd)    
	if Not o.EOF Then
		thestepid = o.Fields.Item(0)
	Else
		FatalError "No step found"	
	End If
	'
	' check the state of the task
	'
	If Not (thestep = "CHECK" AND thestatus = "WORKING") And iNolog=0 Then
		FatalError "The state in the task table is not CHECK AND WORKING"
	End If
	'
	Debug "Taskid: " & thetaskid
	Debug "Stepid: " & thestepid
	'
End Sub


Public Sub Connect(str)
'-----------------------------------------
' Create/Open a connection for CsvLogs
'-----------------------------------------
	'
	Debug "Connect to database"
	'
	On Error Resume Next
	'
	Set oConn = WScript.CreateObject("ADODB.Connection")
	oConn.Open str
	'
	If err.Number <> 0 Then
		ErrorMsg "Cannot connect to database"
	End If
	'
	oConn.ConnectionTimeout=900
	oConn.CommandTimeout=900
	'
End Sub


'**********************************************
' Utilities for the low level DB entry tasks
'**********************************************

Public Sub CsvLog (phase, msg, state)
'-----------------------------------------
' Write a new log message to the database
'-----------------------------------------
	Dim cmd, o
	'
	cmd = "EXEC spNewPhase " & thetaskid & ", "
	cmd = cmd & thestepid & ",'"& phase &"'," & state & ",'" 
	cmd = cmd & thefilename & ":" & msg & "'"
	If iNolog=0 Then Set o = oConn.Execute(cmd)
	If iNolog=1 Then Debug cmd
	'
End Sub


Public Sub EndStep (msg,status)
'-----------------------------------------
' Write a new event to the database
'-----------------------------------------
	Dim cmd, o
	'
	cmd ="exec dbo.spEndStep " & thetaskid & "," & thestepid & ", "
	cmd = cmd & status & ", '" & msg & "','" & msg & "'"
	If iNolog=0 Then Set o = oConn.Execute(cmd)
	'
End Sub


Public Sub FatalError (msg)
'---------------------------------------
' A fatal error has occured, log it into the
' Phase, Step and Task tables
'---------------------------------------
	'
	EndStep msg, "'ABORTING'"
	ErrorMsg msg
	'
End Sub


Public Sub LogFile(root, buf)
'----------------------------------------
' Insert the directory/file entry into the database
'----------------------------------------
Dim cmd, a, o
	'
	a = Split(buf,",")
	'
	cmd = "INSERT INTO Files VALUES(" 
	cmd = cmd & thetaskid & "," & thestepid & ","
	cmd = cmd & "'READY',GETDATE(),NULL,NULL,'" & root.Path & "\" & a(0) & "'," 
	cmd = cmd & a(1) & ",'" & a(2) & "','" & a(3) & "',0 )"
	If iNolog=0 Then Set o = oConn.Execute(cmd)
	'If iNolog=1 Then Debug cmd
	'
End Sub


Public Sub TaskUpdate ()
'-----------------------------------------
' Update task size in the database
'-----------------------------------------
Dim cmd, o
	'
	cmd = "UPDATE Task SET datasize=" & thedbsize & ", logsize=" & thelogsize 
	cmd = cmd & " WHERE taskid=" & thetaskid
	If iNolog=0 Then Set o = oConn.Execute(cmd)    
	'If iNolog=1 Then Debug cmd
	'
End Sub


'**********************************************
' Utilities for writing logs to the console
'**********************************************

Public Sub Warning (phase,msg)
'---------------------------------------
' A non-fatal error occurred, that justifies a warning
'---------------------------------------	
	'
	CsvLog phase, msg, "WARNING"
	Echo "Warning: " & msg
	'
End Sub


Public Sub ErrorMsg(msg)
'---------------------------------------
' A fatal error occurred, that justifies quitting
'---------------------------------------	
	'
	Echo "Error: " & msg
	WScript.Quit
	'
End Sub


Public Sub Echo(msg)
'---------------------------------------
' Echo the argument on the console
'---------------------------------------	
	WScript.Echo msg
End Sub


Public Sub Debug(msg)
'---------------------------------------
' Only echo the argument on the console if in debug mode
'---------------------------------------	
	If iDebug=1 Then 
		WScript.Echo msg
		fDebug.WriteLine( msg )
	End If
End Sub

