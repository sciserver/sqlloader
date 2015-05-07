<%
function taskbar(taskid) {
    Response.Write("<div id='taskbar' class='sml'> | \n");
	Response.Write("  <a href='showtask.asp?id="+taskid+"'>Task</a> | \n");
	Response.Write("  <a href='showsteps.asp?id="+taskid+"'>Steps</a> | \n");
	Response.Write("  <a href='showfiles.asp?id="+taskid+"'>Files</a> | \n");
	Response.Write("  <a href='showlog.asp?id="+taskid+"'>Log</a> | \n");
    Response.Write("</div>\n");
}



function showStatus(step,status,taskstatus,tid) {
    var w = ["EXPORT","CHECK","BUILD","PRELOAD","VALIDATE","BACKUP","DETACH","PUBLISH","CLEANUP","FINISH"];
    var c = ["x","x","x","x","x","x","x","x","x","x"];
    var state = 0;
    
    for(i=0;i<c.length;i++)  if (step==w[i]) state = 2*i;
    
    if (String(status).indexOf("ABORT")!= -1) state=-state;
    if (String(status).indexOf("WORKING") != -1) state -= 1;
    if (String(status).indexOf("START") != -1) state -= 1;
    
    var m = Math.abs(state);
    var mx = m/2+1;
    for (i=0;i<mx;i++) c[i] = "g";
    if (state%2!=0 && state<0) c[i-1] = "u";
    if (state%2!=0 && state>0) c[i-1] = "y";
    if (state%2==0 && state<0) c[i-1] = "r";
    if (state==0 && String(status).indexOf("ABORT")!= -1) c[i-1]="r";
    if (taskstatus=="KILLED")  c[i-1] = "k";

    var img = "<img border=0 width=20 height=16 src='img/x.gif'>"; 		
    for (i=0;i<c.length;i++)
		Response.Write("<td class='"+c[i]+"'>"+img+"</td>\n");
}

function showStep( oCmd, cmd, w  ) {   
	
    oCmd.CommandText = cmd;
	var oRs = oCmd.Execute();
	if (oRs.eof) return null;
		
	var val,i,c;
	Response.Write("<table cellpadding=2 cellspacing=2 border=0");
	if (w>0)
		Response.Write(" width="+w);
	Response.Write(">\n");

	Response.Write("<tr class='med'>");
	for(i=0; i <(oRs.fields.count); i++)
   		Response.Write("<td align='middle' class='h'>"+oRs.fields(i).name+"</td>");
	Response.Write("</tr>\n");
	
   	c = 't';
   	while(!oRs.eof) {
		Response.Write("<tr class='med'>");
		for(i=0; i<(oRs.fields.count); i++){
			val = stringOf(oRs.fields(i));
			if (oRs.Fields(i).name=="link") {
				var link = val;
			}
   			Response.Write("<td nowrap align='middle' class='"+c+"'>"+(val==""?"&nbsp;":val)+"</td>")
   		}
		Response.Write("</tr>\n");
		c = (c=='t'?'b':'t');
		oRs.MoveNext();
	}	
   	Response.Write("</table>\n");
   	//Response.Write("</div>\n");
	oRs.close();
	return link;
}


function writeTasks(oCmd, cmd, flag) {
	oCmd.CommandText = cmd;
	var i, j=0;

	try	{
		var oRs = oCmd.Execute();

		// start writing table of attributes, if there are any

	    if (oRs.eof) {
 		    Response.Write("<h3><br><font color=red>No tasks have been found</font> </h3>");
	    } else {

   		Response.Write("<table border='1'>\n<tr>\n");

		var s = "  <td class='hsml' align='center'>";
		var q = "</td>\n";
		var w = ["taskid","dbname","server","&nbsp;","&nbsp;","&nbsp;",
			"step","status","type",
			"EXP","CHK","BLD","SQL","VAL","BCK","DTC","PUB","CLN","FIN",
			"date"];

		for(i=0;i<w.length;i++)
			Response.Write(s+w[i]+q);

		if (flag==1) {
			Response.Write(s+"&nbsp;"+q);			
		}
			
		Response.Write("</tr>\n");
		
		// writes line for each object
		var c = "tsml";
     		while(!oRs.eof) {
			j++;
     			var taskid = oRs.fields(0);
     			var dbname = oRs.fields(1);
     			var step   = oRs.fields(2);
     			var status = oRs.fields(3);
     			var taskstatus = oRs.fields(4);
     			var type   = oRs.fields(5);
     			var tstamp = stringOf(oRs.fields.item(6));     			
     			var server = stringOf(oRs.fields.item(7));     			
     			Response.Write("<tr>");
				var s = "<td nowrap class='"+c+"'>";
				var r = "<td nowrap align='right' class='"+c+"'>";
				var q = "</td>";
				// show the details of the task
				Response.Write(r+taskid+q);
				Response.Write(s+"<a href='showTask.asp?id="+taskid
					+"'>"+dbname+"</a>"+q);
				Response.Write(s+server+q);
				Response.Write(s+"<a href='showsteps.asp?id="+taskid+"'>Steps</a>"+q);
				Response.Write(s+"<a href='showfiles.asp?id="+taskid+"'>Files</a>"+q);
				Response.Write(s+"<a href='showlog.asp?id="+taskid+"'>Log</a>"+q);

				Response.Write(s+step+q);
				Response.Write(s+taskstatus+q);
				Response.Write(s+type+q);
				showStatus(step,status,taskstatus,taskid);
				Response.Write(s+tstamp+q);
				if (flag==1) {
					Response.Write(s+"<a href='javascript:kill("+taskid+")'>Kill</a>"+q);
				}
				
          		Response.Write("</tr>\n");
				c = (c=="tsml"?"bsml":"tsml");
				oRs.MoveNext();
    		}
		Response.Write("</table>");
		if( j > 1 ) {
		    Response.Write("<h3>"+j+" tasks found</h3>");
		} else {
		    Response.Write("<h3>"+j+" task found</h3>");
		}
     	    }
	    Response.Write("</BODY></HTML>\n");
	    oRs.close();
	} 
	catch(e) {	
		if (status == "none") {
			Response.Write("<H3>Your SQL command was: <BR><PRE>" + oCmd.CommandText+"</PRE></H3><P>"); // writes command
 		} else { 
 			Response.Write("</td></tr></table>");
 		}
 		Response.Write("<H3 BGCOLOR=pink>SQL returned the following error: <br>     " + e.description);
 		Response.Write("</H3></BODY></HTML>\n");
 		format = "error";
 	}
}
%>