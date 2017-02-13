# forelders
my happy day at forelders

Audio-Amplifier.pdf 讲解功放不错的文档

## 使用standalone编译器编译busybox

[NDK用的是http://dl.google.com/android/ndk/android-ndk-r8b-linux-x86.tar.bz2](http://dl.google.com/android/ndk/android-ndk-r8b-linux-x86.tar.bz2)

```shell
tar jxvf android-ndk-r8b-linux-x86.tar.bz2
cd android-ndk-r8b-linux-x86
build/tools/make-standalone-toolchain.sh --platform=android-4 --install-dir=/home/zerowaytp/my_android_toolchain
tar jxvf busybox-1.22.1.tar.bz2
cd busybox-1.22.1
```

修改android2_defconfig里交叉编译工具和sysroot

使用这个来生成.config文件

make android2_defconfig

或者使用android_51_busybox1221_dot_config

	cp android_51_busybox1221_dot_config .config
	make
	adb push busybox /system/bin/

## mmc测试

参考提供的测试脚本test/mmc/*.sh

## ddr测试

参考提供的测试代码test/ddr

代码下载

[下载地址http://pyropus.ca/software/memtester/](http://pyropus.ca/software/memtester/)

将代码解压到android external目录下

	tar xzvf memtester-4.3.0.tar.gz -C external/

添加Android.mk,内容如下

```shell
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_SHARED_LIBRARIES := \
	liblog \
	libcutils \
	libutils
LOCAL_MODULE:=memtester
LOCAL_MODULE_TAGS:=optional
LOCAL_SRC_FILES:= \
	memtester.c \
	tests.c

LOCAL_C_INCLUDES := $(LOCAL_PATH)/

include $(BUILD_EXECUTABLE)
include $(call all-makefiles-under,$(LOCAL_PATH))
```

编译

	mmm external/memtester-4.3.0/
	adb push out/target/product/rk312x/system/bin/memtester /system/bin/

测试

	memtester 1m 10

## iozone for android

官网下载iozone源码 [地址](http://www.iozone.org/)

	tar xvf iozone3_457.tar
	cd iozone3_457/src/current

修改makefile

其中交叉编译工具使用的使用gentoo上crossdev安装的armv7a-hardfloat-linux-gnueabihf-gcc

编译

	make linux-arm

测试

	adb push iozone /system/bin/

对读写进行性能测试

	iozone -a -i 1 -i 0

测试并输出结果保存在r.xls文件中

	iozone -Rab r.xls

## iperf测试wifi网卡性能

解压iperf-project.zip,拷贝iperf到android目录下的external里

其中ipef-project.zip

[源码下载](http://www.cs.technion.ac.il/~sakogan/DSL/2011/projects/iperf/index.html)

## 编译给android使用的iperf

编译

	mmm external/iperf/project/jni
	adb push out/target/product/rk312x/system/xbin/iperf /system/xbin/

在gentoo上安装一个和安装在android上版本接近的iperf

在USE里添下面的USE使iperf支持多线程(/etc/portage/package.use/use)

	=net-misc/iperf-2.0.5-r2 threads

gentoo默认安装高版本的iperf,需要手动mask掉(/etc/portage/package.mask/mask)

	>=net-misc/iperf-3.0.11

测试(这里的测试平台是RK3128 android 5.1)

android:192.168.0.102

PC:192.168.0.171

下行测试:

	PC$ iperf -c 192.168.0.102 -i 1 -t 60
	android$ iperf -s

上行测试:

	android$ iperf -c 192.168.0.102 -i 1 -t 60
	PC$ iperf -s

## mmc_utils 使用

源码在external/mmc-utils/

	mmc_utils status get /dev/block/mmcblk0
	mmc_utils writeprotect get /dev/block/mmcblk0
	mmc_utils extcsd read /dev/block/mmcblk0

## i2c-tool(作用不是很大)

[参考](http://my.oschina.net/luoly/blog/368881)

代码下载

	sudo emerge -f sys-apps/i2c-tools

解压添加makefile,解压代码到external下

	tar jxvf /usr/portage/distfiles/i2c-tools-3.0.2.tar.bz2 -C external/

添加Android.mk

编译

	mmm external/i2c-tools-3.0.2/

使用

列举 I2C bus

	i2cdetect -l

列举 I2C bus i2c-0 上面连接的所有设备

	i2cdetect -y 0

发现I2C设备的位置显示为UU或者表示设备地址的数值,UU表示该设备在 driver 中被使用
