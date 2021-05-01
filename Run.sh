#!/bin/bash

log=/root/BackupWeb.log

[[ ! -f $log ]] && { mkdir -p $(dirname $log) ; touch $log ; }

zippassword='zpasswd'
mysqlusername='dbu'
mysqluesrpassword='dbp'
databasename='dbn'
backupoutputname=$databasename'.sql'                                                                                                                                                                               

/usr/bin/mysqldump -u$mysqlusername -p$mysqluserpassword $databasename > $backupoutputname
sleep 5
/usr/bin/zip -9r -P$zippassword $backupoutputname'.zip' $backupoutputname
