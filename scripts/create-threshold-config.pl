#!/usr/bin/perl -w
use strict;
use Getopt::Std qw( getopts );
( my $Script = $0 ) =~ s{^.*/}{};

# --------------------------------------------------------------------------
sub usage {
    $! = 0;    # clean exit
    warn "@_\n" if @_;
    die <<"USAGE";
Usage: $Script [OPTION]

options:
  -o FILE redirect stdout to FILE
  -u      unqualified host names (removes domain names)
  -h      help


Extracts np_load_avg information from GridEngine from each queue instances

  Make sure you can run "qstat -f" (GridEngine environment is sourced)
  Then call this script, it will emit XML to STDOUT which
  can be directed into a config file. If it looks like it
  is producing good output then follow the example below
  to create the configuration file.

Example:
  ./$Script > ../xmlqstat/config/alarm-threshold.xml

USAGE
}

# --------------------------------------------------------------------------
my %opt;
getopts( 'ho:u', \%opt ) or usage();
$opt{h} and usage();

## Now do some work ...
$ENV{SGE_SINGLE_LINE} = 1;    # do not break up long lines with backslashes
@ARGV = "qstat -xml -f |";

my %queueThreshold;

while (<>) {
    ## pull out the full name of the queue instance
    s{^\s*<name>\s*|\s*</name>\s*$}{}g or next;

    if ( $opt{u} ) {
        s{(\@[^.]+)\..+$}{$1};
    }

    my $qInstance = $_;
    my ( $queue, $host ) = m{^(.+?)\@(.+)} or next;

    ## get configured threshold via "qconf -sq <queueName>"
    my ($threshold) =
      map { m{^load_thresholds\s+.*np_load_avg=([^\s,]+)} }
      qx{qconf -sq $qInstance};

    $threshold or next;

    # use the first occurance for a 'global' value
    # only save value for the queue instance if it differs from the global value
    $queueThreshold{$queue}{'#global#'} ||= $threshold;
    if ( $queueThreshold{$queue}{'#global#'} != $threshold ) {
        $queueThreshold{$queue}{$host} = $threshold;
    }
}

if ( $opt{o} ) {
    open STDOUT, "> $opt{o}" or die "cannot redirect output to '$opt{o}'\n";
    select STDOUT;
}

print <<"PRINT";
<?xml version="1.0" encoding="UTF-8"?>
<!-- XML-QSTAT alarm-threshold configuration file -->
<!--
   | This file caches site-specific SGE queue alarm thresholds so
   | that the xmlqstat interface can compare the set alarm value with
   | the dynamically reported load averages.
   | This allows us to take action or render the HTML differently
   | if a load average is close to exceeding the load alarm threshold.
   -->
<alarmThreshold>\n
PRINT

my $addNewline;
for my $queue ( sort keys %queueThreshold ) {
    my $href   = $queueThreshold{$queue};
    my $global = delete $href->{'#global#'};

    print "\n" if $addNewline;
    undef $addNewline;

    print qq{  <q name="$queue" np_load_avg="$global" />\n};

    for my $host ( sort keys %$href ) {
        my $threshold = $href->{$host};
        print qq{  <qi name="$queue\@$host" np_load_avg="$threshold" />\n};
        $addNewline++;
    }

}

print qq{\n</alarmThreshold>\n};

## ---------------------------------------------------------------- end-of-file
