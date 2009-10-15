#!/usr/bin/perl -w
use strict;
use Getopt::Std qw( getopts );

my ( $Path, $Script ) = map { m{^(.+)/([^/]+)$} } $0;    # instead of fileparse

# --------------------------------------------------------------------------
sub usage {
    $! = 0;                                              # clean exit
    warn "@_\n" if @_;
    die <<"USAGE";
Usage: $Script [OPTION]

options:
  -h      help

List the css/screen/icons/*.png files that are used or not used
in the html, xml or xsl files.

This is useful for pruning down the number of icon files for a smaller
installation.

Requires/uses git.

USAGE
}

# --------------------------------------------------------------------------
my %opt;
getopts( 'h', \%opt ) or usage();
$opt{h} and usage();

chdir "$Path/../xmlqstat" or die "cannot change dir $!\n";

my $mainDir = "";

my %fileList = do {
    local ( $_, *DIR );

    if ( opendir DIR, "css/screen/icons/" ) {
        map { /^(.+\.png)$/ ? ( $1 => 1 ) : () } readdir DIR;
    }
};

local @ARGV = "git grep -F css/screen/icons/ |";

my %referenced;
while (<>) {
    while (s{css/screen/icons/(.+?\.png)\"}{}) {
        $referenced{$1}++;
    }
}

# list files referenced
print +( scalar keys %referenced ), " icon files referenced:\n";
for ( sort keys %referenced ) {
    printf "    %-25s   # %d times\n", $_, $referenced{$_};
}


# list files referenced but not found
# probably need git mv
my %missing = %referenced;
delete @missing{ keys %fileList };

print "\n", +( scalar keys %missing ),
  " icon files referenced but not found:\n";
for ( sort keys %missing ) {
    print "    git mv icons/silk/$_  xmlqstat/css/screen/icons\n";
}


# list files found but not referenced
my %extra = %fileList;
delete @extra{ keys %referenced };

print "\n", +( scalar keys %extra ),
  " icon files found but not referenced:\n";
for ( sort keys %extra ) {
    print "    git mv xmlqstat/css/screen/icons/$_  icons/silk\n";
}

## ---------------------------------------------------------------- end-of-file
