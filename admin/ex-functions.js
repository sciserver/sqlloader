<%

//-----------------------------------------------
// display functions
//-----------------------------------------------


function showVTable( oCmd, cmd, w ) {   
// show only one record, but vertically
    oCmd.CommandText = cmd;
    
//    Response.Write(cmd);  return;
    
	oCmd.CommandTimeout = 1000;
	var oRs = oCmd.Execute();
	if (oRs.eof) return null;
	
	var i,j,c;
	
	if (oRs.eof) {
    	Response.Write("No objects have been found<BR><P>");
	} else {
		//Response.Write("<div id=\""+div+"\">\n");
   		Response.Write("<table cellpadding=2 cellspacing=2 border=0 width="+w+">");
		c = 'b';
    	for(i=0; i<(oRs.fields.count); i++) {
	       	Response.Write("<tr align=left class='med'><td valign=top class='h'>");
			Response.Write(oRs.fields(i).name+"</td><td nowrap valign=top class='"+c+"'>");
        	Response.Write(getValue(oRs,i));
        	Response.Write("</td></tr>\n");
			c = (c=='t'?'b':'t');
     	}
    	Response.Write("</table>\n");
	}
	oRs.close(); 
}


function showHTable( oCmd, cmd, w  ) {   
	
    oCmd.CommandText = cmd;
	oCmd.CommandTimeout = 1000;
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
			if( oRs.fields(i).name=="status" && oRs.fields(i).value=="ERROR" )
	   			Response.Write("<td nowrap class='e'>"+(val==""?"&nbsp;":val)+"</td>")
			else {
				if( oRs.fields(i).name=="status" && oRs.fields(i).value=="WARNING" )
	   				Response.Write("<td nowrap class='w'>"+(val==""?"&nbsp;":val)+"</td>")
				else
	   				Response.Write("<td nowrap class='"+c+"'>"+(val==""?"&nbsp;":val)+"</td>")
			}
   		}
		Response.Write("</tr>\n");
		c = (c=='t'?'b':'t');
		oRs.MoveNext();
	}	
   	Response.Write("</table>\n");
   	//Response.Write("</div>\n");
	oRs.close();
}


function showFTable(oCmd,plateId) {
	
	var cmd = " select cast(specObjID as binary(8)) as specObjId,";
	cmd += " fiberId, dbo.fSpecClassN(specClass) as name, str(z,5,3) as z";
	cmd += " from SpecObjAll where plateID="+ plateId;

	oCmd.CommandText = cmd; 
	oCmd.CommandTimeout = 1000;
	var oRs = oCmd.Execute(); 
	var u = "<a target='_top' href='obj.asp?sid=";	var sid;
	
	var col=0;
	var row=0;
	var c ='st';
	Response.Write("<table>\n");
	Response.Write("<tr>");
	while(!oRs.eof) {
		sid   = u+getValue(oRs,0)+"'>";
		v = "["+getValue(oRs,1)+"]&nbsp;";
		v += getValue(oRs,2)+" z="+getValue(oRs,3);
		Response.Write("<td nowrap class='"+c+"'>"+sid+v+"</a></td>\n");
		oRs.MoveNext();
		if (++col>3) {
			col = 0;
			row++;
			Response.Write("</tr>\n<tr>\n");
			c = (c=='st'?'sb':'st');
		}
	}
	Response.Write("<td></td></tr>\n</table>\n");
	oRs.close();
}


function showNTable(oCmd,cmd) {
	

	oCmd.CommandText = cmd; 
	oCmd.CommandTimeout = 1000;
	var oRs = oCmd.Execute(); 
	var u = "<a target='_top' href='obj.asp?id=";	var id,c,v;
	
	Response.Write("<table cellpadding=2 cellspacing=2 border=0>");

	Response.Write("<tr>");
	for(i=0; i <(oRs.fields.count); i++)
   		Response.Write("<td align='middle' class='h'>"+oRs.fields(i).name+"</td>");
	Response.Write("</tr>\n");
	
   	c = 't';
   	while(!oRs.eof) {
		Response.Write("<tr>");
		id = getValue(oRs,0);
		for(i=0; i<(oRs.fields.count); i++){
			v = getValue(oRs,i);
   			v = (v==""?"&nbsp;":v);
   			Response.Write("<td nowrap align='middle' class='"+c+"'>");
			if (i==0) Response.Write(u+id+"'>"+id+"</a></td>");
			else Response.Write(v+"</td>");
   		}
		Response.Write("</tr>\n");
		c = (c=='t'?'b':'t');
		oRs.MoveNext();
	}	
   	Response.Write("</table>\n");
	oRs.close();
}

%>

