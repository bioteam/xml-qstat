#!/usr/bin/perl -w
use strict;

# -----------------------
# Usage:
#
#   Make sure you can run "qstat -f" (SGE env is sourced)
#   Then call this script, it will spit XML to STDOUT which
#   can be directed into a config file. If it looks like it
#   is producing good output then follow the example below
#   to create the configuration file.
#
# Example:
#  ./create-threshold-config.pl > ../xmlqstat/config/alarm-threshold.xml
#
# Once config/alarm-threshold.xml exists, edit config/config.xml to
# enable this feature in the web interface.
#
# -----------------------

# remove domains?
my $unqualified;


print <<"PRINT";
<!-- XML-QSTAT load_alarm_threshold configuration file -->
<!--
   | This file caches site-specific SGE queue load alarm thresholds so
   | that the xmlqstat interface can compare the set alarm value with
   | the dynamically reported load averages.
   | This allows us to take action or at least render the HTML differently
   | if a load average is close to exceeding the load alarm threshold.
   -->
<config>
<load_alarm_threshold>
PRINT

## Now do some work ...
@ARGV = "qstat -xml -f |";

while (<>) {
    ## pull out the full name of the queue instance
    s{^\s*<name>\s*|\s*</name>\s*$}{}g or next;

    if ($unqualified) {
        s{(\@[^.]+)\..+$}{$1};
    }

    my $qInstance = $_;

    ## get configured threshold via "qconf -sq <queueName>"
    my ($threshold) =
      map { s/^load_thresholds\s+np_load_avg=// ? $_ : () }
      qx{qconf -sq $qInstance};

    chomp( $threshold ||= 0 );

    print qq{  <qi name="$qInstance" np_load_alarm="$threshold" />\n};
}

print <<"PRINT";
</load_alarm_threshold>
</config>

PRINT

## ---------------------------------------------------------------- end-of-file
