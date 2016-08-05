#!/system/bin/sh

source /test-utils.sh

#
# Exit status is 0 for PASS, nonzero for FAIL
#
STATUS=0

run_mmc_case()
{
	if [ ! -d /mnt/mmc_part1 ]; then
		mkdir /mnt/mmc_part1
	fi
	mounted=`mount | grep '/dev/block/mmcblk0p6' | busybox wc -l`
	if [ $mounted = 1 ]; then
		umount /dev/block/mmcblk0p6
	fi
	mounted=`mount | grep '/mnt/mmc_part1' | busybox wc -l`
	if [ $mounted = 1 ]; then
		umount /mnt/mmc_part1
	fi
	mke2fs /dev/block/mmcblk0p6
	mount -t ext2 /dev/block/mmcblk0p6 /mnt/mmc_part1

	dd if=/dev/urandom of=/mmc_data bs=512 count=5
	cp /mmc_data /mnt/mmc_part1/mmc_data
	sync

	cmp /mmc_data /mnt/mmc_part1/mmc_data

	if [ "$?" = 0 ]; then
		print "MMC test passes \n\n"
		rm /mmc_data
		rm /mnt/mmc_part1/mmc_data
		umount /mnt/mmc_part1
		rm -r /mnt/mmc_part1
	else
		STATUS=1
		print "MMC test fails \n\n"
	fi
}

# devnode test
# check_devnode "/dev/block/mmcblk0p6"

if [ "$STATUS" = 0 ]; then
	run_mmc_case
fi

print_status
exit $STATUS
