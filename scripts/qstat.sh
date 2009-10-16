#!/bin/sh
# This is mostly a wrapper to add file logging about when a command was called.
# For example, to track how often a command is 'hit' from a webserver request.
#
# But the wrapper also interprets these initial parameters:
#     CELL=... interpret as SGE_CELL
#     ROOT=... interpret as SGE_ROOT - should be an absolute path
#     JOB=...  interpret as '-j' option for qstat, but handle empty argument as '*'
#
# It also provides a quick fix for issue
#     http://gridengine.sunsource.net/issues/show_bug.cgi?id=1949
# and for issue
#     http://gridengine.sunsource.net/issues/show_bug.cgi?id=2515
#     [for older installations]
#
# don't rely on the exit code
# -----------------------------------------------------------------------------

# The command is basename w/o trailing .sh
cmd=${0##*/}
cmd="${cmd%%.sh}"

logfile=/dev/null
## logfile=/tmp/commandlog-$cmd

if [ ! -s $logfile ]
then
    echo "# command logger: $0" >| $logfile 2>/dev/null
    chmod 0666 $logfile 2>/dev/null
fi

## Note: "date --rfc-3339" is not a valid option for some systems (eg, Mac OSX)
## Uncomment whichever line that works on your system

# echo "$(date --rfc-3339=s) $USER@$HOST: $cmd $@" >> $logfile 2>/dev/null
# echo "$(date) $USER@$HOST: $cmd $@" >> $logfile 2>/dev/null

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
#    CELL= (SGE_CELL), ROOT= (SGE_ROOT)
#    JOB=  the '-j' option for qstat, but handle empty argument as '*'
#
unset abspath
unset jobArgs
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
    JOB=*)
        jobArgs="${1##JOB=}"
        [ -n "$jobArgs" ] || jobArgs="*"    # missing job number is '*' (all jobs)
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


case "$cmd" in
qhost)
    $abspath$cmd "$@" | sed -e 's@xmlns=@xmlns:xsd=@'
    ;;
*)
    if [ -n "$jobArgs" ]
    then
        $abspath$cmd "$@" -j "$jobArgs" | sed -e 's@</*>@@g'
    else
        $abspath$cmd "$@" | sed -e 's@</*>@@g'
    fi

    ;;
esac

# ----------------------------------------------------------------- end-of-file
