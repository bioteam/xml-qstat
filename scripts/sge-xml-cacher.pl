#!/usr/bin/perl -w
# avoid starter method here - otherwise we cannot kill the daemon

## -----------------------------------------------------------------------
#!/usr/bin/perl -w	# really start here
use strict;
use Getopt::Std qw( getopts );
use POSIX;
import Sge;
import cacheQstat;

my %config;

###############################################################################
###############################################################################
# CUSTOMIZE THESE SETTINGS TO MATCH YOUR REQUIREMENTS:
#

   # (1) Decide where your cached XML files will be stored 
$config{'XML_OUTPUT_PATH'} = "/opt/xml-qstat/xmlqstat/xml/cached-sge-status.xml";


#
# END OF CUSTOMIZE SETTINGS
###############################################################################
###############################################################################


( my $Script = $0 ) =~ s{^.*/}{};
my $CmdLine = join( " " => $Script, @ARGV );
my $tmpPath = "";



# --------------------------------------------------------------------------
sub usage {
    $! = 0;               # clean exit
    warn "@_\n" if @_;
    die <<"USAGE";

usage: $Script [OPTION] [ARGS]

  ## stuff goes here ... 

USAGE
}

# --------------------------------------------------------------------------
my %opt;
getopts( "hdkt:", \%opt );    # tolerate faults on unknown options
$opt{h} and usage();



select STDOUT;
$| = 1;    # no output buffering

sub kill_daemon {
    my $signal = shift || 9;
    my @list =
      grep { $_ != $$ }
      map  { /^\s*(\d+)\s*$/ } qx{ps -C $Script -o pid= 2>/dev/null};
    kill $signal => @list if @list;
}


# ---------------------------------------------------------------------------
# '-k'
# kill daemon
# ---------------------------------------------------------------------------
if ( $opt{k} ) {
    kill_daemon;    # KILL
    exit 0;
}

# ---------------------------------------------------------------------------
# '-w'
# wakeup daemon
# ---------------------------------------------------------------------------
if ( $opt{w} ) {
    kill_daemon 10;    # USR1
    exit 0;
}




# ---------------------------------------------------------------------------
# standard query, with optional '-d' (daemonize)
# ---------------------------------------------------------------------------
my ( $daemon, $delay ) = ( $opt{d}, 0 );

if ($daemon) {    # daemonize
    ( my $delay = (shift) || '' );
    $delay =~ /^\d+$/ or undef $delay;
    $daemon = $delay || 30;    # provide default delay

    kill_daemon();             # remove old junk
    my $pid = fork;
    exit if $pid;              # let parent exit
    defined $pid or die "Couldn't fork: $!";

    # create a new process group
    POSIX::setsid() or die "Can't start a new session: $!";

    # Trap fatal signals, setting flag to exit gracefully
    $SIG{INT} = $SIG{TERM} = $SIG{HUP} = sub { undef $daemon };
    $SIG{PIPE} = "IGNORE";
    $SIG{USR1} = sub { sleep 0; };    # allow wake-up on demand
}

do {


 ## collect data here ...
 
 # Get a safe temporary file name to stash the initial XML
 $tmpPath = tmpnam();
 
 #Set out output path for the persistant cache
 cacheQstat->cachePath($config{'XML_OUTPUT_PATH'});

 #Query Grid Engine for XML status data
 cacheQstat->query( timeout   => 15, 
                    tmpPath   => "$tmpPath"
                    ) ;
 
 $delay = $daemon;
 
    sleep( $delay || 0 );
} while $daemon;

exit 0;

# --------------------------------------------------------------------------
package Shell;

sub cmd {
    my ( $caller, %var ) = @_;
    my $timeout = $var{timeout} || 0;
    my $cmd     = $var{cmd}     || '';
    my @lines;

    eval {
        local $SIG{ALRM} = sub { die "TIMEOUT\n" };    # NB: '\n' required
        alarm $timeout if $timeout;
        $cmd or die "$caller: Shell->cmd with an undefined query\n";
        @lines = qx{$cmd 2>&1};
        die "(EE) ", @lines if $?;
        alarm 0;
    };

    if ($@) {
        if ( $@ eq "TIMEOUT\n" ) {
            warn "(WW) TIMEOUT after $timeout seconds on '$cmd'\n";
            return undef;
        }
        else {
            die $@;    # propagate unexpected errors
        }
    }

    wantarray ? @lines : join '' => @lines;
}

1;

# --------------------------------------------------------------------------

package Sge;
use vars qw( $binary_path $utilbin_path );

BEGIN {
    $binary_path  = $ENV{SGE_BINARY_PATH} || '';
    $utilbin_path = $ENV{SGE_utilbin}     || '';

    if ( -d ( $ENV{SGE_ROOT} || '' ) ) {
        my $arch = $ENV{SGE_ARCH}
          || qx{$ENV{SGE_ROOT}/util/arch}
          || 'NONE';

        chomp $arch;

        -d $binary_path  or $binary_path  = "$ENV{SGE_ROOT}/bin/$arch";
        -d $utilbin_path or $utilbin_path = "$ENV{SGE_ROOT}/utilbin/$arch";
    }

    for ( $binary_path, $utilbin_path ) {
        if ( -d $_ ) {
            s{/*$}{/};
        }
        else {
            $_ = '';
        }
    }

    $ENV{SGE_SINGLE_LINE} = 1;    # do not break up long lines with backslashes
}

1;

# --------------------------------------------------------------------------

package cacheQstat;
use vars qw( $query $timeout $tmpPath $cachePath);

BEGIN {
    $timeout    = 15;
    $tmpPath    = "/tmp/lastResort.xml";
    #$cachePath  = $main::config{'XML_OUTPUT_PATH'};
    $query      = $Sge::binary_path . "qstat -xml -r -f -explain aAcE ";
}


sub timeout {
    my ( $caller, $value ) = @_;
    ( $value ||= 0 ) > 0 or $value = 15;
    $timeout = $value;
}

sub tmpPath {
    my ( $caller, $value ) = @_;
    $tmpPath = $value;
}

sub cachePath {
    my ( $caller, $value ) = @_;
    $cachePath = $value;
}

sub query {
    my $caller  = shift;

    #print "Query: $query > $tmpPath (cache to $cachePath) \n";
    my $lines = Shell->cmd( timeout => $timeout, cmd => "$query > $tmpPath" );
    
    $lines = Shell->cmd( timeout => $timeout, cmd => "mv -f $tmpPath $cachePath"); 

}

1;

# --------------------------------------------------------------------------

## __DATA__
##
## =pod
##
## =head1 NAME
##
## sge-xml-cacher
##
## =head1 MORE
##
## add more documentation
##
## * Skeleton code for this daemon process taken from 
## 	the "qlicserver" daemon written by Mark Olesen
##
##  * This is a derived work from Mark's "qlicserver" code
##  * Modified by Chris Dagdigian (all mistakes are my own!)
###
##-----------------------------------------------------------
##   NOTE:
##         copyright (c) 2003-05 <Mark.Olesen\@ArvinMeritor.com>
##
##         Licensed and distributed under the Creative Commons
##         Attribution-NonCommercial-ShareAlike 2.5 License.
##         http://creativecommons.org/licenses/by-nc-sa/2.5
##-----------------------------------------------------------
##
## =cut
