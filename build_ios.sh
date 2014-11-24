#!/bin/sh

# http://www.videolan.org/developers/x264.html
# ftp.videolan.org/pub/videolan/x264/snapshots/
# http://ffmpegmac.net/HowTo/

major=1
minor=28
micro=0

SDK_VERS=8.1
XCD_ROOT="/Applications/Xcode.app/Contents/Developer"
TOL_ROOT="${XCD_ROOT}/Toolchains/XcodeDefault.xctoolchain"
SDK_ROOT="${XCD_ROOT}/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS${SDK_VERS}.sdk"
SDK_SML_ROOT="${XCD_ROOT}/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator${SDK_VERS}.sdk"

export PATH=$TOL_ROOT/usr/bin:$PATH

work=`pwd`
srcs=$work/src
buid=$work/build
insl=$buid/install
name=faac-${major}.${minor}
pakt=${name}.tar.gz
dest=$work/faac-iOS-${major}.${minor}.${micro}.tgz

rm -rf $srcs $buid $dest && mkdir -p $srcs $buid

[[ ! -e $pakt ]] && {
  wget ftp://mirror.ovh.net/gentoo-distfiles/distfiles/$pakt
}

archs="armv7 armv7s arm64 i386"

for a in $archs; do
  case $a in
    arm*)
      sys_root=${SDK_ROOT}
      host=arm-apple-darwin9
      ;;
    i386)
      sys_root=${SDK_SML_ROOT}
      host=i686-apple-darwin9
      ;;
  esac
  prefix=$insl/$a && rm -rf $prefix && mkdir -p $prefix
  rm -rf $srcs && mkdir -p $srcs && cd $work && tar xvzf $pakt -C $srcs && cd $srcs/$name
  chmod +x bootstrap
  ./bootstrap
  ./configure \
    CFLAGS="  -arch $a -isysroot $sys_root -miphoneos-version-min=7.0" \
    CXXFLAGS="-arch $a -isysroot $sys_root -miphoneos-version-min=7.0" \
    LDFLAGS=" -arch $a -isysroot $sys_root -miphoneos-version-min=7.0" \
    --host=$host \
    --prefix=$prefix \
    --disable-shared \
    --enable-static \
    --disable-faac \
    --with-mp4v2 \
    && make \
    && make install
  lipo_archs="$lipo_archs $prefix/lib/libfaac.a"
done

univ=$insl/universal && mkdir -p $univ/lib
cp -r $prefix/include $univ/
lipo $lipo_archs -create -output $univ/lib/libfaac.a
ranlib $univ/lib/libfaac.a
strip -S $univ/lib/libfaac.a

cd $univ && tar cvzf $dest *
