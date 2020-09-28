# Actian Vector Test harnass image builder

This Dockerfile will build a Docker image from a supplied version of
the download for Actian Vector, Community Edition.  It is intended as
a test harnass for automated testing of other systems.  In particular
EMA needs product images for testing.  Download a Actian Vector
Community installation file, then create a work folder, and copy the
.tgz file downloaded into that location.  To test Vector it is also
assumed you have a (non-source-controlled) copy of the vectorEMA.jar
file.

A Makefile is provided that demonstrates the proper build and run commands.

To build the image:

	`make`

To run the image:

	`make run`

