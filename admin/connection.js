<%
	//
	// the connection commands to the SkyServer database
	// change only this file in order to update connections
	//
	var oConn   = Server.CreateObject("ADODB.Connection"); 
	var oCmd    = Server.CreateObject("ADODB.Command");
	var strConn = "Provider=SQLOLEDB;User ID=webagent;Password=xxxxxx;";
	strConn	   += "Initial Catalog=loadsupport;Data Source=SDSSAD2";          
	oConn.Open(strConn);
	oCmd.ActiveConnection = oConn;
%>