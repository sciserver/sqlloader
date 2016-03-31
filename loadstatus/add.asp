<!-------#include file="header.inc"---------->
<!-------#include file="x-utilities.js"------>
<!-------#include file="x-upload.js"--------->
<!-------#include file="connection.js"------->

<div id="title">Uploading Tasks</div>
<div id="transp">
<table BORDER=0 WIDTH="640" cellpadding=4 cellspacing=10>
<%
//==============================================================

	var dbg		= 0;
	var count	= 0;
	var xid		= "";
	var dataset = "";
	var xtype	= "";
	var xroot	= "";
	var user	= "";
	var comment = "";
	var path	= "";

	var sep = "\\";
	

	//	read in query if given by forms  

	xid		= Request.Form("xid");
	dataset	= Request.Form("dataset");	
	xtype	= Request.Form("xtype");
	xroot	= Request.Form("xroot");
	user	= Request.Form("user");
	comment	= Request.Form("comment");

	//read query if given by query string

	var key = new String();
	for(var i=0; i<Request.QueryString.Count;i++) {
		key = Request.QueryString.Key(i+1);
		key = key.toLowerCase();
		if(key=="xid")	xid   = String(Request.QueryString(key));
		if(key=="dataset") dataset = String(Request.QueryString(key));
		if(key=="xtype") xtype = String(Request.QueryString(key));
		if(key=="xroot") xroot = String(Request.QueryString(key));
		if(key=="user")  user  = String(Request.QueryString(key));
		if(key=="comment") comment = String(Request.QueryString(key));
	}
	
	// change the /characters to \ in the host and path, if any
	xroot = String(xroot).replace(/\//g,"\\");
	xtype = xtype.toLowerCase();

	if (xtype.match(/^(best|target|runs)$/) != null)
		path = xroot+ "phCSV"+sep+xtype+sep+xid+sep;
	if (xtype=="plates" || xtype=="galspec")
		path = xroot+ "spCSV"+sep+xtype+sep+xid+sep;
	if (xtype=="tiles")
		path = xroot+ "tiCSV"+sep+xtype+sep+xid+sep;
	if (xtype=="window")
		path = xroot+ "wiCSV"+sep+xtype+sep+xid+sep;
      if (xtype=="sspp")
		path = xroot+ "ssppCSV"+sep+xtype+sep+xid+sep;
	if (xtype=="finish")
		path = "\\\\";
	
	// clean up the illegal HTML characters, if any
    comment = translateforbiddenchars(comment);
    
	var taskid = taskExists(oCmd, xid, dataset, xtype);

    if (taskid == 0) {
		var pmt = [xid,dataset,xtype,path,user,comment];
		
		showLine("<tr><td><table width=640 cellpadding=2 cellspacing=2>");
		showTask(pmt);
		uploadTheTask(oCmd, pmt);
		showLine("</table></td></tr>");

		
		//uploadTheTask(oCmd, pmt);
		//Response.Redirect("tasklist.asp");
	}
%>
