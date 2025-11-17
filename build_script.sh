#!/usr/bin/env bash

# Source Directory
KERNEL_SRC_DIR="${HOME}/rpi-linux-5.15"

# Which branch to use 
RPI_KERNEL_BRANCH="rpi-5.15.y"

# Cross compiler prefix
CROSS_COMPILE_PREFIX="arm-linux-gnueabihf-"

# Number of parallel build jobs
JOBS="$(nproc)"

echo "=== Raspberry Pi 2 Kernel Build ==="

# Install dependencies (optional)

sudo apt update
sudo apt install -y \
        git bc bison flex libssl-dev make libc6-dev \
        libncurses5-dev crossbuild-essential-armhf

# Check out kernel source

echo "Cloning Raspberry Pi Linux kernel..."
git clone --depth=1 -b "${RPI_KERNEL_BRANCH}" \
        https://github.com/raspberrypi/linux.git "${KERNEL_SRC_DIR}"

cd "${KERNEL_SRC_DIR}"


# Set environment variables

export ARCH=arm
export CROSS_COMPILE="${CROSS_COMPILE_PREFIX}"

echo
echo "Using ARCH=${ARCH}, CROSS_COMPILE=${CROSS_COMPILE}"


# Configure for Raspberry Pi

echo
echo "Running bcm2709_defconfig (Raspberry Pi 2 default config)..."
make bcm2709_defconfig



# Build kernel, modules, dtbs

echo
echo "Building kernel, modules, and DTBs..."
make -j"${JOBS}" zImage modules dtbs

echo
echo "Build complete."
echo "Kernel image:        arch/arm/boot/zImage"
echo "Device trees (DTBs): arch/arm/boot/dts/*.dtb"
echo

echo "=== Done! ==="

