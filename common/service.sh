#!/system/bin/sh

ROOT_METHOD="Unknown"
ROOT_VERSION="Unknown"

if [ -d "/data/adb/ksu" ]; then
    ROOT_METHOD="KernelSU"
    if command -v su &>/dev/null; then
        ROOT_VERSION=$(su --version 2>/dev/null | cut -d ':' -f 1)
    fi
elif [ -d "/data/adb/magisk" ]; then
    ROOT_METHOD="Magisk"
    if command -v magisk &>/dev/null; then
        ROOT_VERSION=$(magisk -V)
    fi
elif [ -d "/data/adb/ap" ]; then
    ROOT_METHOD="APatch"
    if [ -f "/data/adb/ap/version" ]; then
        ROOT_VERSION=$(cat /data/adb/ap/version)
    fi
fi

MODDIR="/data/adb/modules/bumbu_racik"
MODULE_PROP="${MODDIR}/module.prop"
BACKUP_PROP="${MODULE_PROP}.orig"

if [ -f "$MODULE_PROP" ] && [ ! -f "$BACKUP_PROP" ]; then
    cp "$MODULE_PROP" "$BACKUP_PROP"
fi

if [ -f "$MODULE_PROP" ]; then
    sed -i "s/^description=.*/description=[ 😋 Bumbu Racik is working | ✅ ${ROOT_METHOD} (${ROOT_VERSION}) ] a secret recipe to boost your android performance !/" "$MODULE_PROP"
fi

while [ -z "$(resetprop sys.boot_completed)" ]; do
    sleep 5
done

if [ -e /sys/class/kgsl/kgsl-3d0/devfreq/governor ]; then
  echo "msm-adreno-tz" > /sys/class/kgsl/kgsl-3d0/devfreq/governor
fi

find /sys/devices/system/cpu -maxdepth 1 -name 'cpu?' | while IFS= read -r cpu; do
  echo performance > "$cpu/cpufreq/scaling_governor"
done

echo 0 > /sys/class/kgsl/kgsl-3d0/throttling
echo 0 > /sys/class/kgsl/kgsl-3d0/bus_split
echo 1 > /sys/class/kgsl/kgsl-3d0/force_no_nap
echo 1 > /sys/class/kgsl/kgsl-3d0/force_rail_on
echo 1 > /sys/class/kgsl/kgsl-3d0/force_bus_on
echo 1 > /sys/class/kgsl/kgsl-3d0/force_clk_on

echo '1' /sys/kernel/fast_charge/force_fast_charge
echo '1' /sys/class/power_supply/battery/system_temp_level
echo '1' /sys/kernel/fast_charge/failsafe
echo '1' /sys/class/power_supply/battery/allow_hvdcp3
echo '1' /sys/class/power_supply/usb/pd_allowed
echo '1' /sys/class/power_supply/battery/subsystem/usb/pd_allowed
echo '0' /sys/class/power_supply/battery/input_current_limited
echo '1' /sys/class/power_supply/battery/input_current_settled
echo '0' /sys/class/qcom-battery/restricted_charging
echo '150' /sys/class/power_supply/bms/temp_cool
echo '480' /sys/class/power_supply/bms/temp_hot
echo '480' /sys/class/power_supply/bms/temp_warm

chmod 755 /sys/class/power_supply/battery/constant_charge_current_max
echo 4000000 > /sys/class/power_supply/battery/constant_charge_current_max
chmod 755 /sys/class/power_supply/battery/input_current_max
echo 4000000 > /sys/class/power_supply/battery/input_current_max
chmod 444 /sys/class/power_supply/battery/constant_charge_current_max
chmod 444 /sys/class/power_supply/battery/input_current_max

chmod 755 /sys/module/qti_haptics/parameters/vmax_mv_override
echo 500 > /sys/module/qti_haptics/parameters/vmax_mv_override
chmod 444 /sys/module/qti_haptics/parameters/vmax_mv_override

echo 0 > /d/tracing/tracing_on
echo 0 > /sys/kernel/debug/rpm_log
echo 0 > /sys/module/rmnet_data/parameters/rmnet_data_log_level
echo 500 > /sys/module/qti_haptics/parameters/vmax_mv_override

echo "1" > /sys/module/spurious/parameters/noirqdebug
echo "0" > /sys/kernel/debug/sde_rotator0/evtlog/enable
echo "0" > /sys/kernel/debug/dri/0/debug/enable
echo "0" > /proc/sys/debug/exception-trace
echo "0" > /proc/sys/kernel/sched_schedstats

echo "0 0 0 0" > "/proc/sys/kernel/printk"
echo "0" > "/sys/kernel/printk_mode/printk_mode"
echo "0" > "/sys/module/printk/parameters/cpu"
echo "0" > "/sys/module/printk/parameters/pid"
echo "0" > "/sys/module/printk/parameters/printk_ratelimit"
echo "0" > "/sys/module/printk/parameters/time"
echo "1" > "/sys/module/printk/parameters/console_suspend"
echo "1" > "/sys/module/printk/parameters/ignore_loglevel"
echo "off" > "/proc/sys/kernel/printk_devkmsg"

echo "0:1800000" > /sys/devices/system/cpu/cpu_boost/parameters/input_boost_freq
echo "230" > /sys/devices/system/cpu/cpu_boost/parameters/input_boost_ms

echo "3" > /proc/sys/vm/drop_caches
echo "1" > /proc/sys/vm/compact_memory

echo "com.roblox., com.garena., com.activision., UnityMain, libunity.so, libil2cpp.so, libfb.so" > /proc/sys/kernel/sched_lib_name
echo "240" > /proc/sys/kernel/sched_lib_mask_force

su -c "stop mi_thermald thermal-engine vendor.thermal-engine traced tombstoned tcpdump cnss_diag statsd vendor.perfservice logcat logcatd logd idd-logreader idd-logreadermain stats dumpstate vendor.tcpdump vendor_tcpdump vendor.cnss_diag"

am kill logd
killall -9 logd

am kill logd.rc
killall -9 logd.rc

rm -rf /data/anr/*
rm -rf /dev/log/*
rm -rf /data/tombstones/*
rm -rf /data/log_other_mode/*
rm -rf /data/system/dropbox/*
rm -rf /data/system/usagestats/*
rm -rf /data/log/*
rm -rf /sys/kernel/debug/*
rm -rf /storage/emulated/0/*.log;

for i in "debug_mask" "log_level*" "debug_level*" "*debug_mode" "enable_ramdumps" "edac_mc_log*" "enable_event_log" "*log_level*" "*log_ue*" "*log_ce*" "log_ecn_error" "snapshot_crashdumper" "seclog*" "compat-log" "*log_enabled" "tracing_on" "mballoc_debug"; do
    find /sys/ -type f -name "$i" | while IFS= read -r log_file; do
        if [ -w "$log_file" ]; then
            echo "0" > "$log_file"
        fi
    done
done

for thermal_zone in /sys/class/thermal/thermal_zone*; do
    if [ -w "$thermal_zone/mode" ]; then
        echo 'disabled' > "$thermal_zone/mode"
    fi
done

for thermal_zone in /sys/class/thermal/thermal_zone*; do
    if [ -w "$thermal_zone/temp" ]; then
        chmod 000 "$thermal_zone/temp"
    fi
done

find /sys -name mode | grep 'thermal_zone' | while IFS= read -r thermal_zone_status; do
    if [ -r "$thermal_zone_status" ]; then
        thermal_mode=$(cat "$thermal_zone_status")
        if [ "$thermal_mode" = 'enabled' ]; then
            echo 'disabled' > "$thermal_zone_status"
        fi
    fi
done

find /sys/devices/virtual/thermal -type f -exec chmod 000 {} +

if service list | grep -qi thermal; then
    for svc in $(service list | grep -i thermal | awk -F ' ' '{print $4}'); do
        start $svc
        stop $svc
        cmd thermalservice override-status 0 || true
    done
fi

if pgrep -i thermal > /dev/null; then
    for pid in $(pgrep -i thermal); do
        kill -SIGSTOP $pid || true
    done
fi

if command -v resetprop > /dev/null; then
    resetprop -v | grep -i 'thermal.*running' | awk -F '[][]' '{print $2}' | while read -r prop; do
        resetprop $prop freezed || true
    done
fi

find /sys/ -type f -name "*throttling*" | while IFS= read -r throttling; do
    if [ -w "$throttling" ]; then
        echo 0 > "$throttling"
    fi
done

find /sys/ -name enabled | grep 'msm_thermal' | while IFS= read -r msm_thermal_status; do
    if [ -r "$msm_thermal_status" ]; then
        msm_thermal_value=$(cat "$msm_thermal_status")
        if [ "$msm_thermal_value" = 'Y' ]; then
            echo 'N' > "$msm_thermal_status"
        elif [ "$msm_thermal_value" = '1' ]; then
            echo '0' > "$msm_thermal_status"
        fi
    fi
done

if resetprop dalvik.vm.dexopt.thermal-cutoff | grep -q '2'; then
    resetprop -n dalvik.vm.dexopt.thermal-cutoff 0
  fi
  if resetprop sys.thermal.enable | grep -q 'true'; then
    resetprop -n sys.thermal.enable false
  fi
  if resetprop ro.thermal_warmreset | grep -q 'true'; then
    resetprop -n ro.thermal_warmreset false
  fi

  rm -f /data/vendor/thermal/config
  rm -f /data/vendor/thermal/thermal.dump
  rm -f /data/vendor/thermal/last_thermal.dump
  rm -f /data/vendor/thermal/thermal_history.dump
    for therm_serv in $thermal_prop; do
        stop $therm_serv
    done

echo "0" > /sys/kernel/rcu_expedited 0
echo "0" > /sys/kernel/rcu_normal 0
echo "0" > /sys/devices/system/cpu/isolated 0
echo "0" > /proc/sys/kernel/sched_tunable_scaling 0
echo "1" > /proc/sys/kernel/timer_migration 1
echo "0" > /proc/sys/kernel/hung_task_timeout_secs 0
echo "25" > /proc/sys/kernel/perf_cpu_time_max_percent 25
echo "1" > /proc/sys/kernel/sched_autogroup_enabled 1
echo "0" > /proc/sys/kernel/sched_child_runs_first 0
echo "10000000" > /proc/sys/kernel/sched_latency_ns 
echo "2000000" > /proc/sys/kernel/sched_wakeup_granularity_ns 
echo "3200000" > /proc/sys/kernel/sched_min_granularity_ns 
echo "2000000" > /proc/sys/kernel/sched_migration_cost_ns 
echo "32" > /proc/sys/kernel/sched_nr_migrate

echo '1' > /sys/power/pnpmgr/touch_boost
echo '1' > /sys/module/msm_performance/parameters/touchboost

back=/dev/cpuset/background/cpus
echo "0-1" > $back

system=/dev/cpuset/system-background/cpus
echo "0-2" > $system

for=/dev/cpuset/foreground/cpus
echo "0-7" > $for

top=/dev/cpuset/top-app/cpus
echo "0-7" > $top

fore=/dev/stune/foreground/schedtune.boost
echo "5" > $fore

topp=/dev/stune/top-app/schedtune.boost
echo "5" > $topp

back=/dev/stune/background/schedtune.boost
echo "5" > $back

dow=/proc/sys/kernel/sched_downmigrate
echo "40 40" > $dow

sch=/proc/sys/kernel/sched_upmigrate
echo "60 60" > $sch

boost=/proc/sys/kernel/sched_boost
echo "1" > $boost

if [ -e /sys/class/kgsl/kgsl-3d0/snapshot/snapshot_crashdumper ]; then
  echo "0" > /sys/class/kgsl/kgsl-3d0/snapshot/snapshot_crashdumper
fi
if [ -e /sys/class/kgsl/kgsl-3d0/snapshot/dump ]; then
  echo "0" > /sys/class/kgsl/kgsl-3d0/snapshot/dump
fi
if [ -e /sys/class/kgsl/kgsl-3d0/snapshot/force_panic ]; then
  echo "0" > /sys/class/kgsl/kgsl-3d0/snapshot/force_panic
fi

if [ -e /sys/module/adreno_idler/parameters/adreno_idler_active ]; then
  echo "1" > /sys/module/adreno_idler/parameters/adreno_idler_active
fi

for rx in /sys/module/lpm_levels/parameters/*; do
  if [ -e "$rx/lpm_ipi_prediction" ]; then
    echo "0" > "$rx/lpm_ipi_prediction"
  fi
  if [ -e "$rx/lpm_prediction" ]; then
    echo "0" > "$rx/lpm_prediction"
  fi
  if [ -e "$rx/sleep_disabled" ]; then
    echo "0" > "$rx/sleep_disabled"
  fi
done

for rcct in /sys/devices/system/cpu/*/core_ctl; do
  if [ -e "$rcct/enable" ]; then
    chmod 666 "$rcct/enable"
    echo "0" > "$rcct/enable"
    chmod 444 "$rcct/enable"
  fi
done

for gpu in /sys/class/kgsl/kgsl-3d0; do
  if [ -e "$gpu/adrenoboost" ]; then
    echo "0" > "$gpu/adrenoboost"
  fi
  if [ -e "$gpu/devfreq/adrenoboost" ]; then
    echo "0" > "$gpu/devfreq/adrenoboost"
  fi
  if [ -e "$gpu/throttling" ]; then
    echo "0" > "$gpu/throttling"
  fi
  if [ -e "$gpu/bus_split" ]; then
    echo "0" > "$gpu/bus_split"
  fi
  if [ -e "$gpu/force_clk_on" ]; then
    echo "1" > "$gpu/force_clk_on"
  fi
  if [ -e "$gpu/force_bus_on" ]; then
    echo "1" > "$gpu/force_bus_on"
  fi
  if [ -e "$gpu/force_rail_on" ]; then
    echo "1" > "$gpu/force_rail_on"
  fi
  if [ -e "$gpu/force_no_nap" ]; then
    echo "1" > "$gpu/force_no_nap"
  fi
  if [ -e "$gpu/idle_timer" ]; then
    echo "80" > "$gpu/idle_timer"
  fi
  if [ -e "$gpu/max_pwrlevel" ]; then
    echo "0" > "$gpu/max_pwrlevel"
  fi
done

echo 'deadline' > /sys/block/mmcblk0/queue/scheduler
echo 'deadline' > /sys/block/mmcblk1/queue/scheduler
echo '1024' > /sys/block/mmcblk0/queue/read_ahead_kb
echo '1024' > /sys/block/mmcblk1/queue/read_ahead_kb
echo "75" > /sys/devices/system/cpu/cpufreq/performance/up_threshold
echo "40000" > /sys/devices/system/cpu/cpufreq/performance/sampling_rate
echo "5" > /sys/devices/system/cpu/cpufreq/performance/sampling_down_factor
echo "20" > /sys/devices/system/cpu/cpufreq/performance/down_threshold
echo "25" > /sys/devices/system/cpu/cpufreq/performance/freq_step/sys/class/kgsl/kgsl-3d0/devfreq/governor
echo "deadline" > /sys/block/sda/queue/scheduler
echo "1024" > /sys/block/sda/queue/read_ahead_kb
echo "0" > /sys/block/sda/queue/rotational
echo "0" > /sys/block/sda/queue/iostats
echo "0" > /sys/block/sda/queue/add_random
echo "1" > /sys/block/sda/queue/rq_affinity
echo "0" > /sys/block/sda/queue/nomerges
echo "1024" > /sys/block/sda/queue/nr_requests
echo "deadline" > /sys/block/sdb/queue/scheduler
echo "1024" > /sys/block/sdb/queue/read_ahead_kb
echo "0" > /sys/block/sdb/queue/rotational
echo "0" > /sys/block/sdb/queue/iostats
echo "0" > /sys/block/sdb/queue/add_random
echo "1" > /sys/block/sdb/queue/rq_affinity
echo "0" > /sys/block/sdb/queue/nomerges
echo "1024" > /sys/block/sdb/queue/nr_requests
echo "deadline" > /sys/block/sdc/queue/scheduler
echo "1024" > /sys/block/sdc/queue/read_ahead_kb
echo "0" > /sys/block/sdc/queue/rotational
echo "0" > /sys/block/sdc/queue/iostats
echo "0" > /sys/block/sdc/queue/add_random
echo "1" > /sys/block/sdc/queue/rq_affinity
echo "0" > /sys/block/sdc/queue/nomerges
echo "1024" > /sys/block/sdc/queue/nr_requests
echo "deadline" > /sys/block/sdd/queue/scheduler
echo "1024" > /sys/block/sdd/queue/read_ahead_kb
echo "0" > /sys/block/sdd/queue/rotational
echo "0" > /sys/block/sdd/queue/iostats
echo "0" > /sys/block/sdd/queue/add_random
echo "1" > /sys/block/sdd/queue/rq_affinity
echo "0" > /sys/block/sdd/queue/nomerges
echo "1024" > /sys/block/sdd/queue/nr_requests
echo "deadline" > /sys/block/sde/queue/scheduler
echo "1024" > /sys/block/sde/queue/read_ahead_kb
echo "0" > /sys/block/sde/queue/rotational
echo "0" > /sys/block/sde/queue/iostats
echo "0" > /sys/block/sde/queue/add_random
echo "1" > /sys/block/sde/queue/rq_affinity
echo "0" > /sys/block/sde/queue/nomerges
echo "1024" > /sys/block/sde/queue/nr_requests
echo "deadline" > /sys/block/sdf/queue/scheduler
echo "1024" > /sys/block/sdf/queue/read_ahead_kb
echo "0" > /sys/block/sdf/queue/rotational
echo "0" > /sys/block/sdf/queue/iostats
echo "0" > /sys/block/sdf/queue/add_random
echo "1" > /sys/block/sdf/queue/rq_affinity
echo "0" > /sys/block/sdf/queue/nomerges
echo "1024" > /sys/block/sdf/queue/nr_requests
echo "deadline" > /sys/block/mmcblk0/queue/scheduler
echo "1024" > /sys/block/mmcblk0/queue/read_ahead_kb
echo "0" > /sys/block/mmcblk0/queue/rotational
echo "0" > /sys/block/mmcblk0/queue/iostats
echo "0" > /sys/block/mmcblk0/queue/add_random
echo "1" > /sys/block/mmcblk0/queue/rq_affinity
echo "0" > /sys/block/mmcblk0/queue/nomerges
echo "1024" > /sys/block/mmcblk0/queue/nr_requests

busybox=$(find /data/adb/ -type f -name busybox | head -n 1)
$busybox swapoff /dev/block/zram0
echo "1" > /sys/block/zram0/reset
echo "4294967296" > /sys/block/zram0/disksize
$busybox mkswap /dev/block/zram0
$busybox swapon /dev/block/zram0

fstrim -v /cache
fstrim -v /system
fstrim -v /vendor
fstrim -v /data
fstrim -v /preload
fstrim -v /product
fstrim -v /metadata
fstrim -v /odm
fstrim -v /data/dalvik-cache

sleep 15

setprop debug.sf.hw 1
setprop debug.egl.hw 1
setprop debug.sf.showfps 0
setprop debug.sf.showcpu 0
setprop debug.mdpcomp.logs 0
setprop debug.qc.hardware true
setprop debug.qctwa.statusbar 1
setprop debug.sf.showupdates 0
setprop debug.egl.disable_msaa 1
setprop debug.hwui.renderer skiagl
setprop debug.cpurend.vsync false
setprop debug.qctwa.preservebuf 1
setprop debug.sf.enable_hwc_vds 0
setprop debug.sf.latch_unsignaled 1
setprop debug.performance.tuning 1
setprop debug.sf.showbackground 0
setprop debug.composition.type gpu
setprop debug.egl.disable_msaa true
setprop debug.sf.disable_backpressure 1
setprop debug.gralloc.gfx_ubwc_disable 1
setprop debug.sf.enable_gl_backpressure 1
setprop debug.hwui.skia_atrace_enabled false
setprop debug.hwui.render_dirty_regions false
setprop debug.sf.early_phase_offset_ns 500000
setprop debug.sf.enable_transaction_tracing false
setprop debug.renderengine.backend skiaglthreaded
setprop debug.sf.early_gl_phase_offset_ns 3000000
setprop debug.sf.disable_client_composition_cache 0
setprop debug.sf.early_app_phase_offset_ns 500000
setprop debug.sf.early_gl_app_phase_offset_ns 15000000
setprop debug.sf.high_fps_early_phase_offset_ns 6100000
setprop debug.renderthread.skia.reduceopstasksplitting true
setprop debug.sf.high_fps_early_gl_phase_offset_ns 650000
setprop debug.sf.high_fps_late_app_phase_offset_ns 100000
setprop debug.sf.phase_offset_threshold_for_next_vsync_ns 6100000

sleep 10

su -lp 2000 -c "cmd notification post -S bigtext -t '🧂 Bumbu Racik' 'Tag' 'Bumbu Racik is now running on your device. Enjoy enhanced performance !'" > /dev/null 2>&1

exit 0
