#!/system/bin/sh

source /test-utils.sh

#
# Exit status is 0 for PASS, nonzero for FAIL
#
STATUS=0

run_mmc_case()
{
	# Generate Test data
	dd if=/dev/urandom of=/mmc_data bs=512 count=10240

	dd if=/mmc_data of=/dev/block/mmcblk0p6 bs=512 count=10240
	dd if=/dev/block/mmcblk0p6 of=/mmc_data1 bs=512 count=10240

	cmp /mmc_data1 /mmc_data

	if [ "$?" = 0 ]; then
		print "MMC test passes \n\n"
		rm /mmc_data
		rm /mmc_data1
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
