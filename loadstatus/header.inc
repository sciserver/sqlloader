<%  @LANGUAGE="JScript" %>
<html>
<head>
<title>SDSS Load Monitor</title>
<!-------#include file="x-utilities.js"--------->
<link href="loadserver.css" rel="stylesheet" type="text/css">
<%
    function autoRefresh() {
	var host = Request.ServerVariables("SERVER_NAME");	
	var path = Request.ServerVariables("SCRIPT_NAME");
	var qry	 = Request.ServerVariables("QUERY_STRING");
	var root = "http://"+host+path;
	if (qry != "") root += "?"+qry;

	var s = "<META HTTP-EQUIV=\"refresh\"";
	s += " CONTENT=\"60;URL="+root+"\">"

	// do not refresh data entry pages

	if (	(String(path).indexOf("newtask.asp")==-1 )
	     && (String(path).indexOf("upload.asp")==-1 )
	   )
		Response.Write(s+"\n");

    }
    autoRefresh();
%>
</head>
<body>
<div id="logo"><IMG src="img/sdss-main-logo.jpg" border="0"></div>

<div id="navibar">
<!-------#include file="connection.js"--------->
<%
    var cmd = "select value from Constants where name='version'";
    oCmd.CommandText = cmd;
    var oRs = oCmd.Execute();
    var version = getValue(oRs,0);
%>
<table width=540>
  <tr><td>sqlLoader &nbsp;<%=version%></td>
      <td class="sml">|&nbsp; 
		<a target="_top" href="default.asp">Home</a> |
		<a target="_top" href="docs.asp">Help</a> |
		<a target="_top" href="faq.asp">FAQ</a> |
<!--		<a target="_top" href="showservers.asp">Servers</a> |   -->
		<a target="_top" href="showstats.asp">Stats</a> |
		<a target="_top" href="showerrors.asp?show=error">Error</a> |
		<a target="_top" href="showerrors.asp?show=warning">Warning</a> |
<!--		<a target="_top" href="newtask.asp">New Task</a> |
		<a target="_top" href="upload.asp">Upload</a> |
  </td></tr>
  <tr><td></td><td class="sml">|&nbsp; 
-->
		<a target="_top" href="tasklist.asp">Active Tasks</a> |
		<a target="_top" href="tasklist.asp?show=Finished">Finished</a> |
<!--		<a target="_top" href="tasklist.asp?show=Destination">Destinations</a> |   ->
		<a target="_top" href="tasklist.asp?show=Killed">Killed</a> |
<!--		<a target="_top" href="tasklist.asp?show=Null">Null Task</a> |  -->
		<a target="_top" href="tasklist.asp?show=All">All Tasks</a> |
  </td></tr>
</table>
</div>
