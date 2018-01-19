#!/bin/bash -ex

flac="1.3.2"
_arch="x86_64-w64-mingw32"
opus="1.2.1"

mkdir -p mingw
pushd mingw
mingwurl="https://github.com/Studio-Link-v2/mingw/releases/download/v18.01.0"
wget -N $mingwurl/cloog-0.18.5-1-x86_64.pkg.tar.xz
wget -N $mingwurl/isl-0.18-3-x86_64.pkg.tar.xz
wget -N $mingwurl/mingw-w64-binutils-2.29-1-x86_64.pkg.tar.xz
wget -N $mingwurl/mingw-w64-configure-0.1-1-any.pkg.tar.xz
wget -N $mingwurl/mingw-w64-crt-5.0.3-1-any.pkg.tar.xz
wget -N $mingwurl/mingw-w64-gcc-7.2.1.20171224-1-x86_64.pkg.tar.xz
wget -N $mingwurl/mingw-w64-headers-5.0.3-1-any.pkg.tar.xz
wget -N $mingwurl/mingw-w64-pkg-config-2-3-any.pkg.tar.xz
wget -N $mingwurl/mingw-w64-winpthreads-5.0.3-1-any.pkg.tar.xz
wget -N $mingwurl/osl-0.9.1-1-x86_64.pkg.tar.xz
yes | LANG=C sudo pacman -U *.pkg.tar.xz
popd

env

x86_64-w64-mingw32-gcc -v
echo | x86_64-w64-mingw32-gcc -E -Wp,-v -
ls -lha /usr/lib/gcc/x86_64-w64-mingw32/7.2.1/../../../../x86_64-w64-mingw32/include/io.h
ls -lha /usr/x86_64-w64-mingw32/include/io.h

cat /usr/bin/x86_64-w64-mingw32-configure


# Build opus
#-----------------------------------------------------------------------------
if [ ! -d opus-$opus ]; then
    wget -N "https://archive.mozilla.org/pub/opus/opus-${opus}.tar.gz"
    tar -xzf opus-${opus}.tar.gz
    mkdir opus-$opus/build
    pushd opus-$opus/build
    ${_arch}-configure \
        --enable-custom-modes \
        --disable-doc \
        --disable-extra-programs
    make
    popd
    mkdir opus; cp opus-$opus/build/.libs/libopus.a opus/
    cp -a opus-$opus/include/*.h opus/
fi



exit 0

wget http://downloads.xiph.org/releases/flac/flac-${flac}.tar.xz
tar -xf flac-${flac}.tar.xz
ln -s flac-${flac} flac

mkdir flac/build_win
pushd flac/build_win
${_arch}-configure --disable-ogg --enable-static --disable-cpplibs
make
popd
