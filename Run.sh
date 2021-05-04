#!/bin/bash

log=/root/BackupWeb.log
[[ ! -f $log ]] && { mkdir -p $(dirname $log) ; touch $log ; }

zippassword='zpasswd'
mysqlusername='mysqlusr'
mysqluserpassword='mysqlpw'
databasename='mysqldbn'
dboutputname=$databasename'_'$(date "+%Y%m%d%H%M%S")'.sql'
finaloutput=$dboutputname'.zip'
webdir='/home/webdir'
webzip='xxx_'$(date "+%Y%m%d%H%M%S")'.zip'

if [[ $1 == -db ]] ; then
  /usr/bin/mysqldump -u$mysqlusername -p$mysqluserpassword $databasename > '/root/'$dboutputname
  echo -e "[DB] $(date "+%Y.%m.%d %H:%M:%S") Export database $dboutputname successfully." >> $log
  /usr/bin/zip -9r -P$zippassword '/root/'$finaloutput '/root/'$dboutputname
  echo -e "[DB] $(date "+%Y.%m.%d %H:%M:%S") Encrypted and compressed backup-files $finaloutput successfully" >> $log
  /usr/bin/rclone copy --ignore-existing '/root/'$finaloutput 'oss:bucket' && /usr/bin/rclone copy --ignore-existing '/root/'$finaloutput 'cos:bucket'
  echo -e "[DB] $(date "+%Y.%m.%d %H:%M:%S") Uploaded backup-files $finaloutput successfully." >> $log
  rm -f '/root/'$dboutputname '/root/'$finaloutput
elif [[ $1 == -wf ]] ; then
  /usr/bin/zip -9r -P$zippassword '/root/'$webzip $webdir
  echo -e "[Web] $(date "+%Y.%m.%d %H:%M:%S") Encrypted and compressed backup-files $webzip successfully" >> $log
  /usr/bin/rclone copy --ignore-existing '/root/'$webzip 'oss:bucket' && /usr/bin/rclone copy --ignore-existing '/root/'$webzip 'cos:bucket'
  echo -e "[Web] $(date "+%Y.%m.%d %H:%M:%S") Uploaded backup-files $webzip successfully." >> $log
  rm -f '/root/'$webzip
else exit 1 ;
fi
