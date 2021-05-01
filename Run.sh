#!/bin/bash

log=/root/BackupWeb.log
[[ ! -f $log ]] && { mkdir -p $(dirname $log) ; touch $log ; }

zippassword='zpasswd'
mysqlusername'mysqlusr'
mysqluserpassword='mysqlpw'
databasename='mysqldbn'
dboutputname=$databasename'_'$(date "+%Y%m%d%H%M%S")'.sql'
finaloutput=$dboutputname'.zip'

/usr/bin/mysqldump -u$mysqlusername -p$mysqluserpassword $databasename > '/root/'$dboutputname
echo -e "$(date "+%Y.%m.%d %H:%M:%S") Export database $dboutputname successfully." >> $log
/usr/bin/zip -9r -P$zippassword '/root/'$finaloutput '/root/'$dboutputname
echo -e "$(date "+%Y.%m.%d %H:%M:%S") Encrypted and compressed backup-files $finaloutput successfully" >> $log
/usr/bin/rclone copy --ignore-existing '/root/'$finaloutput 'oss:bucket' && /usr/bin/rclone copy --ignore-existing '/root/'$finaloutput 'cos:bucket'
echo -e "$(date "+%Y.%m.%d %H:%M:%S") Uploaded backup-files $finaloutput successfully." >> $log
rm -f '/root/'$dboutputname '/root/'$finaloutput
