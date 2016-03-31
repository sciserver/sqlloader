<%  @LANGUAGE="JScript" %>
<%
	var id  = 0;
	var kill= 0;
	var key = new String();
	for(var i=0; i<Request.QueryString.Count;i++) {
		key = Request.QueryString.Key(i+1);
		key = key.toLowerCase();
		if(key=="id")   id   = String(Request.QueryString(key));
		if(key=="kill") kill = String(Request.QueryString(key));
	}
%>
<!-------#include file="connection.js"------>
<html>
<body>
<%
	if (id!=0)   var cmd = "EXEC dbo.spUndoStep "+id;
	if (kill!=0) var cmd = "EXEC dbo.spKillTask "+kill;
	oCmd.CommandText = cmd;
	try	{
		var oRs = oCmd.Execute();
	}
	catch(e) {	
 	}

%>
<script>
	window.opener.location.href = "tasklist.asp";
    window.close();
</script>
</body>
</html>
