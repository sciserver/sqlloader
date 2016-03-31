<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!-------#include file="header.inc"---------><HTML><HEAD>
<META http-equiv=Content-Type content="text/html; charset=unicode">
<META content="MSHTML 6.00.2713.1100" name=GENERATOR></HEAD>
<BODY>
<div id="title">Frequently Asked Questions</div>
<div id="transp" class="med">
<table width=600>
<tr><td class='med'>
<h4>Troubleshooting FAQ</h4>
<p>
<ol>
	<li>
		<span class='t'>The loadadmin and loadsupport creation is failing because SQL Server is unable to create the DBs due to lack of
privileges to write files in the default (C:\sql_db\) directory.</span>
		<br>
		If the relevant users have privileges to create files in the directory, then most likely the SQL Server is not in <u>mixed authentication mode</u>, if this is a fresh installation.  Check to make sure SQL Server is in mixed auth mode.
	</li>
	<li>
		<span class='t'>The loading seems to be stuck but there
		is no error or warning message in the task log. </span>
		<br>
		Look at the LOAD (if the loading is in the task db
		stage) or PUB (of it is in the publish/finish stage) job
		history in the SQL Server Agent jobs to see if the job 
		ended with an error.  The history entry will show an
		error corresponding to the problem.
	</li>
	<li>
		<span class='t'>The SQL Server Agent is running and
		LOAD/PUB jobs are active, but the tasks are not getting
		beyond the detach (DTC) stage.</span>
		<br>
		Click on the <a href="showservers.asp">Servers page</a> in
		the load monitor and make sure that the PUB server state
		is "running" (arrow). 
	</li>
	<li>
		<span class='t'>The BLD is throwing an error because it
		is unable to create a task DB because some files could
		not be created due to lack of permissions. </span>
		<br>
		The Windows domain user that the <b>loadagent</b> SQL
		Server user is mapped to does not have permissions to
		create files in the directory that the
		<b>taskdatapath</b> entry in the Constants table is
		pointing to.  The loadagent user needs to be mapped to a
		domain admin Windows user.
	</li>
	<li>
		<span class='t'>The CSV check step does not find any files
		so the task finishes without loading any files.</span>
		<br>
		The csv_ready file at the top level should be empty or have
		valid file names in it.  Make sure that if it is supposed to
		be empty it is actually 0 bytes in size.
	</li>
</ol>
<h4>Miscellaneous FAQ</h4>
<p>
<ol>
<p>
	<li>
		<span class='t'>How do I add a new export type to the loader?</span>
		<br>
		You need to perform the following steps to add a new export type (e.g. GALSPEC):
			<ol>
				<li>Add the export type to admin\newtask.asp and admin\add.asp.</li>
				<li>Add a case for the new export type to x_upload.js.</li>
				<li>Add a regexp pattern for the CSV fles for this export type to vbs\csvrobot.vbs under the appropriate export subdirectory (e.g., spCSV\galspec\).</li>
				<li>Add validation tests if applicable to schema\sql\spValidate.sql (e.g. unique key tests) - create a new stored procedure for this export type.</li>
				<li>If necessary, add a case to schema\sql\spSetValues.sql for the files in this export type.</li>
				<li>Add the commands to copy the tables for this export from the task db to the publish db in schema\sql\spPublish.sql.</li>
				<li>Add indices for the tables in this export to IndexMap (schema\sql\IndexMap.sql).</li>
				<li>Finally, add any code necessary to merge this data into the publish DB during the FINISH processing, in schema\sql\spFinish.sql.</li>
			</ol>
	</li>
</ol>
</td></tr>



</table>
</div>

</BODY>
</html>
