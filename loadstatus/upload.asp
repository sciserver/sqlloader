<!-------#include file="header.inc"---------->
<div id="title">File Upload</div>
<div id="transp">
<FORM METHOD="post" ENCTYPE="multipart/form-data" ACTION="x_upload.asp" id=upload name="upload">

<table BORDER=0 WIDTH="440"  cellpadding=1 cellspacing=1>
	<tr><td>
		<p>&nbsp;<br>
		Cut and paste the list here:<br>
		<TEXTAREA cols=100 name=paste rows=8 wrap=virtual>
#
#this is a comment line
#
TEST,BEST,\\sxatlas\staging\loadtest\phCSV\best\1-43-278-938\,user,comment...
TEST,TARGET,\\sxatlas\staging\loadtest\phCSV\best\1-43-278-938\,user,no comment...
TEST,FINISH,\\,user,finish it up
#
		</TEXTAREA> 
	</td></tr>
    <tr>
		<td> Or upload it as text file <INPUT TYPE="File" NAME="upload" size=36></td>
	</tr>

	<tr><td>
		&nbsp;<br>
		<input id=submit type=submit value=Submit>
		<input TYPE="reset" VALUE="Reset " id="reset" name="reset"></p>
	</td></tr>
  
</table>
</form>
</div>

