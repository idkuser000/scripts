#!/bin/bash

rm -rf .repo/local_manifests
rm -rf prebuilts/gcc

# repo init
repo init -u https://github.com/LineageOS/android.git -b lineage-24.0 --git-lfs --depth=1

# cloning local_manifests
git clone https://github.com/me-cafebabe-aosp-mainline/local_manifests --depth=1 -b lineage-24.0 .repo/local_manifests

# sync the rom
/opt/crave/resync.sh

# setting up the build environment
source build/envsetup.sh
export BUILD_USERNAME="cgik"
export BUILD_HOSTNAME="crave"
export TZ="Asia/Ho_Chi_Minh"

# cloning device tree & dependencies inside lineageos org
rm -rf device/mainline/generic ; git clone https://github.com/idkuser000/android_device_mainline_generic --depth=1 -b lineage-24.0 device/mainline/generic
lineage/scripts/repopick/repopick.py 492595
vendor/lineage/build/tools/roomservice.py generic true device/mainline/Generic_x86_64

# cloning dependencies outside lineageos org
git clone https://salsa.debian.org/kernel-team/linux --depth=1 -b debian/latest external/debian-linux
git clone https://android.googlesource.com/kernel/common --depth=1 -b android-mainline kernel/mainline/android-mainline

# mesa patches
curl https://raw.githubusercontent.com/idkuser000/scripts/refs/heads/main/scripts/mesa_patches.sh | bash

# other patches
curl https://raw.githubusercontent.com/idkuser000/scripts/refs/heads/main/scripts/other_patches.sh | bash

# patches that can be picked up using repopick
lineage/scripts/repopick/repopick.py 496520
lineage/scripts/repopick/repopick.py 442536
lineage/scripts/repopick/repopick.py 471111
lineage/scripts/repopick/repopick.py 471112
lineage/scripts/repopick/repopick.py 471113

# build
breakfast Generic_x86_64
m liveisoimage

# Upload files to gofile
echo "Upload to gofile will be started..."
if [ -f out/target/product/Generic_x86_64/*.iso ]; then
    wget https://raw.githubusercontent.com/lordgaruda/GoFile-Upload/refs/heads/master/upload.sh
    chmod +x upload.sh ; ./upload.sh out/target/product/earth/*.iso
    echo "Upload done!"
else
    echo "No zip found in out/ dir!" 
    exit 1
fi
