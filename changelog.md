# Changelogs

## 2.6 (2024-12-18)
- Disable Qualcomm CNE and Qualcomm Location apps to save resources.
- Reduced CPU and memory usage to boost performance, especially for gaming.
- Optimization by disabling `msm_thermal` and various `logs/debug` settings to improve performance.
- New system settings to disable `resource-draining` features like `vibrate`, `auto-sync`, and `wifi-scanning`.

## 2.5 (2024-12-11)
- Moved all `debug.*` properties from `system.prop` to `service.sh` to fix bootloop issues on some devices. Debug properties are now applied via service.sh during boot.
- Added thermal tweak script to mitigate throttling, including :
  - `Disabling thermal services and overriding thermal statuses using resetprop.`
  - `Stopping thermal-related processes and preventing throttling by modifying throttling files in /sys/.`

## 2.4 (2024-12-10)
- Added new Snapdragon Tweaks.
- Improve CPU Boost and Reduce Debugging Overhead.
- Dropped MediaTek support due to limited user feedback and the need to focus development efforts on Snapdragon for better optimization and efficiency.

## 2.3.1 (2024-12-09)
- HOTFIX :
  - `Fix UI Installer.`
  - `Fix Dynamic Description.`
  - `Revert system.prop to the default state.`

## 2.3 (2024-12-09)
- MediaTek Support : Bumbu Racik module now supports MediaTek chipsets in addition to Snapdragon, enhancing compatibility and performance.
- Added specific optimizations and performance tweaks for MediaTek Chipset.

## 2.2 (2024-12-08)
- Added new Performance Tweaks.
- Added a new, more interactive UI installer for better user experience.
- Dropped unnecessary dex-opt commands :
  - `cmd package force-dex-opt com.android.systemui`
  - `cmd package bg-dexopt-job`
- Improved installation speed by reducing redundant operations.
- General performance optimizations and bug fixes.

## 2.1 (2024-12-07)
- Initial release GitHub.
- Added update button support.
