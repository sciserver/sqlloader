<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!-------#include file="header.inc"---------><HTML><HEAD>
<META http-equiv=Content-Type content="text/html; charset=unicode">
<META content="MSHTML 6.00.2713.1100" name=GENERATOR></HEAD>
<BODY>
<div id="title">Documentation</div>
<div id="transp" class="med">
<table width=600>
<tr><td class='med'>
<h4>The loading process</h4>
<p>
The basic processing entity is a <b>Task</b>. A Task
is started when an export block becomes available.
Export blocks come converted to CSV, and are
contained in a single directory. They must be
registered to get in the processing queue.
There are several different export types: TARGET, 
BEST, RUNS, PLATE and TILING. The format of the
respective csv files are found <a href="das.fnal.gov">
here</a>. Each task comes with a id number that is unique
within its category.
<p>
The loading process consists of <b>Steps</b>. The
first step is to <b>load</b> each block of data into a
separate SQL Server database, containing only a
thin set of indices. Then we <b>validate</b> the data.
This includes several things: we verify that there
are no primary key collisions, all foreign keys
point to a valid record, and we build several
ancilliary tables for spatial searches (HTM, 
Neighbors, etc.) After the validation step we 
<b>publish</b> the data: we perform a db-to-db copy, 
      where the target is the final production database. The last step in the 
      process is that we make a backup of the SQL block in its final stage to 
      storage brick.</p>        
<p>
There are codes associated with the state of the tasks.
These are composed of the step name and of the 
            
           
</td></tr>

<tr><td class='med'>
  <table width=480 align=center>
	<tr><td>
		<IMG height=229  src="img/loadsteps.gif" width=480> 
	</td></tr>
	<tr><td class='sml'>
		A state-machine representation of the loading process.
		Each step is a sequence of rather complex steps in itself.
		The yellow question marks represent a manual Undo step,
		which is performed as necessary.
	</td></tr>
  </table><br>
</td></tr>

<tr><td class='med'>
<h4>Tracking</h4>
<p>
We have set up a database to track the information about 
the loading. This database tracks Tasks and Events. Nothing 
is ever deleted from the database, we only add things. The 
database is visible from the outside, but its contents can 
only be changed (added to) from within the private network.
<p>
Each step generates several <b>Events</b>. An event is
the start of a processing step, its success and its 
failure. An event is always uniquely associated with a task.
It has a timestamp, indicating when the event was logged.
Thus, one can estimate the time it took for a processing
step from the difference between the timestamp of the
completion and its start. The events can also point to a
logfile, or to a set of log records in another table,
which can be inspected in the case of an error condition.
<p>
Each action in the loadlog database is done through a 
	small set of stored procedures, like <FONT 
      face="Courier New">spNewTask</FONT>, or <FONT 
      face="Courier New">spNewEvent</FONT>.</p>
          
        
</td></tr>



</table>
</div>

</BODY>
</html>
