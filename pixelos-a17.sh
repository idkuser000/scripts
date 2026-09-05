#!/bin/bash

# Scripts for building PixelOS 17 for Generic_x86_64

rm -rf .repo/local_manifests
rm -rf prebuilts/gcc
rm -rf frameworks/base
rm -rf system/memory/libmeminfo
rm -rf external/debian-linux
rm -rf kernel/mainline/android-mainline
rm -rf device/mainline/generic

# init & syncing
repo init -u https://github.com/PixelOS-AOSP/android_manifest -b seventeen --git-lfs --depth=1
/opt/crave/resync.sh

# clone dependencies
curl https://raw.githubusercontent.com/idkuser000/scripts/refs/heads/main/scripts/dependencies_pixelos.sh | bash

git clone https://salsa.debian.org/kernel-team/linux --depth=1 -b debian/latest external/debian-linux
git clone https://android.googlesource.com/kernel/common --depth=1 -b android-mainline kernel/mainline/android-mainline

# setting up the build environment
source build/envsetup.sh
export BUILD_USERNAME="cgik"
export BUILD_HOSTNAME="crave"
export TZ="Asia/Ho_Chi_Minh"

# patches
curl https://raw.githubusercontent.com/idkuser000/scripts/refs/heads/main/scripts/mesa_patches.sh | bash

curl https://raw.githubusercontent.com/idkuser000/scripts/refs/heads/main/scripts/other_patches.sh | bash

custom/scripts/repopick/repopick.py 496520 -f
custom/scripts/repopick/repopick.py 442536 -f
custom/scripts/repopick/repopick.py 471111 -f
custom/scripts/repopick/repopick.py 471112 -f
custom/scripts/repopick/repopick.py 471113 -f
custom/scripts/repopick/repopick.py 501163 -f

rm -rf external/mainline-hw-deps

# build
breakfast Generic_x86_64
m liveisoimage

# Upload files to gofile
echo "Upload to gofile will be started..."
if [ -f out/target/product/Generic_x86_64/*.iso ]; then
    wget https://raw.githubusercontent.com/lordgaruda/GoFile-Upload/refs/heads/master/upload.sh
    chmod +x upload.sh ; ./upload.sh out/target/product/Generic_x86_64/*.iso
    echo "Upload done!"
else
    echo "No zip found in out/ dir!" 
    exit 1
fi
