<!-------#include file="header.inc"--------->
<%
	var id  = 0;
	var key = new String();
	for(var i=0; i<Request.QueryString.Count;i++) {
		key = Request.QueryString.Key(i+1);
		key = key.toLowerCase();
		if(key=="id") id = String(Request.QueryString("id"));
	}
%>
<div id="title">Log - Task #<%=id%></div>
<!-------#include file="x-utilities.js"------>
<!-------#include file="ex-functions.js"------>
<!-------#include file="writeoutput.js"------>
<!-------#include file="connection.js"------>
<% taskbar(id); %>
<div id="transp" class="med">
<table width=640>
<tr><td>
<%
	var cmd = "EXEC dbo.spShowPhase "+id;
	showHTable(oCmd,cmd,640);
%>
</td></tr>
</table>
</div>

</body>
</html>
