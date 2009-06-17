#!/bin/sh
# This is mostly a wrapper to add file logging about when a command was called.
# For example, to track how often a command is 'hit' from a webserver request.
#
# But the wrapper also interprets these initial parameters:
#     SGE_CELL
#     SGE_ROOT (should be an absolute path)
#
# and also supplies a quick fix for issue
#     http://gridengine.sunsource.net/issues/show_bug.cgi?id=2515
# for older installations (don't rely on the exit code)
#
# as well as a quick fix for issue
#     http://gridengine.sunsource.net/issues/show_bug.cgi?id=3057
#
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

echo "$(date --rfc-3339=s) $USER@$HOST: $cmd $@" >> $logfile 2>/dev/null

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


# find initial SGE_* parameters
unset settings
while [ "$#" -gt 0 ]
do
    case "$1" in
    SGE_CELL=*)
        export SGE_CELL="${1##SGE_CELL=}"
        shift
        ;;
    SGE_ROOT=*)
        export SGE_ROOT="${1##SGE_ROOT=}"
        settings=true
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


# this is the essential bit from settings.sh,
# but SGE_ROOT might be different
if [ ${settings:-false} = true ]
then
    if [ -x "$SGE_ROOT/util/arch" ]
    then
        PATH=$SGE_ROOT/bin/$($SGE_ROOT/util/arch):$PATH
        export PATH
    else
        error "'$SGE_ROOT/util/arch' not found"
    fi
fi


case "$cmd" in
qhost)
    $cmd "$@" | sed -e 's@xmlns=@xmlns:xsd=@'
    ;;
*)
    $cmd "$@" | sed -e 's@</*>@@g'
    ;;
esac

# ----------------------------------------------------------------- end-of-file
