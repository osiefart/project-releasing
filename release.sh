#!/bin/bash
# Setup environment for kunterbunt and start the ide

# Setzen der Sprache auf default wert für automatische Auswertung von Nachrichten...
export LANG=C

# external param
releaseVersion=${1:-`read -p "Enter release version (i.e. '1.0.3'): " TMP && echo $TMP`}
developmentVersion=${2:-`read -p "Enter development version (i.e. '1.0.4-SNAPSHOT'): " TMP && echo $TMP`}
username=${3:-`read -p "Enter git user: " TMP && echo $TMP`}
password=${4:-`read -s -p "Enter git password: " TMP && echo $TMP`}
RELEASE_DIR=$(pwd)
WORKING_DIR=$RELEASE_DIR/release-$releaseVersion;

# internal variables
LOG_FILE=$WORKING_DIR/release-log-$releaseVersion.txt 
TMP_LOG_FILE=$WORKING_DIR/release-log-$releaseVersion-tmp.txt 

mvn="mvn -l $TMP_LOG_FILE "

echo
echo "start releasing projects ..."
echo "RELEASE_DIR=$RELEASE_DIR"
echo "WORKING_DIR=$WORKING_DIR"
echo "mvn=$mvn"

mkdir $WORKING_DIR
cd $WORKING_DIR

git clone https://github.com/osiefart/project-parent.git
git clone https://github.com/osiefart/project-a.git
git clone https://github.com/osiefart/project-b.git

# release parent
cd project-parent
git checkout develop
. $RELEASE_DIR/jgitflow-release.sh
cd ..

###### project-a
cd project-a
git checkout develop

$mvn versions:update-parent -DgenerateBackupPoms=false
STATUS=$?
if [ $STATUS -eq 0 ]; then
	echo "update-parent successful"
	. $RELEASE_DIR/save-log-file.sh	
else
	echo "update-parent failed"
	. $RELEASE_DIR/save-log-file.sh
	exit $STATUS	
fi

git commit -a -m "update parent"
STATUS=$?
if [ $STATUS -eq 0 ]; then
	echo "commit update-parent successful"
else
	echo "commit update-parent failed"
	exit $STATUS	
fi

. $RELEASE_DIR/jgitflow-release.sh
cd ..

###### project-b
cd project-b
git checkout develop

$mvn versions:update-parent -DgenerateBackupPoms=false
STATUS=$?
if [ $STATUS -eq 0 ]; then
	echo "update-parent successful"
	. $RELEASE_DIR/save-log-file.sh	
else
	echo "update-parent failed"
	. $RELEASE_DIR/save-log-file.sh	
	exit $STATUS	
fi

$mvn versions:update-properties -DincludeProperties=project-a.version -DgenerateBackupPoms=false
STATUS=$?
if [ $STATUS -eq 0 ]; then
	echo "update-properties successful"
	. $RELEASE_DIR/save-log-file.sh	
else
	echo "update-properties failed"
	. $RELEASE_DIR/save-log-file.sh	
	exit $STATUS	
fi


git commit -a -m "update parent"
STATUS=$?
if [ $STATUS -eq 0 ]; then
	echo "commit update-parent successful"
else
	echo "commit update-parent failed"
	exit $STATUS	
fi

. $RELEASE_DIR/jgitflow-release.sh
cd ..

