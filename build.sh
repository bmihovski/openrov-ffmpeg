#!/bin/bash
set -e
# Export variables
export CCPREFIX="/opt/toolchain/arm/bin/arm-none-linux-gnueabi-"

#Install git

apt-get -y install git

# Get the FFMPEG source
git clone git://source.ffmpeg.org/ffmpeg.git

cd ffmpeg

# Get library dependency sources
git clone git://git.videolan.org/x264
cd x264

# Build x264
./configure --host=arm-linux --enable-static --enable-pic --cross-prefix=${CCPREFIX} --disable-asm --prefix=${PWD}/../../output/usr
make -j8
make install
cd ..

# Build FFMPEG
./configure --prefix=./build/ --enable-cross-compile --cross-prefix=${CCPREFIX} --arch=armhf --target-os=linux --disable-vaapi --enable-libfontconfig --enable-libzvbi --disable-shared --enable-gpl --enable-libx264 --enable-pic --enable-static --disable-libass --extra-cflags="-I${PWD}/../output/usr/include/" --extra-ldflags="-L${PWD}/../output/usr/lib" --extra-libs="-ldl"
make -j8

make prefix=${PWD}/../output/usr install
