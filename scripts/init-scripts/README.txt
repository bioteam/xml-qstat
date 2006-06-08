
Files in this directory represent attempts to create basic
system startup/boot scripts so that the xml-qstat web application
starts automatically when systems are restarted.

There are 2 systems that need to be started:

(1) The Apache Cocoon application server
(2) The perl daemon that caches XML status data

Requirements

- Obviously SGE should be up and running before these scripts are invoked
- Apache HTTPD server should also probably be available as well
- The scripts here will have to be edited to reflect local site conditions

Weaknesses

- The cocoon script can only START cocoon, not stop or restart it, for
  that you'll have to manually kill the java process until someone improves
  the code

WARNING

 - System init scripts typically run as root and xml-qstat has been
   designed to be invoked and run from "normal" user accounts. 

 - The scripts here use "sudo" to become a non-root user. The
   account you pick for this should probably the account you have
   been installing the application with. 




