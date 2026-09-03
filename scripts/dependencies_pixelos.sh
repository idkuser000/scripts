#!/bin/bash

git clone https://github.com/LineageOS/android_prebuilts_bootmgr --depth 1 -b lineage-24.0 prebuilts/bootmgr
git clone https://github.com/LineageOS/android_external_drm_hwcomposer-upstream --depth 1 -b lineage-24.0 external/drm_hwcomposer-upstream
git clone https://github.com/LineageOS/android_external_libdisplay-info-upstream --depth 1 -b lineage-24.0 external/libdisplay-info-upstream
git clone https://github.com/LineageOS/android_external_minigbm-upstream --depth 1 -b lineage-24.0 extenal/minigbm-upstream
git clone https://github.com/LineageOS/android_external_linux-firmware-mainline --depth 1 -b lineage-24.0 external/linux-firmware-mainline
git clone https://github.com/LineageOS/android_hardware_mainline_common --depth 1 -b lineage-24.0 hardware/mainline/common
git clone https://github.com/LineageOS/android_hardware_mainline_qcom --depth 1 -b lineage-24.0 hardware/mainline/qcom
git clone https://github.com/LineageOS/android_kernel_mainline_configs --depth 1 -b lineage-24.0 kernel/mainline/configs
git clone https://github.com/LineageOS/android_device_mainline_common --depth 1 -b lineage-24.0 device/mainline/common
git clone https://github.com/LineageOS/android_external_mesa --depth 1 -b lineage-23.2 external/mesa
git clone https://github.com/LineageOS/android_prebuilts_mesa-build-dep --depth 1 -b lineage-23.2 prebuilts/mesa-build-dep
git clone https://github.com/LineageOS/android_device_mainline_generic --depth 1 -b lineage-24.0 device/mainline/generic
git clone https://github.com/LineageOS/android_external_tinyhal --depth 1 -b lineage-24.0 external/tinyhal
git clone https://github.com/LineageOS/android_vendor_mainline --depth 1 -b lineage-24.0 vendor/mainline
