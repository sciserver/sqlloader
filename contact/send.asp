<%  @ LANGUAGE="VBSCRIPT" %>
<%
Set myMail=CreateObject("CDO.Message")
myMail.Subject="[sdss3] "+Request.QueryString("date")+"<"+Request.QueryString("email")+">"+Request.QueryString("subPrefix")+Request.QueryString("subject")
myMail.From=Request.QueryString("email")
myMail.ReplyTo=Request.QueryString("email")
dim CFLF
dim message
dim desc
dim userid
dim helpdesk
dim epo
CRLF = Chr(13) & Chr(10)
userid=Request.QueryString("userid")
if (Request.QueryString("epo")="on") then
	myMail.To=Request.QueryString("epohelp")
	myMail.Cc=Request.QueryString("email") & "," & Request.QueryString("helpdesk")
else
	myMail.To=Request.QueryString("helpdesk")
	myMail.Cc=Request.QueryString("email")
end if
if (userid="") then
	userid = Request.QueryString("username") & CRLF & desc
end if
helpdesk=Request.QueryString("helpdesk")
desc=Request.QueryString("message")
' if ( (InStr(1,desc,"http://",1) > 0) _
if ( (InStr(1,desc,"viagra",1) > 0) or (InStr(1,desc,"cialis",1) > 0) or (InStr(1,desc,"levitra",1) > 0) _
    or (InStr(1,desc,"cheap",1) > 0) or (InStr(1,desc,"drugs",1) > 0) or (InStr(1,desc,".com",1) > 0) _
    or (InStr(1,desc,"coolest",1) > 0) or (InStr(1,desc,"tramadol",1) > 0) or (InStr(1,desc,"phentermine",1) > 0) _
    or (InStr(1,desc,"download free",1) > 0) or (InStr(1,desc,"ringtones",1) > 0) or (InStr(1,desc,"insurance",1) > 0) _
    or (InStr(1,userid,"viagra",1) > 0) or (InStr(1,userid,"cialis",1) > 0) or (InStr(1,userid,"levitra",1) > 0)  ) then
	myMail.To=""
	Response.Write("<html>")
	Response.Write("<head>")
	Response.Write("<title>SDSS-III HelpDesk Message Not Sent</title>")
	Response.Write("</head>")
	Response.Write("<body>")
	Response.Write("<h1>SDSS-III HelpDesk Message Not Sent</h1>")
	Response.Write("<p style='color:red;'>Sorry!  Your message to the Help Desk was not sent due to an ERROR.  <br />")
	Response.Write("in processing the content of the message.</p>")
	Response.Write("</body>")
	Response.Write("</html>")
elseif ( (InStr(1,helpdesk,"sdss3",1) = 0) and (InStr(1,helpdesk,"thakar",1) = 0) ) then
	myMail.To=""
	Response.Write("<html>")
	Response.Write("<head>")
	Response.Write("<title>SDSS-III HelpDesk Message Not Sent</title>")
	Response.Write("</head>")
	Response.Write("<body>")
	Response.Write("<h1>SDSS-III HelpDesk Message Not Sent</h1>")
	Response.Write("<p style='color:black;'>Sorry!  Your message to the Help Desk was not sent due to.  <br />")
	Response.Write("an invalid helpdesk email address..</p>")
	Response.Write("</body>")
	Response.Write("</html>")
else
	message = "User: " & userid & CRLF & desc
	myMail.TextBody=message
	myMail.Configuration.Fields.Item _
("http://schemas.microsoft.com/cdo/configuration/sendusing")=2
'Name or IP of remote SMTP server
	myMail.Configuration.Fields.Item _
("http://schemas.microsoft.com/cdo/configuration/smtpserver") _
="mail.pha.jhu.edu"
'Server port
	myMail.Configuration.Fields.Item _
("http://schemas.microsoft.com/cdo/configuration/smtpserverport") _
=25 
	myMail.Configuration.Fields.Update
	myMail.Send
	set myMail=nothing
	Response.Write("<html>")
	Response.Write("<head>")
	Response.Write("<title>SDSS-III HelpDesk Message Sent</title>")
	Response.Write("</head>")
	Response.Write("<body>")
	Response.Write("<h1>SDSS-III HelpDesk Message Sent</h1>")
	Response.Write("<p style='color:green;'>Thank you!  Your message was sent to the Help Desk.  You should expect a response shortly.  <br />")
	Response.Write("Please remember to copy the Help Desk account on future exchanges about this issue.</p>")
	Response.Write("</body>")
	Response.Write("</html>")
end if
%>
