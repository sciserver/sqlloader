<%  @ LANGUAGE="JScript" %>
<html>
<head>
<title>SkyServer: Contact SDSS HelpDesk</title>
<link href="skyserver.css" rel="stylesheet" type="text/css" />
<link rel="shortcut icon" href="FavIcon.ICO" />
</head>
<body>
<table cellpadding="0" cellspacing="0" border="0" width="100%" height="73"> 
  <tr height="73" width="50">
    <td align="left" height="73"  width="50">
       <a href="http://www.sdss3.org"><img class="imgnoborder" src="sdss3_logo.gif" width="50" alt="SDSS-III Logo" /></a></td>
    <td><img src="titlebar.gif" alt="Title Bar" /></td>
  </tr>
</table>
<div id="title">Contact SDSS-III Help Desk</div>
<div id="transp">
<script type="text/javascript">

function checkForm(key) {
	if( document.jsform.username.value == "" ) {
		alert( "Please enter your name in the Name field." );
		document.jsform.username.focus();
		return false;
	}
	if( document.jsform.email.value == "" ) {
		alert( "Please enter your email address in the Email field.");
		document.jsform.email.focus();
		return false;
	}
	if( document.jsform.email.value.indexOf("@") == -1 ) {
		alert( "Please enter a valid email address in the Email field.");
		document.jsform.email.focus();
		return false;
	}
	if( document.jsform.key.value != key ) {
		alert( "Please enter the correct key value in the key field. Click on the \"Press to get key\" button to get the key value. This is used to minimize SPAM.");
		document.jsform.key.focus();
		return false;
	}
	if( document.jsform.subject.value == "" ) {
		alert( "Please enter a brief subject that describes the problem.");
		document.jsform.subject.focus();
		return false;
	}
	if( document.jsform.message.value.length < 5 ) {
		alert( "Please enter a description for the problem.");
		document.jsform.subject.focus();
		return false;
	}
	return true;
}

function SendEmail()
{
	var helpdesk = 'helpdesk@sdss3.org';
	if( document.jsform.epo.checked == true )
	   helpdesk = 'raddick@pha.jhu.edu';
	var subject = 'SkyServer '+document.jsform.release.value+' issue: ' + document.jsform.subject.value;
	var mailer = 'mailto:' + helpdesk + '?subject=' + subject + '&body=' + 
		'Name:%20' + document.jsform.username.value + '%20%20%0A' + 'Email:%20' + document.jsform.email.value + 
		'%20%20%0A' + 'URL:%20' + document.jsform.url.value + '%20%20%0A' + 'Description:%20%20%0A' + document.jsform.message.value +'%0A%0A';
	parent.location = mailer;
}

function getKey( key )
{
	var w = window.open( "key.asp?key="+key,"POPUP","width=150,height=100" );
	w.focus();
}

</script>

<%
	var release = Request.QueryString("release");
	var smtp = Request.QueryString("smtp");
	var helpdesk = Request.QueryString("helpdesk");
	var epoHelp = Request.QueryString("epoHelp");
	var url = Request.QueryString("url");
	var username = Request.QueryString("username");
	var userid = String(Request.QueryString("userid"));
	if( userid=="undefined" )
		userid=username;
	else
		userid = userid.replace(/^\s*|\s*$/g,'');
	var email = Request.QueryString("email");
	var today = new Date();
	var mth = today.getMonth()+1;
	var date = today.getFullYear()+"-"+mth+"-"+today.getDate();
	var subject = Request.QueryString("subject");
	var keyValue = Math.floor(Math.random()*1001);
	var known;
	if( (release != "DR8") && (release != "DR9") )		// if DR10 or beyond
		known = "known.aspx";
	else
		known = "known.asp";
%>

<form name="jsform" action="send.asp">
<table width="672">
	<tr>
		<td colspan="3" class="midbodytext"><p>If you encounter a problem with the <a href="http://skyserver.sdss3.org/<%=release%>">SkyServer site</a> that is not listed in the <a href="http://skyserver.sdss3.org/<%=release%>/en/help/docs/<%=known%>">Known Problems page</a>, 
		or a problem with the <a href="http://skyservice.pha.jhu.edu/casjobs">CasJobs site</a>, please fill out the short form below and press <b>Send</b> to send it to the SDSS Help Desk.  Someone will contact you shortly with
		an answer to your question.  We request that you observe the following guidelines when communicating with the SDSS Help Desk:</p>
		<ul>
	    	    <li>Please remember to copy the help desk email account on all email related to this problem, so that
			we have a record of how the problem was resolved.</li>
		    <li>Please do not contact the help desk respondents directly by email, because help desk support is handled
	    		by a pool of SDSS scientists with expertise in different areas and as time permits, and the best response time to your problem will usually 
			be obtained if you direct your question to the help desk account rather than individual SDSS scientists.</li>
	    	    <li>If your problem is related to the student and teacher materials under the <a href="http://skyserver.sdss3.org/<%=release%>/en/proj/">SkyServer Projects pages</a>, please
			check the "Student Projects" box below.  This will copy your email to the person(s) that handle that branch
			of the SkyServer content.</li>
		</ul>
			<p>You will receive a copy of the message that is sent to the Help Desk.  Thank you! </p>
		</td>
	</tr>

	<tr><td colspan="3">&nbsp;</td></tr>

	<tr>
		<td width="150" class="midbodytext"><b>Name</b>:&nbsp;</td>
		<td><input name="username" size="25" value="<%=username%>" /></td>
		<td class="midbodytext"><input id="epo" name="epo" type="checkbox" /><label for="epo"><b>Student Projects</b> (check if applicable)</label></td>
	</tr>

	<tr>
		<td width="150" class="midbodytext"><b>Email</b>:&nbsp;</td>
		<td colspan="2"><input name="email" size="25" value="<%=email%>" /></td>
	</tr>

	<tr>
		<td width="150" class="midbodytext"><b>Key</b>:&nbsp;</td>
		<td><input name="key" size="25" value="" /></td>
		<td><input type="button" onclick="getKey('<%=keyValue%>');" value="Press to get key" /></td>
	</tr>

	<tr>
		<td width="150" class="midbodytext"><b>URL of relevant page (if applicable)</b>:&nbsp;</td>
		<td colspan="2"><input name="url" size="70" value="<%=url%>" /></td>
	</tr>

	<tr>
		<td width="150" class="midbodytext"><b>Subject</b>:&nbsp;</td>
		<td colspan="2"><input name="subject" size="70" value="" />
			<input name="date" type="hidden" value="<%=date%>" />
			<input name="subPrefix" type="hidden" value="<%=subject%>" />
			<input name="release" type="hidden" value="<%=release%>" />
			<input name="userid" type="hidden" value="<%=userid%>" />
			<input name="helpdesk" type="hidden" value="<%=helpdesk%>" />
			<input name="epoHelp" type="hidden" value="<%=epoHelp%>" /></td>
	</tr>

	<tr>
		<td colspan="3" class="midbodytext"><b>Problem/Question Description:</b></td>
	</tr>
	<tr>
		<td colspan="3" align="center">
			<textarea name="message" cols="80" rows="8" wrap="soft"></textarea>
		</td>
	</tr>
<!--  Need to figure out how to save upload file locally and then send it. [ART]
	<tr>
		<td colspan="3">
		       		Attach a File : <input type="file" name="File1" size="32" />
		</td>
	</tr>
-->
	<tr>
		<td align="left"><input type="submit" onclick="return checkForm('<%=keyValue%>');" value=" Send to Help Desk " /></td>
		<td>&nbsp;</td>
		<td width=140 align="right"><input name="reset" type="reset" value=" Reset Form " /></td>
	</tr>
</table>
</form>

</div>
</body>
</html>
