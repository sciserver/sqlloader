using System;
using System.IO;
using System.Text.RegularExpressions;

namespace bcpWeblog
{
	/// <summary>
	/// Summary description for Class1.
	/// </summary>
	class bcpWeblog
	{
		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		static int totalLines = 0;
		static int totalFiles = 0;
		static double totalBytes = 0;
		static bool doBcp = false;
		static string dataTree;
		static string minAge;
		static bool noBcp = false;

		[STAThread]
		static void Main(string[] args)
		{
			//
			// TODO: Add code to start application here
			//
			if( args.Length < 2 ) 
				Usage();
			dataTree = args[0];
			if( !Directory.Exists(dataTree) ) 
				Usage();
			minAge = args[1];
			if( args.Length > 2 && args[2] == "-SuppressBcp" )
				noBcp = true;
			Console.WriteLine( "data tree = {0}, noBcp = {1}", dataTree,noBcp );
			ScanFolder( dataTree, "^ex.*\\.log$");
		}

		//****************************************************************************************
		//   Supporting routines.
		//****************************************************************************************
		//  ScanFolder() matches pattern to all names in folder and invokes bcp on matching files
		//****************************************************************************************
		public static void ScanFolder( string dataTree, string wildSpec )
		{
			DirectoryInfo di = new DirectoryInfo(dataTree);
			Console.WriteLine( "ScanFolder {0},{1}", dataTree,wildSpec );
			foreach( FileInfo fi in di.GetFiles() )
			{
				Console.WriteLine( "Next file {0} ...", fi.FullName );
				if( Regex.IsMatch(fi.Name,wildSpec,RegexOptions.Compiled&RegexOptions.Multiline&RegexOptions.IgnoreCase ) )
				{
					if( noBcp )
						Console.WriteLine( "Skipping LaunchBcp for {0} ...", fi.Name );
					else
					{
						Console.WriteLine( "Running LaunchBcp for {0} ...", fi.FullName );
						LaunchBcp( fi );
					}
				}
			}
			foreach( DirectoryInfo fo in di.GetDirectories() )
			{
				ScanFolder( fo.FullName, wildSpec );
			}
		}

		public static void LaunchBcp( FileInfo fi )
		{
			int lineCount = MakeLoadFile( fi );				// count the lines
			if( doBcp && (lineCount > 0) ) 
			{
				System.Diagnostics.Process proc = new System.Diagnostics.Process();
				proc.EnableRaisingEvents=false;
				proc.StartInfo.FileName="Wscript.Shell";
				proc.StartInfo.Arguments="bcp weblog.dbo.weblogTemp in c:\\temp\\bcp.tmp -S localhost -T -c -ec:\\Temp\\rejectedBcpRecods.txt";
				proc.Start();
				proc.WaitForExit();
				int bcpReturnCode = proc.ExitCode;
				totalFiles += 1;		
				totalLines += lineCount;
				totalBytes += fi.Length;
			}
		}

		public static int MakeLoadFile( FileInfo fi )
		{
			// if the file does not qualify (too old, or too short) return
			int count = 0;
			StreamReader candidateFile = fi.OpenText();
			if( candidateFile.ReadLine() == null ) return( 0 );
			if( candidateFile.ReadLine() == null ) return( 0 );
			string line = "";
			if( (line = candidateFile.ReadLine()) == null ) return( 0 );
			if( line.IndexOf("#Date:") != 0 ) 
			{
				Console.WriteLine("file: {0} not a good log file, skipping it.", fi.FullName );
				candidateFile.Close();
				return( 0 );
			}
			string date = line.Substring( 7, 17 );
			int result = String.CompareOrdinal( date, minAge );
			if (result < 0) 
			{	// Min Age specified in command line
				Console.WriteLine( "file: {0} too old, skipping it.", fi.FullName );
				candidateFile.Close();
				return( 0 );
			}
			Console.WriteLine( "Processing file: {0}", fi.FullName );
			candidateFile.Close();

			// make a local copy of the file -- avoids interlock with web server.
			Console.WriteLine( "about to copy {0}", fi.FullName );
			fi.CopyTo( "c:\\temp\\thakar\\weblog.txt", true );
			FileInfo ft = new FileInfo( "c:\\temp\\thakar\\weblog.txt" );
			StreamReader inStream  = ft.OpenText();
			FileInfo fo = new FileInfo("C:\\temp\\thakar\\bcp.tmp");
			StreamWriter outStream = fo.CreateText();
			while( (line = inStream.ReadLine()) != null )
			{	 
				// Console.WriteLine("input: {0}", line);
				if( (line.IndexOf("#") != 0) && (line.Length > 20) && (line.Length < 8000))
				{
					line = remap(line);  
					// convert to Fermi Normal form
					if (line.IndexOf("\t") != 0) 
					{  	
						// have some delimiters (not null).
						string outStr = Regex.Replace(date,"-","\t") + "\t" + count;
						outStr += "\t" + Regex.Replace( line, " ", "\t" );
						outStream.WriteLine( outStr );
						// Console.WriteLine( "output: {0}", line );
					}
				}
				if( line.Length >= 8000) Console.WriteLine( "Line too long (more than 8K chars): {0}", line );
				count +=  1;
			}
			inStream.Close();  
			outStream.Close();
			ft.Delete();	// do not need the copy anymore
			return( count );
		}

		public static string remap( string line )
		{
			string ans = "";
			string next = "";
			int matchLen = 9;
			Regex re = new Regex( "[^ ]+",RegexOptions.Compiled&RegexOptions.Singleline&RegexOptions.IgnoreCase );
			Regex code = new Regex( "^[0-9]{3}$",RegexOptions.Compiled&RegexOptions.Singleline&RegexOptions.IgnoreCase );
			MatchCollection MatchList = re.Matches(line);
			if( MatchList.Count < 9 )
				Console.WriteLine("Match count = {0}",MatchList.Count );
			if( MatchList.Count < 9 ) return "";
			if ((next = MatchList[0].Value) == null) return "" ;
			if ((next = MatchList[1].Value) == null) return "" ;
			ans = ans +  next;   				  	  // hh
			if ((next = MatchList[2].Value) == null) return "" ;
			ans = ans + "\t" + next;   				  // ipaddr
			if ((next = MatchList[3].Value) == null) return "" ;
			if ((next = MatchList[4].Value) == null) return "" ;
			if ((next = MatchList[5].Value) == null) return "" ;
			if ((next = MatchList[6].Value) == null) return "" ;   // get, post,...
			ans = ans + "\t" + next;  
			if ((next = MatchList[7].Value) == null) return "" ;   // url
			ans = ans + "\t" + next;  
			if ((next = MatchList[8].Value) == null) return "" ;   // param string or error code
			if (!code.IsMatch(next))
			{
				ans = ans + "?" + next;
				matchLen = 10;
				if( MatchList.Count < matchLen || (next = MatchList[9].Value) == null ) return "" ;
			} 	
			ans = ans + "\t" + next;					  // code
			if( MatchList.Count < (matchLen+1) || (next = MatchList[matchLen].Value) == null ) return "" ;   // browser
			ans = ans + "\t" + next; 
			return ans;
		}

		public static void Usage()
		{
			Console.WriteLine("Loads IIS log files into local SQL Server WebLog.dbo.WeblogTemp table."); 
			Console.WriteLine("Usage: bcpWeblog <directory>  MinAge [-SupressBcp]");
			Console.WriteLine("bcpWeblog c:\\windows\\system32\\logfiles 2002-02-15 -SupressBcp " );
			Environment.Exit(1);
		}
	}
}
