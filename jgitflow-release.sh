#!/bin/bash
# Setup environment for kunterbunt and start the ide

# Setzen der Sprache auf default wert für automatische Auswertung von Nachrichten...
export LANG=C

$mvn jgitflow:release-start -DreleaseVersion=$releaseVersion -DdevelopmentVersion=$developmentVersion -Dusername=$username -Dpassword=$password
STATUS=$?
if [ $STATUS -eq 0 ]; then
	echo "release-start successful"
	. $RELEASE_DIR/save-log-file.sh	
else
	echo "release-start failed"
	. $RELEASE_DIR/save-log-file.sh
	exit $STATUS	
fi

$mvn jgitflow:release-finish -DnoDeploy=true -Dusername=$username -Dpassword=$password
STATUS=$?
if [ $STATUS -eq 0 ]; then
	echo "release-finish successful"
	. $RELEASE_DIR/save-log-file.sh
else
	echo "release-finish failed"
	. $RELEASE_DIR/save-log-file.sh
	exit $STATUS	
fi
