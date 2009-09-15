#!/bin/sh

# Chris Dagdigian (dag@sonsorol.org)
#
# This script can be used to compile and package the xml-qstat.jar file
# required by Apache Cocoon for direct XML queries to the SGE qmaster.
#
# Instructions:
#
#  1. Run this script, fix as required until it runs properly to completion
#
#  2. Copy (or symlink) the resulting xml-qstat.jar file to your Cocoon
#     build/webapp/WEB-INF/lib/ directory (before starting cocoon)
# -----------------------------------------------------------------------------

## YOU MUST EDIT THIS BLOCK TO MATCH YOUR LOCAL INSTALL:
## Include full path to the build/ subfolder in your cocoon install

cocoonBase="/data/app/cocoon-2.1.11/build"

case "$cocoonBase" in

*cocoon-2.1.10*)
MYCLASSPATH="$cocoonBase/cocoon/cocoon.jar:\
$cocoonBase/webapp/WEB-INF/lib/commons-lang-2.2.jar:\
$cocoonBase/webapp/WEB-INF/lib/avalon-framework-api-4.3.jar:\
$cocoonBase/webapp/WEB-INF/lib/excalibur-pool-api-2.1.jar:\
$cocoonBase/webapp/WEB-INF/lib/excalibur-sourceresolve-2.1.jar:\
$cocoonBase/webapp/WEB-INF/lib/excalibur-xmlutil-2.1.jar\
"
;;

*cocoon-2.1.11*)
MYCLASSPATH="$cocoonBase/cocoon/cocoon.jar:\
$cocoonBase/webapp/WEB-INF/lib/commons-lang-2.3.jar:\
$cocoonBase/webapp/WEB-INF/lib/avalon-framework-api-4.3.jar:\
$cocoonBase/webapp/WEB-INF/lib/excalibur-pool-api-2.1.jar:\
$cocoonBase/webapp/WEB-INF/lib/excalibur-sourceresolve-2.2.3.jar:\
$cocoonBase/webapp/WEB-INF/lib/excalibur-xmlutil-2.1.jar\
"
;;

*)
echo
echo "[ERROR] unidentified cocoon version:"
echo "        $cocoonBase"
echo
exit 1
;;

esac

## END OF EDITABLE SECTION
# -----------------------------------------------------------------------------
## -- should not need changes below -- ##

[ -d "$cocoonBase" ] || {
    echo
    echo "[ERROR] cocoon directory does not exist:"
    echo "        $cocoonBase"
    echo
    exit 1
}

echo
echo "[STATUS] Changing to xmlqstat generator directory and trying this command:"
echo "--------"
echo "         javac -classpath $MYCLASSPATH CommandGenerator.java"
echo "--------"

if
(
    cd java/org/xmlqstat/generator/ && \
    javac -classpath $MYCLASSPATH CommandGenerator.java
)
then
    echo "[STATUS] Compiled java -> class files"
else
    echo
    echo "[ERROR] The javac compilation failed"
    echo
    exit 1
fi

## Make a clean java/org/xmlqstat/generator/ tree
## (free of ".svn/*" and .java files) and use that to create a jar archive

if [ -d build-jar ]
then
    rm -rf build-jar.old 2>/dev/null
    mv -f build-jar build-jar.old
    echo "[STATUS] Moved existing build-jar/ folder to build-jar.old/"
fi

echo "[STATUS] Creating clean build-jar/ directory with the org/xmlqstat/generator"
echo "         directory structure and moving the compiled .class files into it"
mkdir -p build-jar/org/xmlqstat/generator
mv -v java/org/xmlqstat/generator/*.class build-jar/org/xmlqstat/generator/

echo
echo "[STATUS] Creating the build-jar/xml-qstat.jar file"

if
(
    cd build-jar && \
    jar cvf xml-qstat.jar -C . .
)
then
    echo
    echo "[STATUS] Done"
    echo
    echo "You should copy (or symlink) the 'xml-qstat.jar' file to the"
    echo "WEB-INF/lib/ directory."
    echo "eg,"
    echo "    cp build-jar/xml-qstat.jar $cocoonBase/webapp/WEB-INF/lib/"
    echo
else
    echo
    echo "[ERROR] Failed to create 'build-jar/xml-qstat.jar' file"
    echo
fi

# ----------------------------------------------------------------- end-of-file
