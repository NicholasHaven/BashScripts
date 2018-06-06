#!/bin/sh
### Specify each database to be backed up
databasename=( db1 db2 )
for i in "${databasename[@]}"
do
	### Backup File Name
	filename=$i"_"$(date +'%Y%m%d').gz
	### Folder where backups will be held
	backupfolder="/mnt/ebs/backups/sql"
	fullpathbackupfile="$backupfolder/$filename"
	### Log file location
	logfile="$backupfolder/"backup_log_"$(date +'%Y_%m')".txt
	### Logfile started
	echo "mysqldump started at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
	### Local Backup
	mysqldump --opt --user=root --password=rootpassword --default-character-set=utf8 --single-transaction $i | gzip > "$fullpathbackupfile"
	### Logfile Finished
	echo "mysqldump finished at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
	### Remove Old backup a month old
	find "$backupfolder" -iname $i"_"$(date --date='1 month ago' +%Y%m%d).gz -exec rm -f {} \;
	echo "old files deleted $i"_"$(date --date='1 month ago' +%Y%m%d).gz" >> "$logfile"
	echo "operation finished at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
	echo "*****************" >> "$logfile"
	wait
done
