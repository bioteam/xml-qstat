#!/bin/sh
# This is simply a wrapper that adds logging to a file
# about when a command was called.
# This is principally useful to track how often a commands is 'hit'
# from a webserver request

# the command is basename w/o trailing .sh

cmd=${0##*/}
cmd="${cmd%%.sh}"

## logfile=/dev/null
logfile=/tmp/commandlog-$cmd

if [ ! -s $logfile ]
then
   echo "# command logger: $0" >| $logfile 2>/dev/null
   chmod 0666 $logfile 2>/dev/null
fi

echo "$(date --rfc-3339=s) $USER@$HOST: $cmd $@" >> $logfile 2>/dev/null

$cmd "$@"
