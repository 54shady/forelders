```shell
1. 使用standalone编译器编译busybox
NDK用的是下面这个：
wget http://dl.google.com/android/ndk/android-ndk-r8b-linux-x86.tar.bz2

tar jxvf android-ndk-r8b-linux-x86.tar.bz2
cd android-ndk-r8b-linux-x86
build/tools/make-standalone-toolchain.sh --platform=android-4 --install-dir=/home/zerowaytp/my_android_toolchain

tar jxvf busybox-1.22.1.tar.bz2
cd busybox-1.22.1

修改android2_defconfig里交叉编译工具和sysroot
make android2_defconfig 使用这个来生成.config文件

或者使用android_51_busybox1221_dot_config
cp android_51_busybox1221_dot_config .config

make

adb push busybox /system/bin/

2. mmc测试
参考提供的测试脚本test/mmc/*.sh

3. ddr测试
参考提供的测试代码test/ddr
3.1 代码下载：
http://pyropus.ca/software/memtester/

3.2 将代码解压到android external目录下
tar xzvf memtester-4.3.0.tar.gz -C external/

3.3 添加Android.mk,内容如下

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

3.4 编译
mmm external/memtester-4.3.0/
adb push out/target/product/rk312x/system/bin/memtester /system/bin/

3.5 测试
memtester 1m 10

4. iozone for android
4.1 官网下载iozone源码
http://www.iozone.org/
tar xvf iozone3_457.tar
cd iozone3_457/src/current
修改makefile
其中交叉编译工具使用的使用gentoo上crossdev安装的armv7a-hardfloat-linux-gnueabihf-gcc

4.2 编译
make linux-arm

4.3 测试
adb push iozone /system/bin/

对读写进行性能测试
iozone -a -i 1 -i 0

测试并输出结果保存在r.xls文件中
iozone -Rab r.xls

5. iperf测试wifi网卡性能
解压iperf-project.zip,拷贝iperf到android目录下的external里
其中ipef-project.zip源码是从http://www.cs.technion.ac.il/~sakogan/DSL/2011/projects/iperf/index.html下载的

5.1 编译给android使用的iperf:
mmm external/iperf/project/jni
adb push out/target/product/rk312x/system/xbin/iperf /system/xbin/

5.2 在gentoo上安装一个和安装在android上版本接近的iperf

在USE里添下面的USE使iperf支持多线程(/etc/portage/package.use/use)
=net-misc/iperf-2.0.5-r2 threads

gentoo默认安装高版本的iperf,需要手动mask掉(/etc/portage/package.mask/mask)
>=net-misc/iperf-3.0.11

5.3 测试(这里的测试平台是RK3128 android 5.1)
android:192.168.0.102
PC:192.168.0.171

下行测试:
PC$ iperf -c 192.168.0.102 -i 1 -t 60
android$ iperf -s

上行测试:
android$ iperf -c 192.168.0.102 -i 1 -t 60
PC$ iperf -s

6 mmc_utils 使用
源码在external/mmc-utils/

mmc_utils status get /dev/block/mmcblk0
mmc_utils writeprotect get /dev/block/mmcblk0
mmc_utils extcsd read /dev/block/mmcblk0
```
