#!/bin/bash

#title			:dirbackupper.sh
#description	:This script backups files from target dir to backup_targetdir and keeps a record to targetdir_log.txt file
#author			:mityakuznetsoff@gmail.com
#date			:20180125
#version		:1.0
#usage			:dirbackupper.sh {target dir path} {backup dir path}"
#notes			:
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

#get a list of files of target and backup directories
cd ${targetDir}
find . -maxdepth 1 -type f -printf '%f\n' | sort > $OLDPWD/.targetDirFilelist.txt
cd $OLDPWD

cd ${backupDir}
find . -maxdepth 1 -type f -printf '%f\n' | sort > $OLDPWD/.backupDirFilelist.txt
cd $OLDPWD

#Step 2
#get a lists of deleted files

#Step 3
#get a lists of new files

cd $OLDPWD
