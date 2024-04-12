#!/bin/bash
# Compile script for Arisuu kernel
# Copyright (c) RapliVx Aka Rafi Aditya

# Setup
export KBUILD_BUILD_USER=Rapli # User Kernel Flag
export KBUILD_BUILD_HOST=Poco Nya Dead # Host Kernel Flag
DEVICE="Surya" # Your Device
WORK_DIR=$(pwd) # Your Dir
CLANG="WeebX" # Your =Name Clang Or Toolchain
SECONDS=0 # Bash Timer
ZIPNAME="Arisuu-Kernel-[Serika]-$(date '+%Y%m%d-%H%M').zip" # Zip Name Your Kernel
TC_DIR="$WORK_DIR/Android/$CLANG" # Toolchain Or Clang Dir
AK3_DIR="$WORK_DIR/Android/AK3" # Anykernel Dir
DEFCONFIG="surya_defconfig" # Your Defconfig

# Header
cyan="\033[96m"
green="\033[92m"
red="\033[91m"
blue="\033[94m"
yellow="\033[93m"

echo -e "$cyan===========================\033[0m"
echo -e "$cyan= START COMPILING KERNEL  =\033[0m"
echo -e "$cyan===========================\033[0m"

echo -e "$blue...KSABAR...\033[0m"

echo -e -ne "$green== (10%)\r"
sleep 0.7
echo -e -ne "$green=====                     (33%)\r"
sleep 0.7
echo -e -ne "$green=============             (66%)\r"
sleep 0.7
echo -e -ne "$green=======================   (100%)\r"
echo -ne "\n"

echo -e -n "$yellow\033[104mPRESS ENTER TO CONTINUE\033[0m"
read P
echo  $P

# Build Script

function clean() {
    echo -e "\n"
    echo -e "$red << cleaning up >> \\033[0m"
    echo -e "\n"
    rm -rf out
    make mrproper
}

function build_kernel() {
export PATH="$TC_DIR/bin:$PATH"
make O=out ARCH=arm64 $DEFCONFIG
make -j$(nproc --all) O=out ARCH=arm64 CC=clang LD=ld.lld AR=llvm-ar AS=llvm-as NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_COMPAT=arm-linux-gnueabi- 2>&1 | tee log.txt

kernel="out/arch/arm64/boot/Image.gz"
dtb="out/arch/arm64/boot/dtb.img"
dtbo="out/arch/arm64/boot/dtbo.img"

if [ -f "$kernel" ] && [ -f "$dtb" ] && [ -f "$dtbo" ]; then
	echo -e "\nKernel compiled succesfully! Zipping up...\n"
	if [ -d "$AK3_DIR" ]; then
		cp -r $AK3_DIR AnyKernel3
	elif ! git clone -q https://github.com/RapliVx/AnyKernel3.git -b Surya; then
		echo -e "\nAnyKernel3 repo not found locally and couldn't clone from GitHub! Aborting..."
		exit 1
	fi
	cp $kernel $dtb $dtbo AnyKernel3
	rm -rf out/arch/arm64/boot
	cd AnyKernel3
	git checkout Arisuu &> /dev/null
	zip -r9 "../$ZIPNAME" * -x .git README.md *placeholder
	cd ..
	rm -rf AnyKernel3
fi

if [ -f $ZIPNAME ] ; then
    echo -e "$green===========================\033[0m"
    echo -e "$green=  SUCCESS COMPILE KERNEL \033[0m"
    echo -e "$green=  Device    : $DEVICE \033[0m"
    echo -e "$green=  Defconfig : $DEFCONFIG \033[0m"
    echo -e "$green=  Toolchain : $CLANG \033[0m"
    echo -e "$green=  Out       : $ZIPNAME \033[0m "
    echo -e "$green=  Completed in $((SECONDS / 60)) minute(s) and $((SECONDS % 60)) second(s) \033[0m "
    echo -e "$green=  Have A Brick Day Nihahahah \033[0m"
    echo -e "$green===========================\033[0m"
else
echo -e "$red! FIX YOUR KERNEL SOURCE BRUH !?\033[0m"
fi
}

# execute
clean
build_kernel
