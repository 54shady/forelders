```shell
1. 使用standalone编译器编译busybox
NDK用的是下面这个：
wget http://dl.google.com/android/ndk/android-ndk-r8b-linux-x86.tar.bz2

tar jxvf android-ndk-r8b-linux-x86.tar.bz2
cd android-ndk-r8b-linux-x86
build/tools/make-standalone-toolchain.sh --platform=android-4 --install-dir=/home/zerowaytp/my_android_toolchain

tar jxvf busybox-1.22.1.tar.bz2
cd busybox-1.22.1

修改android2_defconfig里交叉编译工具和sysroot参考dot_config文件
make android2_defconfig 使用这个来生成.config文件
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
```
