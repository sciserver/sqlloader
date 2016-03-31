<%

//---------------------------------------
// upload and task specific functions
//---------------------------------------

function parseLine(s) {

	// echo the comment lines in one chunk

	if (s.match(/^\#/)) {
		commentline += s + "<br>\n";
		return null;
	} else {
		showLine("<tr><td class='sml'>"+commentline+"</td></tr>");
		commentline = "";
	}
	
	// proceed with the rest
	showLine("<tr><td class='hsml'>"+s+"</td></tr>");
	
	var c = s.split(/,/);
	for (var i=0;i<4;i++)
		s	= s.replace(c[i],"");
	s = s.replace(/^,*/,"");
	s = s.replace(/\"/g,"");

	var dataset 	= c[0].toUpperCase();
	var xtype	= c[1].toUpperCase();
	var path	= c[2];
	var user	= c[3];
	var comment	= s;
	comment = translateforbiddenchars(comment);

	var p = path.split(/\\/);
	var n = p.length;
	
	var xid   = p[n-1];
	// var xtype = p[n-2].toUpperCase();
	// for(i=0;i<3;i++) path = path.replace("\\"+p[n-1-i],"");

	if (xtype.match(/^FINISH$/)!=null) path = "\\\\\\\\";

	if (dataset.match(/^(TEST|DR1|DR1C|DR2|DR3|DR4|DR5|DR6)$/)==null)
		return Error("dataset "+dataset+" not one of (TEST|DR1|DR1C|DR2|DR3|DR4|DR5|DR6|DR7|DR8|DR9)");
	if (xtype.match(/^(BEST|TARGET|RUNS|PLATES|GALSPEC|TILES|WINDOW|SSPP|FINISH)$/) == null)
		return Error("xtype "+xtype +" not one of (BEST|TARGET|RUNS|PLATES|GALSPEC|TILES|WINDOW|SSPP|FINISH)");
	if (path.match(/^\\\\.*\\$/)==null)
		return Error(path+" is not a valid UNC path like \\\\host\\dir\\");
	if (user=="")
		return Error("user must be specified");
		
	return [xid,dataset,xtype,path,user,comment];	
}


function uploadTheTask(oCmd,q) {
    
    // does the task already exist?
	
	var taskid = -1;
	taskid = taskExists(oCmd,q[0], q[1], q[2]);
	if (taskid>0) return null;
       
	var cmd = "EXEC dbo.spUploadTask";
	cmd += " '"+q[0]+"',";
	cmd += " '"+q[1]+"',";
	cmd += " '"+q[2]+"',";
	cmd += " '"+q[3]+"',";
	cmd += " '"+q[4]+"',";
	cmd += " '"+q[5]+"'";
	
	showLine("<tr><td colspan=2 class='t'>Uploading the task "+q[0]+"</td></tr>");
//	showLine(cmd);
		
	oCmd.CommandText = cmd;
	oCmd.CommandTimeout = 1000;
	var oRs = oCmd.Execute();

	if (!oRs.eof) {
		var result = stringOf(oRs.fields(0));
		if (result.indexOf("succe")>0) count += 1;
		showLine("<tr><td colspan=2 class='t'>"+result+"</td></tr>");	
	} else 
		return null;
}


function uploadFinishTask(oCmd, taskid, q) {
    
	// does the task already exist?
	
//	var taskid = -1;
//	taskid = taskExists(oCmd,q[0], q[1], q[2]);
//	if (taskid==0) return null;
       
	var cmd = "EXEC dbo.spUploadFinishStep";
//	cmd += " '"+q[0]+"',";
	cmd += " "+taskid+",";
	cmd += " '"+q[0]+"',";
	cmd += " '"+q[1]+"',";
	cmd += " '"+q[4]+"',";
	cmd += " '"+q[2]+"',";
	cmd += " '"+q[3]+"',";
	cmd += " '"+q[5]+"'";
	
	showLine("<tr><td colspan=2 class='t'>Uploading the task "+q[0]+"</td></tr>");
	showLine("taskid="+taskid+","+cmd);
		
	oCmd.CommandText = cmd;
	oCmd.CommandTimeout = 1000;
	var oRs = oCmd.Execute();

	if (!oRs.eof) {
		var result = stringOf(oRs.fields(0));
		if (result.indexOf("succe")>0) count += 1;
		showLine("<tr><td colspan=2 class='t'>"+result+"</td></tr>");
	} else 
		return null;
   
}


function taskExists(oCmd, xid, dataset, xtype) {

	var taskid = 0;


//	showLine(dataset);
//	showLine(xid);
//	showLine(xtype);
//	return 1;

	var dbname = "%"+dataset.toUpperCase()+"_"
		+xtype.toUpperCase().substr(0,4)
		+xid.toUpperCase() +"%";
	dbname = dbname.replace(/-/g,'_');	

	var cmd	= "SELECT taskid from Task where dbname like '"+dbname;
		cmd		+= "' and taskstatus <> 'KILLED'";

	oCmd.CommandText = cmd;
	var oRs = oCmd.Execute();
	
	if (!oRs.eof) {
		taskid = oRs.Fields(0).value;    
		Response.Write("<tr><td colspan=2 class='t'><a href='showTask.asp?id="
			+taskid+"' class='t'> This task already exists</a></td></tr>\n");
	}		
	oRs.close();
	return taskid;
}

//---------------------------------
// create Form class
//---------------------------------

function Form(n) {
	this.name  = n;
	this.type  = "";
	this.value = "";
	this.body  = new Array();
}

Form.prototype.Add = function(s) {
	var n = this.body.length;
	this.body[n] = s;
	if (n==0) this.value = this.body[n];
}

function getName(s) {
		var n = s.indexOf("name=");
		return s.substring(n+6,s.indexOf("\"",n+7));
}

function getType(s) {
		var n = s.indexOf("Type:");
		return s.slice(n+6);
}

function getForms(buf) {
//----------------------------------
// Extract the forms from the buffer
// Add name, type, value and body
//----------------------------------
	var lines = buf.split(/\r*\n/);
	var b = lines[0];
	var f = new Array();
	var s,n;
	
	for	(var i=0;i<lines.length; i++) {
		s = String(lines[i]);
		if (s.indexOf(b)!=-1 ) {		// multiform boundary marker
			// just skip it
		} else if (s.indexOf("Content-Disposition:")!=-1) {
			n = getName(s);
			f[n] = new Form(n);
		} else if (s.indexOf("Content-Type:")!=-1) {
			f[n].type = getType(s);
		} else if (s.replace(reBlank,"") != "") {
			f[n].Add(s);
		}
	}
	return f;
}


function getUpload() {

	// check that total upload size < 100KB	
		if (Request.TotalBytes>100000)
			return Error("upload is larger than 100KB!");

	// size is ok, process the upload
		var buf = String(makeStrB(Request.BinaryRead(Request.TotalBytes)));
		var f = getForms(buf);	

	// check whether at least one of the two sources is set
		if (f.upload.body.length==0 && f.paste.body.length==0)
			return Error("need either paste or upload!");

	// if there is a file, it takes precedence. Is it the correct type?	

		if (f.upload.body.length>0) {
			if (f.upload.type != "text/plain") 
				return Error("upload not a text file but "+ f.upload.type);

		// it is a text file, we process it.
			upload = f.upload.body;

		} else {				
		// there is no file, but there is paste 
			f.upload.body  = f.paste.body;
			f.upload.value = f.paste.value;
			f.upload.type  = "";
		}
	delete f.paste;
	return f;		
}


//-------------------------------------------------
// Utility functions
//-------------------------------------------------

function showLine(s) {
	Response.Write(s+"\n");
}

function translateforbiddenchars(input) {
    var out = input;
     
    out = out.replace(/&/g,'&amp;');
    out = out.replace(/</g,'&lt;');
	out = out.replace(/>/g,'&gt');
    out = out.replace(/"/g,'&quot;');
	out = out.replace(/'/g,'&#039;');
	return out;
}

function Error(msg) {
	showLine("<tr><td class='bsml'><font color=red>Error: "+msg+"</font></td></tr>\n");
	return null;
}

function sendSQL(oCmd,cmd) {
	if (dbg==1) showLine(cmd);
	
	oCmd.CommandText = cmd;
	var oRs = oCmd.Execute();
    if (!oRs.eof) {
		return stringOf(oRs.fields(0))
    }
    else return null;
}

function showTask(v) {
	if (v==null) return;
	//-----------------------------------------------
	showLine("<tr><td class='b'>xid     </td><td class='b'>"+v[0]+"</td></tr>");
	showLine("<tr><td class='b'>dataset </td><td class='b'>"+v[1]+"</td></tr>");
	showLine("<tr><td class='b'>xtype   </td><td class='b'>"+v[2]+"</td></tr>");
	showLine("<tr><td class='b'>path    </td><td class='b'>"+v[3]+"</td></tr>");
	showLine("<tr><td class='b'>user    </td><td class='b'>"+v[4]+"</td></tr>");
	showLine("<tr><td class='b'>comment </td><td class='b'>"+v[5]+"</td></tr>");
	//-----------------------------------------------
}

%>