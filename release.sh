#!/bin/bash
# Setup environment for kunterbunt and start the ide

# Setzen der Sprache auf default wert für automatische Auswertung von Nachrichten...
export LANG=C

RELEASE_DIR=$(pwd);

releaseVersion=${1:-`read -p "Enter release version (i.e. '1.0.3'): " TMP && echo $TMP`}
developmentVersion=${2:-`read -p "Enter development version (i.e. '1.0.4-SNAPSHOT'): " TMP && echo $TMP`}
username=${3:-`read -p "Enter git user " TMP && echo $TMP`}
password=${4:-`read -p "Enter git password " TMP && echo $TMP`}


mvn="mvn -l $RELEASE_DIR/release-log-$releaseVersion.txt "


echo
echo "start releasing projects ..."
echo "RELEASE_DIR=$RELEASE_DIR"
echo "mvn=$mvn"

cd ..

cd project-parent

$mvn jgitflow:release-start -DreleaseVersion=$releaseVersion -DdevelopmentVersion=$developmentVersion
STATUS=$?
if [ $STATUS -eq 0 ]; then
echo "release-start successful"
else
echo "release-start failed"
exit $STATUS
fi

$mvn jgitflow:release-finish -DnoDeploy=true 
STATUS=$?
if [ $STATUS -eq 0 ]; then
echo "release-finish successful"
else
echo "release-finish failed"
exit $STATUS
fi

git push
STATUS=$?
if [ $STATUS -eq 0 ]; then
echo "git push successful"
else
echo "git push failed"
exit $STATUS
fi

cd ..


cd project-a
$mvn versions:update-parent -DgenerateBackupPoms=false
STATUS=$?
if [ $STATUS -eq 0 ]; then
echo "update-parent successful"
else
echo "update-parent failed"
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

$mvn jgitflow:release-start -DreleaseVersion=$releaseVersion -DdevelopmentVersion=$developmentVersion 
STATUS=$?
if [ $STATUS -eq 0 ]; then
echo "release-start successful"
else
echo "release-start failed"
exit $STATUS
fi


$mvn jgitflow:release-finish -DnoDeploy=true
STATUS=$?
if [ $STATUS -eq 0 ]; then
echo "release-finish successful"
else
echo "release-finish failed"
exit $STATUS
fi

git push
STATUS=$?
if [ $STATUS -eq 0 ]; then
echo "git push successful"
else
echo "git push failed"
exit $STATUS
fi

cd ..

###### project-b
cd project-b

$mvn versions:update-parent -DgenerateBackupPoms=false
STATUS=$?
if [ $STATUS -eq 0 ]; then
echo "update-parent successful"
else
echo "update-parent failed"
exit $STATUS
fi

$mvn versions:update-properties -DincludeProperties=project-a.version -DgenerateBackupPoms=false
STATUS=$?
if [ $STATUS -eq 0 ]; then
echo "update-properties successful"
else
echo "update-properties failed"
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

$mvn jgitflow:release-start -DreleaseVersion=$releaseVersion -DdevelopmentVersion=$developmentVersion 
STATUS=$?
if [ $STATUS -eq 0 ]; then
echo "release-start successful"
else
echo "release-start failed"
exit $STATUS
fi


$mvn jgitflow:release-finish -DnoDeploy=true
STATUS=$?
if [ $STATUS -eq 0 ]; then
echo "release-finish successful"
else
echo "release-finish failed"
exit $STATUS
fi

git push
STATUS=$?
if [ $STATUS -eq 0 ]; then
echo "git push successful"
else
echo "git push failed"
exit $STATUS
fi

cd ..

