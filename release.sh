#!/bin/bash
# Setup environment for kunterbunt and start the ide

# Setzen der Sprache auf default wert für automatische Auswertung von Nachrichten...
export LANG=C

SCRIPT_BASEDIR=$(pwd);

releaseVersion=${1:-`read -p "Enter release version (i.e. '1.0.3'): " TMP && echo $TMP`}
developmentVersion=${2:-`read -p "Enter development version (i.e. '1.0.4-SNAPSHOT'): " TMP && echo $TMP`}
mvn="mvn -l $SCRIPT_BASEDIR/release-log-$releaseVersion.txt "


echo
echo "start releasing projects ..."
echo "basedir=$SCRIPT_BASEDIR"
echo "mvn=$mvn"

cd releasing-parent

$mvn jgitflow:release-start -DautoVersionSubmodules=true -DreleaseVersion=$releaseVersion -DdevelopmentVersion=$developmentVersion -f project-parent/pom.xml
STATUS=$?
if [ $STATUS -eq 0 ]; then
echo "release-start successful"
else
echo "release-start failed"
exit $STATUS
fi

$mvn jgitflow:release-finish -DnoDeploy=true -f project-parent/pom.xml 
STATUS=$?
if [ $STATUS -eq 0 ]; then
echo "release-finish successful"
else
echo "release-finish failed"
exit $STATUS
fi

cd ..


cd releasing-project1
$mvn versions:update-parent -DgenerateBackupPoms=false -f project1/pom.xml
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

$mvn jgitflow:release-start -DautoVersionSubmodules=true  -DreleaseVersion=$releaseVersion -DdevelopmentVersion=$developmentVersion  -f project1/pom.xml 
STATUS=$?
if [ $STATUS -eq 0 ]; then
echo "release-start successful"
else
echo "release-start failed"
exit $STATUS
fi


$mvn jgitflow:release-finish -DnoDeploy=true -f project1/pom.xml
STATUS=$?
if [ $STATUS -eq 0 ]; then
echo "release-finish successful"
else
echo "release-finish failed"
exit $STATUS
fi

cd ..

###### project 2
cd releasing-project2

$mvn versions:update-parent -DgenerateBackupPoms=false -f project2/pom.xml
STATUS=$?
if [ $STATUS -eq 0 ]; then
echo "update-parent successful"
else
echo "update-parent failed"
exit $STATUS
fi

$mvn versions:update-properties -DincludeProperties=project1.version -DgenerateBackupPoms=false -f project2/pom.xml
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

$mvn jgitflow:release-start -DautoVersionSubmodules=true  -DreleaseVersion=$releaseVersion -DdevelopmentVersion=$developmentVersion  -f project2/pom.xml 
STATUS=$?
if [ $STATUS -eq 0 ]; then
echo "release-start successful"
else
echo "release-start failed"
exit $STATUS
fi


$mvn jgitflow:release-finish -DnoDeploy=true -f project2/pom.xml
STATUS=$?
if [ $STATUS -eq 0 ]; then
echo "release-finish successful"
else
echo "release-finish failed"
exit $STATUS
fi

cd ..

