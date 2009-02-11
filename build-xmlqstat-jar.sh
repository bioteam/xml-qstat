#!/bin/sh

# Chris Dagdigian (dag@sonsorol.org)
#
# This script can be used to compile and package the xml-qstat.jar file required
# by Apache Cocoon for direct XML queries to the SGE Qmaster.
#
# Instructions:
#
#  1. Run this script, fix as needed until it runs properly to completion
#
#  2. Copy (or symlink) the resulting xml-qstat.jar file to your Cocoon
#     build/webapp/WEB-INF/lib/ directory (before starting cocoon)
#


## YOU WILL NEED TO EDIT THIS BLOCK TO MATCH YOUR LOCAL INSTALL
MyCocoonBase="/data/app/cocoon-2.1.10/build"

MYCLASSPATH="$MyCocoonBase/cocoon/cocoon.jar:\
$MyCocoonBase/webapp/WEB-INF/lib/commons-lang-2.2.jar:\
$MyCocoonBase/webapp/WEB-INF/lib/avalon-framework-api-4.3.jar:\
$MyCocoonBase/webapp/WEB-INF/lib/avalon-framework-impl-4.3.jar:\
$MyCocoonBase/webapp/WEB-INF/lib/xml-apis-1.3.04.jar:\
$MyCocoonBase/webapp/WEB-INF/lib/excalibur-pool-api-2.1.jar:\
$MyCocoonBase/webapp/WEB-INF/lib/excalibur-datasource-2.1.jar:\
$MyCocoonBase/webapp/WEB-INF/lib/excalibur-xmlutil-2.1.jar:\
$MyCocoonBase/webapp/WEB-INF/lib/excalibur-sourceresolve-2.1.jar\
"

## -- should not need to make changes below but if so the code should be pretty clear -- ##

echo "[STATUS] Entering the xmlqstat generator directory"
cd java/org/xmlqstat/generator/

echo "[STATUS] Will try to run this command:"
echo "javac -classpath $MYCLASSPATH CommandGenerator.java "

if  javac -classpath $MYCLASSPATH CommandGenerator.java; then
   echo "\n[STATUS] The javac command seems to have worked. Continuing ..."
 else
   echo "\n[STATUS] ** The javac command failed. No point in continuing..."
   exit 1
fi


echo "\n[STATUS] Java compiled into .class files; now we need to make a clean .jar archive ..."

cd ../../../../

## We need to make a copy of our java/org/xmlqstat/generator/ tree that is free
## from ".svn/*" files and also does not contain the .java file. From that
## clean directory we can make a nice jar archive

if [ -d jarbuilder ]; then
   echo "\n[STATUS] Moving existing jarbuilder folder to jarbuilder.old"
   mv -f jarbuilder jarbuilder.old
fi

echo "\n[STATUS] Making a clean jarbuilder directory"
mkdir jarbuilder
cd ./jarbuilder/

echo "\n[STATUS] Making the org/xmlqstat/generator directory structure"
mkdir -p org/xmlqstat/generator

echo "\n[STATUS] copying compiled .class files into new directory structure"
cp -v ../java/org/xmlqstat/generator/*.class ./org/xmlqstat/generator/


echo "\n[STATUS] Making our .jar file"
jar cvf xml-qstat.jar -C . .

echo "\n[STATUS] Done! Look for a 'xml-qstat.jar' file in the jarbuilder/ folder."
