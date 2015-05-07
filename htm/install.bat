echo off
REM Remove the old HTM extended procedures from master        > HtmLog.txt
REM Then install the HTM dll in the SQL Binn directory       >> HtmLog.txt
REM Finally, grant access to the extended procedures         >> HtmLog.txt
osql  -d Master -E  -n -iDropOldHtmXPs.sql                   >> HtmLog.txt
copy htm_v2.dll "C:\Program Files\Microsoft SQL Server\80\Tools\Binn\htm_v2.dll" >> HtmLog.txt                         
osql  -d Master -E  -n -iGrantHtmAccess.sql                  >> HtmLog.txt
echo HTM DONE
echo HTM DONE                                                >> HtmLog.txt