#!/bin/bash

# Scripts for building LineageOS 24 for Generic_x86_64

rm -rf .repo/local_manifests
rm -rf prebuilts/gcc

# init & syncing
repo init -u https://github.com/LineageOS/android.git -b lineage-24.0 --git-lfs --depth=1
git clone https://github.com/me-cafebabe-aosp-mainline/local_manifests --depth=1 -b lineage-24.0 .repo/local_manifests
/opt/crave/resync.sh

# setting up the build environment
source build/envsetup.sh
export BUILD_USERNAME="cgik"
export BUILD_HOSTNAME="crave"
export TZ="Asia/Ho_Chi_Minh"

# clone dependencies
rm -rf device/mainline/generic ; git clone https://github.com/idkuser000/android_device_mainline_generic --depth=1 -b lineage-24.0 device/mainline/generic
lineage/scripts/repopick/repopick.py 492595 -f
vendor/lineage/build/tools/roomservice.py generic true device/mainline/Generic_x86_64

git clone https://salsa.debian.org/kernel-team/linux --depth=1 -b debian/latest external/debian-linux
git clone https://android.googlesource.com/kernel/common --depth=1 -b android-mainline kernel/mainline/android-mainline

# patches
curl https://raw.githubusercontent.com/idkuser000/scripts/refs/heads/main/scripts/mesa_patches.sh | bash

curl https://raw.githubusercontent.com/idkuser000/scripts/refs/heads/main/scripts/other_patches.sh | bash

lineage/scripts/repopick/repopick.py 496520 -f
lineage/scripts/repopick/repopick.py 442536 -f
lineage/scripts/repopick/repopick.py 471111 -f
lineage/scripts/repopick/repopick.py 471112 -f
lineage/scripts/repopick/repopick.py 471113 -f
lineage/scripts/repopick/repopick.py 501163 -f

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
