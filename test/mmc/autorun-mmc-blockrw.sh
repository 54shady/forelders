#!/system/bin/sh

source /test-utils.sh

#
# Exit status is 0 for PASS, nonzero for FAIL
#
STATUS=0

run_mmc_case()
{
	dd if=/dev/zero of=/dev/block/mmcblk0p6 bs=1024 count=5 2>test

	if [ "$?" = 0 ]; then
		cat test | grep '^5+0 records in'
		if [ "$?" = 0 ]; then
			cat test | grep '^5+0 records out'
			if [ "$?" = 0 ]; then
				print "MMC test passes \n\n"
				rm -rf test 2>&1 1>/dev/null
				return
			fi
		fi
	fi

	STATUS=1
	print "MMC test fails \n\n"
}

# devnode test
# check_devnode "/dev/block/mmcblk0p6"

if [ "$STATUS" = 0 ]; then
	run_mmc_case
fi

print_status
exit $STATUS
