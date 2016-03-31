<!-------#include file="header.inc"---------->
<!-------#include file="x-utilities.js"------>
<!-------#include file="x-upload.js"--------->
<!-------#include file="connection.js"------->

<div id="title">Upload Finish Steps</div>
<div id="transp">
<table BORDER=0 WIDTH="640" cellpadding=4 cellspacing=10>
<%
//==============================================================

	var dbg		= 0;
	var count	= 0;
	var dataset 	= "";
	var xtype	= "";
	var step	= "";
	var xmode	= "";
	var user	= "";
	var comment = "";
	var path	= "";
	var xid = "";
	var sep = "\\";
	

	//	read in query if given by forms  

	dataset	= Request.Form("dataset");	
	xtype	= Request.Form("xtype");
	xmode	= Request.Form("xmode");
	step	= Request.Form("step");
	user	= Request.Form("user");
	comment	= Request.Form("comment");

	//read query if given by query string

	var key = new String();
	for(var i=0; i<Request.QueryString.Count;i++) {
		key = Request.QueryString.Key(i+1);
		key = key.toLowerCase();
		if(key=="dataset") dataset = String(Request.QueryString(key));
		if(key=="xtype") xtype = String(Request.QueryString(key));
		if(key=="step")	step   = String(Request.QueryString(key));
		if(key=="xmode") xmode = String(Request.QueryString(key));
		if(key=="user")  user  = String(Request.QueryString(key));
		if(key=="comment") comment = String(Request.QueryString(key));
	}
	
	// change the /characters to \ in the host and path, if any
	xtype = xtype.toLowerCase();
	
	// clean up the illegal HTML characters, if any
	comment = translateforbiddenchars(comment);
    
	var taskid = taskExists(oCmd, xid, dataset, "finish");

	if (taskid != 0) {
		var pmt = [dataset,xtype,step,xmode,user,comment];
		showLine("<tr><td><table width=640 cellpadding=2 cellspacing=2>");
		showTask(pmt);
		uploadFinishTask(oCmd, taskid, pmt);
		showLine("</table></td></tr>");
	} else {
		showLine( "<tr><td>The FINISH task does not exist!</td></tr>" );
	}
%>
