#!/bin/sh
# This is mostly a wrapper to add file logging about when a command was called.
# For example, to track how often a command is 'hit' from a webserver request.
#
# But the wrapper also interprets these initial parameters:
#     SGE_CELL
#     SGE_ROOT
# ----------------------------------------------------------------------

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


$cmd "$@"

# ----------------------------------------------------------------- end-of-file
