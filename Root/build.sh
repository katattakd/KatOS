#!/bin/sh
rm rootfs.tar.xz

cp ../Source/apk-tools-2*.apk apk-tools.apk
cp ../Source/alpine-keys-*.apk apk-keys.apk
cp ../Source/apk-tools-static-*.apk apk-static.apk
cp ../Source/musl-*.apk musl.apk
cp ../Source/busybox-*.apk busybox.apk
mkdir install
cp ../Core/Busybox/busybox_installed/* -r -v install/
cd install
tar -xvf ../apk-tools.apk
tar -xvf ../apk-keys.apk
tar -xvf ../musl.apk
tar -xvf ../busybox.apk
tar -xvf ../../Core/Basefs.tar.xz
cd ..

tar -xvf apk-static.apk
cp sbin/apk.static install/sbin/apk
rm -r sbin

cat << CEOF > install/etc/apk/repositories
http://nl.alpinelinux.org/alpine/latest-stable/main/
http://nl.alpinelinux.org/alpine/latest-stable/community/
CEOF

strip --strip-all -v \
  install/bin/* \
  install/usr/bin/* \
  install/sbin/* \
  install/usr/sbin/* \
  install/lib/*
cd install  
tar cf - * | xz -9 -e --check=none > ../rootfs.tar.xz
cd ..
rm -r install
