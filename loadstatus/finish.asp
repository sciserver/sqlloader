<!-------#include file="header.inc"--------->
<!-------#include file="x-utilities.js"--------->
<!-------#include file="connection.js"--------->

<div id="title">Manage Finish Steps</div>
<div id="transp" class="med">
<form method='get' name='finish' action='finishstep.asp'>
  <table width=440>
    <tr><td colspan=2 class='med'>This page lets you resume a FINISH task that did not complete, by rerunning 
            individual steps in the Finish processing.</td></tr>
    <tr><td colspan=2><hr></td></tr>
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
<!--			<option value="BOTH" selected>Both (BEST and TARGET)</option>  -->
			<option value="BEST">BEST</option>
			<option value="TARGET">TARGET</option>
			<option value="RUNS">RUNS</option>
		</select></td></tr>
    <tr><td class='med'>FINISH step*</td>
		<td><select name=step>
<!--			<option value="ALL" selected>ALL (Entire FINISH)</option>  -->
			<option value="DropIndexAll">Drop Indices</option>
			<option value="LoadPhotoTag">Load PhotoTag</option>
			<option value="BuildPrimaryKeys">Build Primary Keys</option>
			<option value="BuildIndices">Build Indices</option>
			<option value="BuildForeignKeys">Build Foreign Keys</option>
			<option value="BuildNeighbors">Compute Neighbors</option>
			<option value="BuildMatchTables">Build Match Tables</option>
			<option value="RegionSectorsWedges">Compute Regions & Sectors</option>
			<option value="Synchronize">Synchronize Spectra</option>
			<option value="BuildFinishIndices">Build Finish Indices</option>
			<option value="MatchTargetBest">Build Target to Best</option>
		</select></td></tr>
    <tr><td class='med'>execution mode*</td>
		<td><select name=xmode>
			<option value="Single" selected>Single Step</option>
			<option value="Resume">Resume</option>
		</select></td></tr>
    <tr><td class='med'>user*    </td><td><input size=40 type="text" name="user"></td></tr>
    <tr><td class='med'>comment  </td><td><textarea cols=33 rows=4
		name="comment"></textarea></td></tr>
    <tr><td></td><td><input type="submit" value="submit" id=submit1 name=submit1></td></tr>

    <tr><td colspan=2><hr></td></tr>
    <tr><td colspan=2 class='sml'><b>Insert directly as:</b><br>
    <font color=#000000>
    http://loadserver/admin/addfinish.asp?dataset=DR2&xtype=BEST&step=ALL&xmode=Single&user=jdoe&comment=none
    </font>
    </td></tr>

  </table>
</form>
</div>
</body>
</html>


