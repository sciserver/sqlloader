<!-------#include file="header.inc"--------->
<%
	var show  = "";
	var key = new String();
	for(var i=0; i<Request.QueryString.Count;i++) {
		key = Request.QueryString.Key(i+1);
		key = key.toLowerCase();
		if(key=="show") show = String(Request.QueryString(key));
	}
	if (show=="") show="Active";
%>
<div id="title"><%=show%> Tasks</div>
<!-------#include file="x-utilities.js"------>
<!-------#include file="writeoutput.js"------>
<!-------#include file="connection.js"------>
<script>
    function kill(id) {
        var pos = ",left="+(window.screenLeft+100);
        pos    += ",top="+(window.screenTop+100);
		var w = window.open('confirm-undo.asp?kill='+id,'UNDO',
		    "width=240,height=120"+pos);
		w.focus();
    }
</script>

<div id="transp" class="med">
<table width=640>
<tr><td>
  <table width=320>
    <tr>
		<td align='middle' class='sml' width=50>Queued</td>
		<td align='middle' class='sml' width=50>Working</td>
		<td align='middle' class='sml' width=50>Done</td>
		<td align='middle' class='sml' width=50>Aborting</td>
		<td align='middle' class='sml' width=50>Killed</td>
		<td align='middle' class='sml' width=50>N/A</td>
	</tr>
    <tr>
		<td class='u'>&nbsp;</td>
		<td class='y'>&nbsp;</td>
		<td class='g'>&nbsp;</td>
		<td class='r'>&nbsp;</td>
		<td class='k'>&nbsp;</td>
		<td class='x'>&nbsp;</td>
	</tr>
  </table>
</td></tr>
<tr><td>
<%
	var cmd = "EXEC dbo.spShowTask '"+show+"'";
	writeTasks(oCmd, cmd, 0);
%>
</td></tr>
</table>
</div>
</body>
</html>
