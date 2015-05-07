//------------------------------------------------------------------------------------
//		bcpWeblog.js - Invokes bcp on each log file in a given directory tree 
//                     where the file name matches the pattern and file date >= MinAge
//		Created 24-Feb-2002 by Jim Gray  
//		Usage: cscript bcpWeblog.js <directory>   MinAge [-SupressBcp]
//             cscript bcpWeblog.js c:\windows\system32\logfiles 2002-02-24 -SupressBcp
//------------------------------------------------------------------------------------
//	2003-10-10	Alex Szalay:  rewrote to accommodate more complex logging
//------------------------------------------------------------------------------------
//	sql table is: 
//	    create table weblog ( 
//		atime smalldatetime,
//		clientIP varchar(15),
//		op char(4),
//		command varchar(256), 
//		error int)
//------------------------------------------------------------------------------------
//
// environmental variables.
//
var	szScriptName		= "bcpWeblog";		// Our name
var	szScriptVersion		= "V1.0-1";			// and version number
var	WShell			= WScript.CreateObject("WScript.Shell");
var	oFso = WScript.CreateObject("Scripting.FileSystemObject");
//
//------------------------------------------
//	Greeting Message and test to see that directory exists.
//	Process command line arguments
//------------------------------------------
WScript.Echo(szScriptName + " " + szScriptVersion + " started at " + (new Date()).toUTCString() );
var objArgs			= WScript.Arguments
if (objArgs.Count() < 2 ) Usage();
if (!oFso.FolderExists(objArgs.Item(0))) usage();
var szDataTree		= objArgs.Item(0);			// tree to search
var szMinAge 		= objArgs.Item(1);
var iDoBcp			= true;
if (objArgs.Count() == 3 ) iDoBcp = false;
// aggregate statistics
var iTotalFiles         = 0;						// files loaded	
var iTotalLines			= 0;
var fTotalBytes         = 0;						// bytes in those files.
//----------------------------------------------------------------------------------------
// Recursively Scan the input folder, looking for file names that match the input spec.
//     For each matching file, invoke the DoBcp procedure on that file.
ScanFolder (szDataTree, /^ex.*\.log$/g);
//----------------------------------------------------------------------------------------
//  Scan is complete,  output summary information and exit.
var out =  "Completed loading " + iTotalFiles + " files ";
out += (fTotalBytes/(1<<20)).toFixed(3) + " MB and " + iTotalLines;
out += " lines at " + (new Date()).toUTCString();
WScript.Echo(out);
WScript.Quit(0);
//=======================<end of main>====================================================

//****************************************************************************************
//   Supporting routines.
//****************************************************************************************
//  ScanFolder() matches pattern to all names in folder and invokes bcp on matching files
//****************************************************************************************
function ScanFolder( szDataTree, szWildSpec ){
    var oFolder = oFso.GetFolder(szDataTree);
    var oFiles = new Enumerator(oFolder.Files);
    // Scan files in this folder
    for ( ; !oFiles.atEnd(); oFiles.moveNext()){
	// for each file in folder
	var oFile = oFiles.item();
      if (oFile.Name.toLowerCase().search(szWildSpec) == 0 ) {
		// if name matches pattern
		LaunchBcp(oFile);			// Feed file to bcp
		}
	}
    // Now scan sub-folders (recursive call on ScanFolder.
    var oSubFolders = new Enumerator(oFolder.SubFolders);
    for ( ; !oSubFolders.atEnd(); oSubFolders.moveNext()){
	ScanFolder( oSubFolders.item().Path, szWildSpec);
 	} 
}
	
//****************************************************************************************
//		LaunchBcp:
//			Makes the load file in temp directory
//			and then launches bcp on it 
//****************************************************************************************
function LaunchBcp(oFile ){
    var iLineCount = MakeLoadFile(oFile);				// count the lines
    var sCmdLine = 'bcp weblog.dbo.weblogTemp in c:\\temp\\bcp.tmp -S localhost -T -c -ec:\\Temp\\rejectedBcpRecods.txt';
    if (iDoBcp && (iLineCount > 0)) {
	var iBcpReturnCode = WShell.run(sCmdLine,1 ,1);		// launch bcp
    	// summarize run.           
        //WScript.Echo(sCmdLine);				// echo command if verbose
	iTotalFiles += 1;		
	iTotalLines += iLineCount;
	fTotalBytes += oFile.Size;
	}
}


//****************************************************************************************
//	lines = MakeLoadFile(oFile);  converts the log file into a loadable file 
//			with timestamps and no trash
//****************************************************************************************
function MakeLoadFile(oFile){

    // if the file does not qualify (too old, or too short) return
    var count = 0;
    var buf
    var candidateFile = oFso.OpenTextFile(oFile.Path);
    if(!candidateFile.AtEndOfStream) candidateFile.ReadLine();
    if(!candidateFile.AtEndOfStream) candidateFile.ReadLine();
    var line = "";
    if(!candidateFile.AtEndOfStream) line = candidateFile.ReadLine();
    if (line.indexOf('#Date:') != 0) {
	//WScript.Echo("file: " + oFile.Path + ' not a good log file, skipping it.');
	candidateFile.Close();
	return 0;
	}
    var date = line.substring(7,17);
    if (date < szMinAge) {			// Min Age specified in command line
	//WScript.Echo("file: " + oFile.Path + ' too old, skipping it.');
	candidateFile.Close();
	return 0;
	}
    WScript.Echo("Processing file: " + oFile.Path);
    candidateFile.Close();

    // make a local copy of the file -- avoids interlock with web server.
    //WScript.Echo("about to copy " + oFile.Path);
    oFile.Copy ("c:\\temp\\weblog.txt");
    var inStream  = oFso.OpenTextFile("c:\\temp\\weblog.txt")	
    var outStream = oFso.CreateTextFile("C:\\temp\\bcp.tmp",true)
    while (!inStream.AtEndOfStream){	 
	line =inStream.ReadLine();
	line = line;
	//WScript.Echo("input: " + line);
	if ((line.indexOf('#') != 0) && (line.length > 20) && (line.length < 8000)){
		line = remap(line);  
		// convert to Fermi Normal form
		if (line.indexOf('\t') != 0) {  	
			// have some delimiters (not null).
			var out = date.replace(/-/g,'\t') + '\t'+ count;
			out += '\t' + line.replace(/ /g,'\t');
			outStream.WriteLine(out);
			//WScript.Echo("output: "  + line );
			}
		}
        if (line.length >= 8000) WScript.Echo("Line too long (more than 8K chars): "  + line );
	count +=  1;
	}
    inStream.Close();  
    outStream.Close();
    oFso.DeleteFile("c:\\temp\\weblog.txt");// do not need the copy anymore
    return (count);
}

//***************************************************************************************
//	  process the weblog line producing a hh, ipAddr, verb, url, code, browser
//      used for SkyServer format log records.
//      returns "" if line does not match.
//***************************************************************************************
 function remap(inLine) {
    var ans = "";
    var next = "";
    var re = /[^ ]+/g;
    var code = /^\d{3}$/g;
    if ((next = re.exec(inLine)) == null) return "" ;
    if ((next = re.exec(inLine)) == null) return "" ;
    ans = ans +  next;   				  	  // hh
    if ((next = re.exec(inLine)) == null) return "" ;
    ans = ans + "\t" + next;   				  // ipaddr
    if ((next = re.exec(inLine)) == null) return "" ;
    if ((next = re.exec(inLine)) == null) return "" ;
    if ((next = re.exec(inLine)) == null) return "" ;
    if ((next = re.exec(inLine)) == null) return "" ;   // get, post,...
    ans = ans + "\t" + next;  
    if ((next = re.exec(inLine)) == null) return "" ;   // url
    ans = ans + "\t" + next;  
    if ((next = re.exec(inLine)) == null) return "" ;   // param string or error code
    if (!code.test(next)){
	ans = ans + "?" + next; 
	if ((next = re.exec(inLine)) == null) return "" ;
	} 	
    ans = ans + "\t" + next;					  // code
    if ((next = re.exec(inLine)) == null) return "" ;   // browser
    ans = ans + "\t" + next; 
    return ans;
} 

//**************************************************************************************
//	print usage() message
//**************************************************************************************
function Usage(){
    WScript.Echo("Loads IIS log files into local SQL Server WebLog.dbo.WeblogTemp table."); 
    WScript.Echo("Usage: cscript bcpWeblog.js <directory>   MinAge [-SupressBcp]");
    WScript.Echo("cscript bcpWeblog.js c:\windows\system32\logfiles 2002-02-15 -SupressBcp " );
    WScript.Quit(1);
}

