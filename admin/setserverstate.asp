<%  @LANGUAGE="JScript" %>
<%
	var server = "";
	var role   = "";
	var state  = "";
	
	var key = new String();
	for(var i=0; i<Request.QueryString.Count;i++) {
		key = Request.QueryString.Key(i+1);
		key = key.toLowerCase();
		if(key=="server") server = String(Request.QueryString(key));
		if(key=="role")   role   = String(Request.QueryString(key));
		if(key=="state")  state  = String(Request.QueryString(key));
	}
	
	state = String(state).toUpperCase();
	if (state != "RUN" && state != "HALT" && state != "END")
		state = "HALT";

%>
<html><body bgcolor='yellow' onLoad="window.close();">
Setting <%=server%>  state to <%=state%>
<!-------#include file="connection.js"------>
<%
	oCmd.CommandText = "EXEC spSetServer '"+server+"','"+role+"','"+state+"'";
	var oRs = oCmd.Execute(); 
%>
	
<script>
	window.opener.location.href = "showservers.asp";
</script>
</body>
</html>
