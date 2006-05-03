#!/usr/bin/perl -w

#-----------------------
# Usage: 
#
#   Make sure you can run "qstat -f" (SGE env is sourced)
#   Then call this script, it will spit XML to STDOUT which
#   can be directed into a config file. If it looks like it
#   is producing good output then follow the example below
#   to create the configuration file.
# #
# Example:
#
#  ./create-threshold-config.pl > ../xmlqstat/xml/CONFIG_alarm-threshold.xml
#
# Once CONFIG_alarm-threshold.xml exists, edit CONFIG.xml to
# enable this feature in the web interface.
#
#-----------------------

my @response      = `qstat -f -xml | grep '<name>'`;
my $queueInstance = undef;
my $qconfResponse = undef;
my $threshold = undef;

print STDOUT <<EOF;
<!-- XML-QSTAT load_alarm_threshold configuration file -->
<!-- This file caches site-specific SGE queue load 
     alarm thresholds so that the xmlqstat interface
     can compare the set alarm value with the dynamically
     reported load averages. This allows us to take action
     or at least render the HTML differently if a load average
     is close to exceeding the load alarm threshold.
-->
<config>
<load_alarm_threshold>
EOF

## Now do some work ...

foreach(@response) {
    ## pull out the full name of the queue instance
    if(/<name>(.*)<\/name>/) { $queueInstance = $1; }

    ## Call "qconf -sq <queue name>" to learn the configured threshold
    $qconfResponse = `qconf -sq $queueInstance | grep load_threshold`;

    ## pull out the value of np_load_avg from the qconf -sq response
    if($qconfResponse =~ (/np_load_avg=(.*)$/)) { $threshold=$1; }

    print STDOUT "<qi name=\"$queueInstance\" ";
    print STDOUT "np_load_alarm=\"$threshold\" \/>\n";

}


print STDOUT <<EOF;
</load_alarm_threshold>
</config>

EOF
