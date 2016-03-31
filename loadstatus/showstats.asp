<!-------#include file="header.inc"--------->
<%
	var key = new String();
	for(var i=0; i<Request.QueryString.Count;i++) {
		key = Request.QueryString.Key(i+1);
		key = key.toLowerCase();
//		if(key=="show") show = String(Request.QueryString(key));
	}
%>
<div id="title">Statistics</div>
<!-------#include file="x-utilities.js"------>
<!-------#include file="ex-functions.js"------>
<!-------#include file="writeoutput.js"------>
<!-------#include file="connection.js"------>
<div id="transp" class="med">
<table width=500 cellpadding=0 cellspacing=5>
<tr><td colspan=2 align='middle' class='h'><b>Finished Tasks only</b></td></tr>
<tr><td align='middle' class='b'>Total and average time (sec) per Step</td>
<td align='middle' class='b'>Total and average time (sec) per Table</td></tr>
<tr valign=top><td align='middle'>
<%
	var cmd = "EXEC dbo.spShowStepStats ";
	showHTable(oCmd, cmd, 250);
%>
</td><td align='middle'>
<%
	var cmd = "EXEC dbo.spShowFileStats ";
	showHTable(oCmd, cmd, 250);
	
%>
</td></tr>
</table>
</div>
</body>
</html>
