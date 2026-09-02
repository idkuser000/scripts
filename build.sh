#!/bin/bash

# stuff
rm -rf .repo/local_manifests
rm -rf prebuilts/gcc
export BUILD_USERNAME="cgik"
export BUILD_HOSTNAME="crave"
export TZ="Asia/Ho_Chi_Minh"

# repo init
repo init -u https://github.com/LineageOS/android.git -b lineage-24.0 --git-lfs --depth 1

# cloning local_manifests
git clone https://github.com/me-cafebabe-aosp-mainline/local_manifests --depth 1 -b lineage-24.0 .repo/local_manifests

# sync the rom
/opt/crave/resync.sh

# setting up the build environment
source build/envsetup.sh

# cloning device tree & dependencies inside lineageos org
curl https://raw.githubusercontent.com/idkuser000/scripts/refs/heads/main/lineage.dependencies -o device/mainline/Generic_x86_64/lineage.dependencies
lineage/scripts/repopick/repopick.py 492595
vendor/lineage/build/tools/roomservice.py generic true device/mainline/Generic_x86_64

# cloning dependencies outside lineageos org
git clone https://salsa.debian.org/kernel-team/linux -b debian/latest external/debian-linux
git clone https://android.googlesource.com/kernel/common -b android-mainline kernel/mainline/android-mainline

# mesa patches
curl https://raw.githubusercontent.com/idkuser000/scripts/refs/heads/main/mesa_patches.sh | bash

# other patches
curl https://raw.githubusercontent.com/idkuser000/scripts/refs/heads/main/other_patches.sh | bash

# patches that can be picked up using repopick
lineage/scripts/repopick/repopick.py 496520
lineage/scripts/repopick/repopick.py 442536
lineage/scripts/repopick/repopick.py 471111
lineage/scripts/repopick/repopick.py 471112
lineage/scripts/repopick/repopick.py 471113

# build
breakfast Generic_x86_64
m liveisoimage

# upload to pixeldrain
echo "Upload to pixeldrain will be started..."
curl https://raw.githubusercontent.com/idkuser000/scripts/refs/heads/main/pdup
chmod +x pdup ; ./pdup out/target/product/Generic_x86_64/*-live.iso
fi
