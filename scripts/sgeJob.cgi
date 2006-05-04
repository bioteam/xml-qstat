#!/usr/bin/perl

## This is a simple CGI that should function under Apache webservers
## It feeds raw XML data about job status ("qstat -j <jobID> -xml") to Cocoon for processing
##
## To get it working:
## 1. Adjust the SGE_ROOT,SGE_CELL and QSTAT settings to match your local system
## 2. Install the script in a cgi-bin directory somewhere on your webserver
## 3. Edit the sitemap.xmap file to insert the proper URL that points to this CGI
##    the line you will want to edit will contain this string:
##    'http://127.0.0.1:8889/xmldata/sgeJob?{1}'
##    
##    Just replace that URL with one that works on your system

$ENV{'SGE_ROOT'}='/opt/sge/';
$ENV{'SGE_CELL'}='default';

$QSTAT = '/opt/sge/bin/lx24-amd64/qstat';

$jobID = $ENV{'QUERY_STRING'};

#----
# Rough security checking on CGI input, we will exit
# if query_string is longer than 10 characters OR if
# the query string contains any character that is not
# a digit(0-9). Since we pass this value directly to 
# the SGE qstat program we need to do some basic checks
# on it. 
#----

if (length ($jobID) > 10) { die("Security Failure: query_string length"); }
if ( $jobID =~ /\D\:/)      { die("Security Failure: suspicious data in query"); }


print <<"EOF";
Content-type: text/xml

EOF
print `$QSTAT -f -F -xml -j $jobID`;


1;

