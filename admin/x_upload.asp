<!-------#include file="header.inc"---------->
<!-------#include file="x-utilities.js"------>
<!-------#include file="x-upload.js"--------->
<!-------#include file="connection.js"------->

<div id="title">Uploading Tasks</div>
<div id="transp">
<table BORDER=0 WIDTH="640" cellpadding=4 cellspacing=10>
<%


//#######################################################################################

	// we really use this
	var rxComment = /^\#/
	var reBlank = /^\s*/

	var dbg = 0;

	var f = getUpload();
    var u = f.upload;
	var b = f.upload.body
	
    var count = 0;
    var commentline = "";
    
    for (var j in b) {
		var pmt = parseLine(b[j]);
		if (pmt!=null) {
		    showLine("<tr><td><table width=640 cellpadding=2 cellspacing=2>");
			showTask(pmt);
			uploadTheTask(oCmd, pmt);
			showLine("</table></td></tr>");
		}
	}			
    showLine("<tr><td><b>Total number of Tasks uploaded is "+count+"</b></td><tr>");

%>
</table>
</div>
</body>
</html>
