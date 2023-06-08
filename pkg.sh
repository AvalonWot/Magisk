#!/bin/bash


[ -d ./ramdisk/overlay.d ] || mkdir -p ./ramdisk/overlay.d/sbin/
[ -f ./magiskinit ] || cp ./magiskinit ./ramdisk/init
[ -f ./magisk32 ] || xz -z -c --check=crc32 ./magisk32 > ./ramdisk/overlay.d/sbin/magisk32.xz
[ -f ./magisk64 ] || xz -z -c --check=crc32 ./magisk64 > ./ramdisk/overlay.d/sbin/magisk64.xz
[ -f ./stub.apk ] || xz -z -c --check=crc32 ./stub.apk > ./ramdisk/overlay.d/sbin/stub.xz
[ -f ./config ] || cp ./config ./ramdisk/overlay.d/.magisk
pushd ./ramdisk
find . | cpio -o -H 'newc' -a --device-independent | gzip -9 > ../ota/ramdisk
popd
# flash data to vdi
umount ./ota
mount /dev/nbd1p1 ./ota