#!/bin/sh
# a quick fix for issue
#     http://gridengine.sunsource.net/issues/show_bug.cgi?id=2515
# place somewhere in your path - don't rely on the exit code
#
#
# But the wrapper also interprets these initial parameters:
#     CELL=... (interpret as SGE_CELL)
#     ROOT=... (interpret as SGE_ROOT - should be an absolute path)
#
# -----------------------------------------------------------------------------

#
# NB: using CDATA in the error messages doesn't seem to help with bad characters
#
error()
{
    echo "<?xml version='1.0'?><error>"
    while [ "$#" -ge 1 ]; do echo "$1"; shift; done
    echo "</error>"
    exit 1
}


# adjust the GridEngine environment based on the leading parameters:
#    CELL (SGE_CELL), ROOT (SGE_ROOT)
unset abspath
while [ "$#" -gt 0 ]
do
    case "$1" in
    CELL=*)
        export SGE_CELL="${1##CELL=}"
        shift
        ;;
    ROOT=*)
        export SGE_ROOT="${1##ROOT=}"
        abspath=/
        shift
        ;;
    *)
        break
        ;;
    esac
done


# require a good SGE_ROOT and an absolute path:
[ -d "$SGE_ROOT" -a "${SGE_ROOT##/}" != "$SGE_ROOT" ] || \
    error "invalid SGE_ROOT directory '$SGE_ROOT'"

# require a good SGE_CELL:
[ -d "$SGE_ROOT/${SGE_CELL:-default}" ] || \
    error "invalid SGE_CELL directory '$SGE_ROOT/${SGE_CELL:-default}'"


# Expand the path $SGE_ROOT/bin/<ARCH>/ (the essential bit from settings.sh).
# We need this for handling different SGE_ROOT values.
# NB: works on Linux and SunOS without adjusting LD_LIBRARY_PATH
if [ "$abspath" = / ]
then
    if [ -x "$SGE_ROOT/util/arch" ]
    then
        abspath=$SGE_ROOT/bin/$($SGE_ROOT/util/arch)/
    else
        error "'$SGE_ROOT/util/arch' not found"
    fi
fi

$abspath/qhost "$@" | sed -e 's@xmlns=@xmlns:xsd=@'

# ----------------------------------------------------------------- end-of-file
