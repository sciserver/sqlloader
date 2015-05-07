<%  @ LANGUAGE="JScript" %>
<% 
//---------------------------------------------------------
//	setSid.asp
//	Alex Szalay, 12/24/01, Baltimore
//	select an object by its SpecObjId
//---------------------------------------------------------
	var keyValue  = "";
	var key = new String();
	for(var i=0; i<Request.QueryString.Count;i++) {
		key = Request.QueryString.Key(i+1);
		key = key.toLowerCase();
		if(key=="key") keyValue = String(Request.QueryString("key"));
	}

%>

<html>
<head>
<title>Key Value</title>
<style>
  #logo		{position: absolute; top:  6px;left: 6px;}
  #ctrl		{position: absolute; top: 80px;left: 6px;}
  #buttons	{position: absolute; top:180px;left:16px;}
  .wtxt		{font-family:sans-serif;font-size:9pt;color:#ccccff;}
</style>
<script>
    function press_ok() {
		var f = (document.layers)? document.ctrl.document.forms[0]: document.forms[0];
		window.close();
		w.focus();
		return;
    }

	function init() {
    }

</script>
<title>Key Value</title>
</head>

<body bgcolor=#000000 text=White topmargin=0 leftmargin=10 onLoad="init()">

<table cellspacing="12">
<tr><td class="wtxt">
	Key Value:<b> <%=keyValue%></b>
    </td>
</tr>
<tr><td align=middle><a href=# onCLick="press_ok();"><button>Ok</a></td>		</tr>
	</table>
</body>
</html>
