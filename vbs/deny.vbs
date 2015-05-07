'==============================================================
' Script to grant access to IPs and domains.
'--------------------------------------------------------------
' Ani Thakar, Mar 4, 2003
'==============================================================

Option Explicit

Dim fso, iDebug, inStream, outStream, inFileName, outFileName
Dim lcount, rgx, iprgx, addCount, dupCount, invCount
Dim secObj
Dim myIPSec
Dim ipList, domainList

Set fso		= WScript.CreateObject("Scripting.FileSystemObject")
iDebug		= 0
Set rgx		= New Regexp
rgx.Pattern	= "\s$"
Set iprgx	= New Regexp
iprgx.Pattern	= "^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\,[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$"
                                 
Set secObj = GetObject("IIS://LocalHost/W3SVC/1/ROOT/playground/restrict")
Set myIPSec = secObj.IPSecurity

'----------------------------------------
' Main - short and sweet.
'----------------------------------------
ResetSecurity
'GrantIPAccess
'GrantDomainAccess
'----------------------------------------
WScript.Quit
'<<<<<<<<<<<<<<<<<<<<<<<<<<<End>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


' Procedures and Functions
'
' Deny all access by default, and truncate IPGrant and DomainGrant lists to 0 size
Public Sub ResetSecurity
	Dim blankIPList, blankDomainList
	
	myIPSec.GrantByDefault = FALSE
	blankIPList = myIPSec.IPGrant
	blankDomainList = myIPSec.DomainGrant
	Redim blankIPList(0)
	Redim blankDomainList(0)
	myIPSec.IPGrant = blankIPList
	myIPSec.DomainGrant = blankDomainList
	secObj.IPSecurity = myIPSec
	secObj.Setinfo
End Sub


' Grant access to specific IPs with the IPGrant property
Public Sub GrantIPAccess
	Dim match, buf
	
	inFileName = "ipList.txt"
	outFileName = "ipLog.txt"
	If Not fso.FileExists(inFileName) Then Fatal "Cannot find " & inFileName
	'
	Set inStream = fso.OpenTextFile(inFileName)
	Set outStream = fso.OpenTextFile(outFileName,2,True)
	lcount = 0
	addCount = 0
	dupCount = 0
	invCount = 0
	'
	ipList = myIPSec.IPGrant
	Do While Not (inStream.atEndOfStream)	
		buf = inStream.ReadLine
		buf = rgx.replace(buf,"")
		match = iprgx.Test(buf)
		If (match) Then
			AddIP buf
		Else
			outStream.WriteLine lcount & " Invalid: " & buf
			invCount = invCount + 1
		End If
		lcount = lcount + 1
	Loop
	myIPSec.IPGrant = ipList
	secObj.IPSecurity = myIPSec
	secObj.Setinfo
	inStream.close
	outStream.Close
	WScript.Echo "IP List done, " & lcount & " total lines in file, " & addCount & " added, " & dupCount & " duplicates, " & invCount & " invalid." & vbCrLf & "IP List now contains " & Ubound(ipList) & " elements."
End Sub


' Add one new IP-Subnet pair to the IP List
Public Sub AddIP( newIP )
	Dim msg, hash, i
	msg = Ubound(ipList)& vbCrLf & newIP & vbCrLf
	hash = IPMask (newIP)
	for Each i In ipList
		If (IPMask(i) = hash) Then
			outStream.WriteLine lcount & " Duplicate: " & i & " and " & newIP 
			dupCount = dupCount + 1
			Exit Sub
		End If
	Next
	Redim Preserve ipList(Ubound(ipList)+1)
	ipList(Ubound(ipList)) = newIP
	outStream.WriteLine lcount & " Added: " & newIP
	addCount = addCount + 1
End Sub


' Generate a mask for the given IP-subnet pair so duplicates can be detected
Public Function IPMask (str)
	Dim ip, mask, a, i
	a = split( str, "," )
	ip = split( a(0), "." )
	mask = split( a(1), "." )
	IPMask = ""
	for i = 0 To 3
		IPMask = IPMask & (ip(i) AND mask(i))
		If (i < 3) Then 
			IPMask = IPMask & "." 
		End If
	Next
End Function


' Grant access to specific domains using the DomainGrant property.
' NOTE: No sanity check or duplicate check is performed on domains.
Public Sub GrantDomainAccess
	Dim buf,lcount
	
	inFileName = "domainList.txt"
	outFileName = "domLog.txt"
	If Not fso.FileExists(inFileName) Then Fatal "Cannot find " & inFileName
	'
	Set inStream = fso.OpenTextFile(inFileName)
	Set outStream = fso.OpenTextFile(outFileName,2,True)
	lcount = 0
	addCount = 0
	dupCount = 0
	invCount = 0
	domainList = myIPSec.DomainGrant
	Do While Not (inStream.atEndOfStream)	
		buf = inStream.ReadLine
		AddDomain( buf )
		lcount = lcount + 1
		outStream.WriteLine lcount & " Added: " & buf
		addCount = addCount + 1
	Loop
	myIPSec.DomainGrant = domainList
	secObj.IPSecurity = myIPSec
	secObj.Setinfo
	outStream.Close
	WScript.Echo "Domain List done, " & lcount & " total lines in file, " & addCount & " added, " & dupCount & " duplicates, " & invCount & " invalid." & vbCrLf & "Domain List now contains " & Ubound(domainList) & " elements."
End Sub


Public Sub AddDomain( newDomain )
	Redim Preserve domainList (Ubound(domainList)+1)
	domainList (Ubound(domainList)) = newDomain
'	Wscript.Echo Ubound(domainList), newDomain
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

