<!-------#include file="header.inc"--------->
<%
function listServers(oCmd) {

	oCmd.CommandText = "EXEC dbo.spShowServers";
	var oRs = oCmd.Execute();
	if (oRs.eof) return null;
	
 	while(!oRs.eof) {
		var name  = stringOf(oRs.fields(0));
		var role  = stringOf(oRs.fields(1));
		var state = stringOf(oRs.fields(2));
		showServer(name,role,state);
		oRs.MoveNext();
	}
		
	oRs.close();
}

function showButton(server,role,name,state) {
	var s= "    <input type=button value='"+name+"'";
	s += " onClick='setstate(\""+server+"\",\""+role+"\",\""+name+"\") ' ";
	s += (String(state).toLowerCase()==String(name).toLowerCase()?"DISABLED":"")+">\n";
	return s;
}

function showServer(name,role,state) {
	var s = "";
	role += " ";
	s += "<tr><td><table width=240 border=2 bgcolor=#d6d3ce><tr><td>\n";
	s += "<table bgcolor=#d6d3ce>\n";
	s += "<tr><td width=240 align='middle'>\n"
    s += "<font color=black size=+1><b>"+name+"</b></font></td>";
    s += "<td rowspan=3 width=80><img src='img/"+state;
    s += ".gif' width='80' height='100'></td></tr>\n";
    s += "<tr><td align='middle' class='bsml'><b>"+role+"</b></td></tr>\n";
	s += "<tr><td align='middle'>\n";
    s += showButton(name,role,"Run",state);
    s += showButton(name,role,"Halt",state);
    s += showButton(name,role,"End",state);
    s += "</td></tr></table>\n"
    s += "</td></tr></table></td></tr>\n"
	Response.Write(s);
}

%>
<div id="title">Servers</div>
<!-------#include file="x-utilities.js"------>
<!-------#include file="connection.js"------>
<script>
    function setstate(server,role,newstate) {
		var w = window.open("setserverstate.asp?server="
			+server+"&role="+role+"&state="+newstate,
			"NEXT","width=240,height=100");
    }   
</script>

<div id="transp" class="med">
<table width=500>
<%

listServers(oCmd);

%>
</table>
</div>
</body>
</html>
