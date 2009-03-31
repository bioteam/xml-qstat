#!/usr/bin/perl -w
# avoid starter method here - otherwise we cannot kill the daemon
use strict;
use POSIX qw();
use Getopt::Std qw( getopts );
import Sge;

###############################################################################
###############################################################################
# CUSTOMIZE THESE SETTINGS TO MATCH YOUR REQUIREMENTS:
#

my %config = (
    ## Decide where your cached XML files will be stored
    ## or override on the command-line
    ## Set to an empty string to suppress the query and the output.
    qstatf =>
      "/opt/grid/default/site/xml-qstat/xmlqstat/xml/qstatf-cached.xml",
    qstat   => "",
    qhost   => "",
    delay   => 30,
    timeout => 10,
);

#
# END OF CUSTOMIZE SETTINGS
###############################################################################
###############################################################################
( my $Script = $0 ) =~ s{^.*/}{};

# --------------------------------------------------------------------------
sub usage {
    $! = 0;    # clean exit
    warn "@_\n" if @_;
    die <<"USAGE";
usage: $Script [OPTION] [PARAM]
  Cache GridEngine 'qstat -f' information in xml format.

options:
  -d      daemonize

  -h      help

  -k      kill running daemon

  -w      wake-up daemon from sleep

params:
  delay=N
            waiting period in seconds between queries in daemon mode
            (a delay of 0 is interpreted as 30 seconds)

  qhost=FILE
            save 'qhost' query (as per qlicserver) to FILE
            (default: $config{qhost})

  qstat=FILE
            save 'qstat' query (as per qlicserver) to FILE
            (default: $config{qstat})

  qstatf=FILE
            save 'qstat -f' query to FILE
            (default: $config{qstatf})

  timeout=N
            command timeout in seconds (default: 10 seconds)


Use the qhost and qstat queries if you do not have the qlicserver running
but wish to use the corresponding XSLT transformations.

USAGE
}

# --------------------------------------------------------------------------
my %opt;
getopts( "hdkw", \%opt );    # tolerate faults on unknown options
$opt{h} and usage();

sub kill_daemon {
    my $signal = shift || 9;
    my @list =
      grep { $_ != $$ }
      map  { /^\s*(\d+)\s*$/ } qx{ps -C $Script -o pid= 2>/dev/null};
    kill $signal => @list if @list;
}

# ---------------------------------------------------------------------------
# '-k'
# terminate processes
# ---------------------------------------------------------------------------
if ( $opt{k} ) {
    kill_daemon 15;    # TERM
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

# create readonly files to prevent other processes from monkeying with them
umask( 0222 | umask );

# extract command-line parameters of the form param=value
# we can only overwrite the default config
for (@ARGV) {
    if ( my ( $k, $v ) = /^([A-Za-z]\w*)=(.+)$/ ) {
        if ( exists $config{$k} ) {
            $config{$k} = $v;
        }
    }
}

# ---------------------------------------------------------------------------
# standard query, with optional '-d' (daemonize)
# ---------------------------------------------------------------------------
my $daemon = $opt{d};

if ($daemon) {    # daemonize

    # the delay between loops
    my $delay = $config{delay};
    $daemon = ( $delay and $delay =~ /^\d+$/ ) ? $delay : 30;

    # terminate old processes
    kill_daemon 15;    # TERM

    my $pid = fork;
    exit if $pid;      # let parent exit
    defined $pid or die "Couldn't fork: $!";

    # create a new process group
    POSIX::setsid() or die "Can't start a new session: $!";

    # Trap fatal signals, setting flag to exit gracefully
    $SIG{INT} = $SIG{TERM} = $SIG{HUP} = sub { undef $daemon };
    $SIG{PIPE} = "IGNORE";
    $SIG{USR1} = sub { sleep 0; };    # allow wake-up on demand
}

# setup before query
# adjust timeout - the license server is the Achilles heel
if ( exists $config{timeout} ) {
    Shell->timeout( $config{timeout} );
}

# one query must be defined
usage "ERROR: define at least one of 'qhost', 'qstat' or 'qstatf'\n"
  if not grep { $config{$_} } qw( qhost qstat qstatf );

# Query Grid Engine for XML status data
do {
    Sge->qstatfCacher( $config{qstatf} );
    Sge->qstatCacher( $config{qstat} );
    Sge->qhostCacher( $config{qhost} );
    sleep( $daemon || 0 );
} while $daemon;

exit 0;

# --------------------------------------------------------------------------
# the qx// command with a simple timeout wrapper

package Shell;
our ($timeout);

BEGIN {
    $timeout = 10;
}

#
# assign new timeout
#
sub timeout {
    my ( $caller, $value ) = @_;
    $timeout = ( $value and $value =~ /^\d+$/ ) ? $value : 10;
}

sub cmd {
    my ( $caller, @command ) = @_;
    my ( $redirect, @lines );
    local *OLDERR;

    eval {
        local $SIG{ALRM} = sub { die "TIMEOUT\n" };    # NB: '\n' required
        alarm $timeout if $timeout;
        @command or die "$caller: Shell->cmd with an undefined query\n";
        if ( @command > 1 ) {
            local *PIPE;

            open OLDERR, ">&", \*STDERR and $redirect++;
            open STDERR, ">/dev/null";

            if ( open PIPE, '-|', @command ) {         # open without shell
                @lines = <PIPE>;
            }
        }
        else {
            @lines = qx{$command[0] 2>&1};
        }
        die "(EE) ", @lines if $?;
        alarm 0;
    };

    # restore stderr
    if ($redirect) {
        open STDERR, ">&OLDERR";
    }

    if ($@) {
        if ( $@ eq "TIMEOUT\n" ) {
            warn "(WW) TIMEOUT after $timeout seconds on '@command'\n";
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
use vars qw( $bin );

BEGIN {
    $ENV{SGE_SINGLE_LINE} = 1;    # do not break up long lines with backslashes

    $bin = $ENV{SGE_BINARY_PATH} || '';

    if ( -d ( $ENV{SGE_ROOT} || '' ) ) {
        my $arch = $ENV{SGE_ARCH}
          || qx{$ENV{SGE_ROOT}/util/arch}
          || 'NONE';

        chomp $arch;

        -d $bin or $bin = "$ENV{SGE_ROOT}/bin/$arch";
    }

    for ($bin) {
        if ( -d $_ ) {
            s{/*$}{/};
        }
        else {
            $_ = '';
        }
    }

}

# relay command to Shell
sub bin {
    my $caller = shift;
    my $cmd    = $bin . (shift);

    return Shell->cmd( $cmd, @_ );
}

sub writeCache {
    my $caller    = shift;
    my $cacheFile = shift;
    @_ or return;

    ## use temp file with rename to avoid race conditions
    ## catch "-" STDOUT alias, and use 2-argument open for ">-" as well
    my $tmpFile = $cacheFile;
    if ( $cacheFile ne "-" ) {
        $tmpFile .= ".TMP";
        unlink $tmpFile;
    }
    local *FILE;
    open FILE, ">$tmpFile" or return;

    for (@_) {
        print FILE $_;
    }

    close FILE;    # explicitly close before rename
    if ( $tmpFile ne $cacheFile ) {
        chmod 0444      => $tmpFile;      # output cache is readonly
        rename $tmpFile => $cacheFile;    # atomic
    }
}


# --------------------------------------------------------------------------

sub qstatfCacher {
    my $caller    = shift;
    my $cacheFile = shift or return;

    my $lines = Sge->bin( qstat => qw( -u * -xml -r -f -explain aAcE ) )
      or return;

    Sge->writeCache( $cacheFile, $lines );
}

sub qstatCacher {
    my $caller    = shift;
    my $cacheFile = shift or return;

    my $lines = Sge->bin( qstat => qw( -u * -xml -r -s prs) ) or return;

    Sge->writeCache( $cacheFile, $lines );
}

sub qhostCacher {
    my $caller    = shift;
    my $cacheFile = shift or return;

    my $lines = Sge->bin( qhost => qw( -q -j -xml ) ) or return;

    # replace xmlns= with xmlns:xsd=
    $lines =~ s{\s+xmlns=}{ xmlns:xsd=}s;

    Sge->writeCache( $cacheFile, $lines );
}

1;

# --------------------------------------------------------------------------

## __DATA__
##
## =pod
##
## =head1 NAME
##
## xmlqstat-cacher.pl
##
## =head1 MORE
##
## see xmlqstat-cacher.pl -h
##
## * Skeleton code for this daemon process taken from
## 	the "qlicserver" daemon written by Mark Olesen
##
##  * This is a derived work from Mark's "qlicserver" code
##  * Modified by Chris Dagdigian (all mistakes are my own!)
###
##-----------------------------------------------------------
##   NOTE:
##         copyright (c) 2003-08 <Mark.Olesen\@emconTechnologies.com>
##
##         Licensed and distributed under the Creative Commons
##         Attribution-NonCommercial-ShareAlike 2.5 License.
##         http://creativecommons.org/licenses/by-nc-sa/2.5
##-----------------------------------------------------------
##
## =cut
