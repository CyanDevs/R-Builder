#Versions
RVER=R-3.3.2
GCCVER=gcc-5.2.0

#Folder locations
INSTALLDIR=/opt/R-3.3.2
BUILDDIR=~/$RVER-BUILD
GCCDIR=/opt/$GCCVER
#Currently using download links. Should download them to local disk and keep them as a bundle, or look into alternatives.

#SETUP BUILD ENVIRONMENT
cd ~
wget https://cran.r-project.org/src/base/R-3/$RVER.tar.gz
tar xvzf $RVER.tar.gz
mv $RVER $BUILDDIR
cd $BUILDDIR
mkdir dependencies
cd dependencies
wget http://www.zlib.net/zlib-1.2.8.tar.gz
wget http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz
wget http://tukaani.org/xz/xz-5.2.2.tar.gz
wget http://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.38.tar.bz2
wget https://github.com/curl/curl/archive/curl-7_49_0.tar.gz

#Check to see if any files failed to download
if [ -f ~/R-3.3.2-BUILD/dependencies/zlib-1.2.8.tar.gz ]
	then
		echo "Note: zlib-1.2.8.tar.gz downloaded successfully"
	else
		echo "Error: failed to download zlib-1.2.8.tar.gz"
		rm -f $BUILDDIR
		kill $$
fi

if [ -f $BUILDDIR/dependencies/bzip2-1.0.6.tar.gz ]
	then
		echo "Note: bzip2-1.0.6.tar.gz downloaded successfully"
	else
		echo "Error: failed to download bzip2-1.0.6.tar.gz"
		rm -f $BUILDDIR
		kill $$
fi

if [ -f $BUILDDIR/dependencies/xz-5.2.2.tar.gz ]
	then
		echo "Note: xz-5.2.2.tar.gz downloaded successfully"
	else
		echo "Error: failed to download xz-5.2.2.tar.gz"
		rm -f $BUILDDIR
		kill $$
fi

if [ -f $BUILDDIR/dependencies/pcre-8.38.tar.bz2 ]
	then
		echo "Note: pcre-8.38.tar.bz2 downloaded successfully"
	else
		echo "Error: failed to download pcre-8.38.tar.bz2"
		rm -f $BUILDDIR
		kill $$
fi

if [ -f $BUILDDIR/dependencies/curl-7_49_0.tar.gz ]
	then
		echo "Note: curl-7_49_0.tar.gz downloaded successfully"
	else
		echo "Error: failed to download curl-7_49_0.tar.gz"
		rm -f $BUILDDIR
		kill $$
fi

#Build zlib
cd $BUILDDIR/dependencies
tar xzf zlib-1.2.8.tar.gz
cd zlib-1.2.8
./configure --prefix=$INSTALLDIR
make
#Check
if [ $? -eq 0 ]; then
    echo "zlib built OK"
else
    echo "Error: zlib failed to build"
    rm -rf $BUILDDIR
    kill $$
fi

#Build bzip2
cd $BUILDDIR/dependencies
tar xzf bzip2-1.0.6.tar.gz
cd bzip2-1.0.6
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile
make -f Makefile-libbz2_so CFLAGS="-fPIC"
make clean
make
#Check
if [ $? -eq 0 ]; then
    echo "bzip2 built OK"
else
    echo "Error: bzip2 failed to build"
    rm -rf $BUILDDIR
    kill $$
fi

#Build lzma
cd $BUILDDIR/dependencies
tar xzf xz-5.2.2.tar.gz
cd xz-5.2.2
./configure --prefix=$INSTALLDIR
make
#Check
if [ $? -eq 0 ]; then
    echo "lzma built OK"
else
    echo "Error: lzma failed to build"
    rm -rf $BUILDDIR
    kill $$
fi

#Build pcre
cd $BUILDDIR/dependencies
tar xjf pcre-8.38.tar.bz2
cd pcre-8.38
wget http://www.linuxfromscratch.org/patches/downloads/pcre/pcre-8.38-upstream_fixes-1.patch
patch -Np1 -i pcre-8.38-upstream_fixes-1.patch
./configure --prefix=$INSTALLDIR                 \
            --enable-unicode-properties       \
            --enable-pcre16                   \
            --enable-pcre32                   \
            --enable-pcregrep-libz            \
            --enable-pcregrep-libbz2          \
            --enable-pcretest-libreadline     \
            --disable-static
make
#Check
if [ $? -eq 0 ]; then
    echo "pcre built OK"
else
    echo "Error: pcre failed to build"
    rm -rf $BUILDDIR
    kill $$
fi

#Build curl
cd $BUILDDIR/dependencies
tar xzf curl-7_49_0.tar.gz
cd curl-curl-7_49_0
./buildconf
./configure --prefix=$INSTALLDIR
make
#Check
if [ $? -eq 0 ]; then
    echo "curl built OK"
else
    echo "Error: curl failed to build"
    rm -rf $BUILDDIR
    kill $$
fi

#Make install directory
mkdir $INSTALLDIR

#Install zlib
cd $BUILDDIR/dependencies/zlib-1.2.8
make PREFIX=$INSTALLDIR install
#Check
if [ $? -eq 0 ]; then
    echo "zlib built OK"
else
    echo "Error: zlib failed to install"
    rm -rf $BUILDDIR $INSTALLDIR
    kill $$
fi

#Install bzip2
cd $BUILDDIR/dependencies/bzip2-1.0.6
make PREFIX=$INSTALLDIR install
#Check
if [ $? -eq 0 ]; then
    echo "bzip2 built OK"
else
    echo "Error: bzip2 failed to install"
    rm -rf $BUILDDIR $INSTALLDIR
    kill $$
fi
cp -v bzip2-shared $INSTALLDIR/bin/
ln -sv libbz2.so.1.0 libbz2.so
cp -av libbz2.so* $INSTALLDIR/lib/

#Install lzma
cd $BUILDDIR/dependencies/xz-5.2.2
make PREFIX=$INSTALLDIR install
if [ $? -eq 0 ]; then
    echo "lzma built OK"
else
    echo "Error: lzma failed to install"
    rm -rf $BUILDDIR $INSTALLDIR
    kill $$
fi

#Install pcre
cd $BUILDDIR/dependencies/pcre-8.38
make PREFIX=$INSTALLDIR install
if [ $? -eq 0 ]; then
    echo "pcre built OK"
else
    echo "Error: pcre failed to install"
    rm -rf $BUILDDIR $INSTALLDIR
    kill $$
fi

#Install curl
cd $BUILDDIR/dependencies/curl-curl-7_49_0
make PREFIX=$INSTALLDIR install
if [ $? -eq 0 ]; then
    echo "curl built OK"
else
    echo "Error: curl failed to install"
    rm -rf $BUILDDIR $INSTALLDIR
    kill $$
fi

#Build R
cd $BUILDDIR/build
../configure --prefix=$INSTALLDIR \
--enable-R-shlib=yes \
--with-x=yes \
--with-cairo=yes \
--with-jpeglib=yes \
--with-libpng \
--with-libtiff \
--with-tcltk=yes \
--enable-R-profiling=yes \
CPPFLAGS=-I$INSTALLDIR/include \
CC=$GCCDIR/bin/gcc \
CFLAGS=-L$INSTALLDIR/lib \
CXX=$GCCDIR/bin/c++ \
CXXFLAGS=-L$GCCDIR/lib64 \
LDFLAGS="-L$INSTALLDIR/lib -L$GCCDIR/lib64"
if [ $? -eq 0 ]; then
    echo "R configured OK"
else
    echo "Error: R failed to configure"
    rm -rf $BUILDDIR $INSTALLDIR
    kill $$
fi

PATH=$INSTALLDIR/bin:$PATH LD_LIBRARY_PATH=$INSTALLDIR/lib:$LD_LIBRARY_PATH make
if [ $? -eq 0 ]; then
    echo "R built OK"
else
    echo "Error: R failed to build"
    rm -rf $BUILDDIR $INSTALLDIR
    kill $$
fi

#Built-in check of R build. This process takes a long time, and can be commented out if you need to bypass the check.
make check-all
if [ $? -eq 0 ]; then
    echo "R build passed check"
else
    echo "Error: R failed check"
    rm -rf $BUILDDIR $INSTALLDIR
    kill $$
fi

#Install R
touch doc/NEWS.pdf
make PREFIX=$INSTALLDIR install
if [ $? -eq 0 ]; then
    echo "R installed successfully!"
else
    echo "Error: R failed to install"
    rm -rf $BUILDDIR $INSTALLDIR
    kill $$
fi