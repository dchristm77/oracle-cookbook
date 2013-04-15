oracle-cookbook
===============

Chef cookbook using oratoolkit to install oracle database to a linux vm

note
====

Oracle .zip files (2) and the rpm files (2) (oratoolkit, rpmforge repository) will need to be downloaded separately and added to the files/default directories of the admin (rpmforge) and oracle (database software and oratoolkit) cookbooks.  

This cookbook is in ALPHA!!

Testing
=======
Thus far it has only been proven to work using centos (32 bit) 6.4 and Oracle 11g EE 11.2.  It should work with vagrant and any "yum" (redhat) based distrubution.  For other distrubutions a few additions will need to be made to make accomadations for the apt package manager.
