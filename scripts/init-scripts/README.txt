Files in this directory represent attempts to create basic system
startup/boot scripts so that the xml-qstat web application starts
automatically when systems are restarted.

There are 1-3 systems that might need to be started:

  1. The Apache Cocoon application server.
     MUST be running!

  2. The perl daemon that caches XML status data.
     Might be required if you are not using the qlicserver integration
     and/or the Java Command-Generator.

  3. The httpi web-server.
     Might be required, depending on which extras you need or if you
     aren't using the Java Command-Generator.


Requirements
~~~~~~~~~~~~
  - Obviously SGE should be up and running before these scripts are invoked
  - Apache HTTPD server should also probably be available as well
  - The scripts here will have to be edited to reflect local site conditions

Weaknesses
~~~~~~~~~~
  - Stopping/restarting is clunky, but should work

WARNING
~~~~~~~
  - System init scripts typically run as root and xml-qstat has been
    designed to be invoked and run from "normal" user accounts.

  - The scripts here use "sudo" to become a non-root user. The
    account you pick for this should probably the account you have
    been installing the application with.

2009-06-02
