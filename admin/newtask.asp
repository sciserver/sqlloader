<!-------#include file="header.inc"--------->
<!-------#include file="x-utilities.js"--------->
<!-------#include file="connection.js"--------->

<div id="title">Add New Task</div>
<div id="transp" class="med">
<form method='get' name='newtask' action='add.asp'>
  <table width=440>
    <tr><td colspan=2 class='sml'>All fields with a (*) must be set</td></tr>
    <tr><td colspan=2><hr></td></tr>
    <tr><td class='med'>dataset*</td>
		<td><select name=dataset>
<%
	var cmd = "select value from Constants where name='dataset'";
	oCmd.CommandText = cmd;
	try	{
		var oRs = oCmd.Execute();
		var i = 0;
		while(!oRs.eof) {
			var c = getValue(oRs,0);
			Response.Write("<option value='"+c+"'>"+c+"\n");
			oRs.MoveNext();
		}
		oRs.close();
	}
	catch(e) {
		var c = "No path found";
		Response.Write("<option value='"+c+"'>"+c+"\n");
	}
%>		
				</option>
		</select></td></tr>
    <tr><td class='med'>export type*</td>
		<td><select name=xtype>
				<option value="BEST" selected>BEST
				<option value="RUNS">RUNS
				<option value="TARGET">TARGET
                        <option value="SSPP">SSPP
                        <option value="GALSPEC">GALSPEC
				<option value="MASK">MASK
				<option value="PLATES">PLATES
				<option value="TILES">TILES
				<option value="WINDOW">WINDOW
				<option value="WISE">WISE
				<option value="FINISH">FINISH			
				</option>
		</select></td></tr>
    <tr><td class='med'>xroot*</td>
		<td><select name=xroot>
<%
	var cmd = "select value from Constants where name='csvpath'";
	oCmd.CommandText = cmd;
	try	{
		var oRs = oCmd.Execute();
		var i = 0;
		while(!oRs.eof) {
			var c = getValue(oRs,0);
			Response.Write("<option value='"+c+"'>"+c+"\n");
			oRs.MoveNext();
		}
		oRs.close();
	}
	catch(e) {
		var c = "No path found";
		Response.Write("<option value='"+c+"'>"+c+"\n");
	}
%>		
				</option>
		</select></td></tr>

<tr><td class='med'>task path*</td>
		<td><select name=taskdatapath>
<%
	var cmd = "select value from Constants where name='taskdatapath'";
	oCmd.CommandText = cmd;
	try	{
		var oRs = oCmd.Execute();
		var i = 0;
		while(!oRs.eof) {
			var c = getValue(oRs,0);
			Response.Write("<option value='"+c+"'>"+c+"\n");
			oRs.MoveNext();
		}
		oRs.close();
	}
	catch(e) {
		var c = "No path found";
		Response.Write("<option value='"+c+"'>"+c+"\n");
	}
%>		
				</option>
		</select></td></tr>
    <tr><td class='med'>xid*     </td><td><input size=40 type="text" name="xid"></td></tr>
    <tr><td class='med'>user*    </td><td><input size=40 type="text" name="user"></td></tr>
    <tr><td class='med'>comment  </td><td><textarea cols=33 rows=4
		name="comment"></textarea></td></tr>
    <tr><td></td><td><input type="submit" value="submit" id=submit1 name=submit1></td></tr>

    <tr><td colspan=2><hr></td></tr>
    <tr><td colspan=2 class='sml'><b>Insert directly as:</b><br>
    <font color=#000000>
    http://loadserver/admin/add.asp?xtype=RUNS&xid=1359&xroot=\\sdssdp8\imagingRoot\csv\&user=alex&comment=none
    </font>
    </td></tr>

  </table>
</form>
</div>
</body>
</html>




