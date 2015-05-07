<!-------#include file="header.inc"--------->

<!-------#include file="x-utilities.js"------>
<!-------#include file="ex-functions.js"------>
<!-------#include file="writeoutput.js"------>
<!-------#include file="connection.js"------>
<%
	var id  = 0;
	var key = new String();
	for(var i=0; i<Request.QueryString.Count;i++) {
		key = Request.QueryString.Key(i+1);
		key = key.toLowerCase();
		if(key=="id") id = String(Request.QueryString("id"));
	}
%>
<div id="title">Files - Task #<%=id%></div>
<%
	taskbar(id);
%>
<div id="transp" class="med">
<table width=640>
<tr><td>
<%
	var cmd = "EXEC dbo.spShowFiles "+ id;
	showHTable(oCmd,cmd,640);
%>
</td></tr>
</table>
</div>

</body>
</html>
