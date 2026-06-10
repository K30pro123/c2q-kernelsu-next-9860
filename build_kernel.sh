#!/bin/bash

# 复制港版 defconfig

cp -f kernelsu-defconfig/c2q_chn_hk_defconfig arch/arm64/configs/vendor/c2q_chn_hk_defconfig



# 复制补丁

cp -rf kernelsu-patches/. .



# 添加 KernelSU Next

curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/next/kernel/setup.sh" | bash -s legacy



# 编译配置

export ARCH=arm64

mkdir out

BUILD_CROSS_COMPILE=$(pwd)/toolchain/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-

KERNEL_LLVM_BIN=$(pwd)/toolchain/llvm-arm-toolchain-ship/10.0/bin/clang

CLANG_TRIPLE=aarch64-linux-gnu-

KERNEL_MAKE_ENV="DTC_EXT=$(pwd)/tools/dtc CONFIG_BUILD_ARM64_DT_OVERLAY=y"



# 执行编译

make -j$(nproc) -C $(pwd) O=$(pwd)/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE vendor/c2q_chn_hk_defconfig

make -j$(nproc) -C $(pwd) O=$(pwd)/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE



# 打包 AnyKernel3

cp out/arch/arm64/boot/Image $(pwd)/anykernel

cd anykernel && 7z a -tzip ../c2q_n9860_ksunext.zip . && cd ..



if [ -f "c2q_n9860_ksunext.zip" ]; then

    echo "编译成功！文件位于: $(pwd)/c2q_n9860_ksunext.zip"
    
else

    echo "错误：未找到生成的 Zip 文件！"
    
    exit 1
    
fi




