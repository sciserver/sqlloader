<!-------#include file="header.inc"--------->
<%
	var show  = "";
	var key = new String();
	for(var i=0; i<Request.QueryString.Count;i++) {
		key = Request.QueryString.Key(i+1);
		key = key.toLowerCase();
		if(key=="show") show = String(Request.QueryString(key));
	}
	if (show=="") show="Error";
	var flag = (show=="warning")?1:0;
%>
<div id="title">Errors</div>
<!-------#include file="x-utilities.js"------>
<!-------#include file="ex-functions.js"------>
<!-------#include file="writeoutput.js"------>
<!-------#include file="connection.js"------>
<div id="transp" class="med">
<table width=640>
<tr><td>
<%
	var cmd = "EXEC dbo.spShowErrors "+flag;
	showHTable(oCmd,cmd,640);
%>
</td></tr>
</table>
</div>

</body>
</html>
