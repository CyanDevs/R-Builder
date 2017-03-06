# R-Builder

This bash script is meant for automating the compilation of R 3.3.2 on CentOS 6, given that you have gcc 5.0 or higher.

In the initial lines of R-Builder.sh you can specify:

RVER: The version of R that you want to compile. 
       Default: R-3.3.2
INSTALLDIR: The absolute path to the folder you want to install R in. 
          Default: /opt/R-3.3.2
BUILDDIR: The path to the location that you want to build R in. 
          Default: ~/R-3.3.2-BUILD 
          Notice this is in your home directory and depends on tilde expansion. 
GCCDIR: The absolute path to your GCC 5.0+ installation. GCC versions 5.0 or greater is required to compile R 3.3 and above. 
        Default: /opt/gcc-5.2.0

To run the script from the same directory as R-builder.sh:
./R-builder.sh

Recommend that you output the log file as well by:
./R-builder.sh | tee Rbuild.log
