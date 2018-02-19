#!/bin/bash

#title		:dirbackupper.sh
#description	:This script backups files from target dir to backup_targetdir and keeps a record to targetdir_log.txt file
#author		:mityakuznetsoff@gmail.com
#date		:20180125
#version	:1.0
#usage		:dirbackupper.sh {target dir path} {backup dir path}"
#notes		:
#bash_version	:4.3.11(1)-release

targetDir=$1
backupDir=$2

cd /

#script call validation
if [[ $# -ne 2 || $1 = "--help" ]]; then
	echo "Usage: dirbackupper.sh {target dir path} {backup dir path}"
	echo "This script backups files from target dir to backup_targetdir and keeps a record to targetdir_log.txt file"
	exit 1;
#dir path validation
elif [[ ! -d "${targetDir}" ]]; then
	echo "$targetDir doesn't exist"
	exit 1
elif [[ ! -d "${backupDir}" ]]; then
	mkdir $backupDir
fi

touch .targetDirFilelist.txt
touch .backupDirFilelist.txt
touch .deletedFilesArchive.txt

#get a list of files of target and backup directories
cd ${targetDir}
find . -maxdepth 1 -type f -printf '%f\n' | sort > $OLDPWD/.targetDirFilelist.txt
cd $OLDPWD

cd ${backupDir}
find . -maxdepth 1 -type f -printf '%f\n' | sort > $OLDPWD/.backupDirFilelist.txt
cd $OLDPWD

#get a lists of deleted files
comm -23  .backupDirFilelist.txt .targetDirFilelist.txt | sort > .deletedFiles.txt
comm -23  .deletedFiles.txt .deletedFilesArchive.txt > .deletedFiles.tmp
mv .deletedFiles.tmp .deletedFiles.txt
awk -v date="$(date +"%Y-%m-%d %r")" '{print $1,"\tdeleted\t" date}' .deletedFiles.txt >> dirbackupper.log
cat .deletedFiles.txt >> .deletedFilesArchive.txt

#get a lists of new files
comm -23 .targetDirFilelist.txt .backupDirFilelist.txt > .createdFiles.txt
awk -v date="$(date +"%Y-%m-%d %r")" '{print $1,"\tcreated\t" date}' .createdFiles.txt >> dirbackupper.log

cat .createdFiles.txt | while read line
do
	cp ${targetDir}/${line} ${backupDir}
done

#delete auxiliary files
rm .targetDirFilelist.txt
rm .backupDirFilelist.txt
rm .deletedFiles.txt

cd $OLDPWD
