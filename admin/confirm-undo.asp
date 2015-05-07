<%  @ LANGUAGE="JScript" %>
<% 
//---------------------------------------------------------
//	setEq.asp
//	Alex Szalay, 12/24/01, Baltimore
//	enter equatorial coordinates of a PhotoObj
//---------------------------------------------------------
	var id = "";
	var kill = "";
	var key = new String();
	for(var i=0; i<Request.QueryString.Count;i++) {
		key = Request.QueryString.Key(i+1);
		key = key.toLowerCase();
		if(key=="id") id = String(Request.QueryString(key));
		if(key=="kill") kill = String(Request.QueryString(key));
	}
	var str = (kill==0)? "Undo last step of Task#"+id: "Kill Task#"+kill;
	var link = (kill==0)? "id="+id:"kill="+kill;
%>

<html>
<head>
<title>Confirm Undo</title>
<link href="loadserver.css" rel="stylesheet" type="text/css">
<style>
  .wtxt	 {font-family:sans-serif;font-size:9pt;color:#ccccff;}
  body {background-color:#bb0000;}
</style>
<script>

    function press_cancel() {
	    window.close();
    }

    function press_ok(p) {
		document.location.href ="undostep.asp?"+p;

    }
</script>
<title>Popup</title>
</head>
<body topmargin=20 leftmargin=2 bgcolor=red>
	<table width=210 border=0>
		<tr><td align=middle colspan=2>
		<%=str%>?
		</td></tr>
		<tr><td colspan=2>&nbsp;</td></tr>
		<tr><td align=middle>
		   <input type="button" onClick='press_ok("<%=link%>");' value="    Ok    " id=button1 name=button1>
		</td>
		<td align=middle>
		   <input type="button" onClick="press_cancel();" value="Cancel" id=button2 name=button2>
		</td>
		</tr>
	</table>
</body></html>
