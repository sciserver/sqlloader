
/****** Object:  StoredProcedure [dbo].[spTestTimeEnd]    Script Date: 5/2/2018 12:39:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--
CREATE PROCEDURE [dbo].[spTestTimeEnd](
	@clock 	     datetime,
	@elapsed     bigint        OUTPUT,
	@cpu 	     bigint        OUTPUT, 
        @physical_io bigint	   OUTPUT,
	@query	     varchar(10)  = '',
        @comment     varchar(100) = '', 
	@print       int        =0,
	@table       int        =0,
	@row_count   bigint     =0
)
---------------------------------------------------
--/H Stops the clock for performance testing and optionally records stats in QueryResults and in sysOut. 
--/A 
--/T  <p>parameters are (inputs should be set with spTestTimeStart as shown in example):
--/T       <li> clock datetime (input)       : current 64bit wallclock datetime
--/T       <li> elapsed float (output)       : elapsed milliseconds of wall clock time  
--/T       <li> cpu fkiat (input, output)    : an int of milliseconds of cpu time (wraps frequently so gives bogus answers)
--/T       <li> physical_Io bigint (input, output): count of disk reads and writes
--/T       <li> query varchar(10) (input)    : short text string describing the query
--/T       <li> commment varchar(100) (input) : longer text string describing the experiment
--/T       <li> print (input)       	      : flag, if true prints the output statistics on the console (default =no)
--/T       <li> table (input)                 : flag, if true inserts the statistics in the QueryResults table (default = no)
--/T       <li> row_Count(input)              : passed in RowCount_big for statistics
--/T  Here is an example that uses spTestTimeStart and spTestTimeEnd to record the cost of 
--/T  some SQL statements. The example both records the results in the QueryResults table
--/T  and also prints out a message summarizing the test (that is what the 1,1 flags are for.)
--/T  <samp>
--/T  <br>declare @clock datetime, @cpu bigint, @physical_io bigint,  @elapsed bigint;
--/T  <br>exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
--/T  <br>  .... do some SQL work....
--/T  <br>exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 
--/T  <br>                          'Q10', '1GB buffer pool, read committed', 1, 1, @@RowCount_big
--/T  </samp><p>
--/T  see also spTestTimeStart
---------------------------------------------------
AS	
BEGIN
	set nocount on;
	--
	select  @elapsed = datediff(ms, @clock, getdate()),
		@cpu = (@@CPU_BUSY - @cpu) * @@TIMETICKS, -- scale by ticks per microsecond
       		@physical_io = (@@TOTAL_READ + @@TOTAL_WRITE) - @physical_io
	-- treat wraparound of counters as a zero value
	if @cpu < 0			set @cpu = 0
	if @physical_io < 0 set @physical_io = 0
	-- printout
	if (@print >0)
           begin
           print @query
               + ' cpu: '              + str(@cpu/1000000.0, 8,2)   
               + ' sec, elapsed: '     + str(@elapsed/1000.0,8,2) 
               + ' sec, physical_io: ' + cast(@physical_io as varchar(20))
               + ' row_count: '        + cast(@row_count as varchar(20))
	       + ' comment: ' + @comment 
           end
	-- table record
	if (@table > 0)
           begin
		   if exists (select * from weblog.sys.tables where name = 'QueryResults')
		      insert weblog.dbo.QueryResults
              values(@query, @cpu/1000000.0, @elapsed/1000.0, @physical_io, @row_count,CURRENT_TIMESTAMP, db_name(), @comment);
           else
			  print concat('no weblog.dbo.QueryResults:',@query, @cpu/1000000.0, @elapsed/1000.0, @physical_io, @row_count,CURRENT_TIMESTAMP, db_name(), @comment)		  
           end          
	return
END
GO

