#!/bin/sh
# a quick fix for issue
#     http://gridengine.sunsource.net/issues/show_bug.cgi?id=2515
# place somewhere in your path - don't rely on the exit code
#
#
# But the wrapper also interprets these initial parameters:
#     SGE_CELL
#     SGE_ROOT
# ----------------------------------------------------------------------
# find initial SGE_* parameters
unset settings
while [ "$#" -gt 0 ]
do
    case "$1" in
    SGE_CELL=*)
        eval "export ${1%%/}"
        shift
        ;;
    SGE_ROOT=*)
        eval "export ${1%%/}"
        settings=true
        shift
        ;;
    *)
        break
        ;;
    esac
done


if [ ${settings:-false} = true ]
then
    # this is the essential bit from settings.sh,
    # but SGE_ROOT might be different
    if [ -x $SGE_ROOT/util/arch ]
    then
         PATH=$SGE_ROOT/bin/`$SGE_ROOT/util/arch`:$PATH
         export PATH
    fi
fi


qhost "$@" | sed -e 's/xmlns=/xmlns:xsd=/'

# ----------------------------------------------------------------- end-of-file
