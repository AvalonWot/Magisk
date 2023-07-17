# 内核启用nbd驱动
modprobe nbd


## mumu的三个硬盘: system.vdi, ota.vdi, data.vdi
# system.vdi
#     mbr  ---  grub
#     p3   ---  boot dir/   kernel, initrd, ramdisk, cmdline
#     p6   ---  system partition
#     p7   ---  apex partition

# ota.vdi
#     p1   ---  ota partition
#     p2   ---  swap

# data.vdi
#     p1   ---  oem partition
#     p3   ---  data partition

# 通过qemu-nbd建立nbd来操作vdi硬盘
qemu-nbd -c /dev/nbd0 system.vdi
qemu-nbd -c /dev/nbd1 ota.vdi

# 提取initrd
[ -d ./boot ] || mkdir ./boot
mount /dev/nbd0p3 ./boot
[ -d ./initrd ] || mkdir ./initrd
pushd ./initrd
zcat < ../boot/initrd | cpio -imd
popd
# 提取ramdisk
[ -d ./ramdisk ] || mkdir ./ramdisk
pushd ./ramdisk
zcat < ../boot/ramdisk | cpio -imd
popd
# 建立ota
[ -d ./ota ] || mkdir ./ota
mount /dev/nbd1p1 ./ota