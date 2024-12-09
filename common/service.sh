#!/system/bin/sh

ROOT_METHOD="Unknown"
if [ -d "/data/adb/ksu" ]; then
    ROOT_METHOD="KernelSU"
elif [ -d "/data/adb/magisk" ]; then
    ROOT_METHOD="Magisk"
elif [ -d "/data/adb/ap" ]; then
    ROOT_METHOD="APatch"
fi

MODDIR="/data/adb/modules/bumbu_racik"
MODULE_PROP="${MODDIR}/module.prop"
BACKUP_PROP="${MODULE_PROP}.orig"

if [ -f "$MODULE_PROP" ] && [ ! -f "$BACKUP_PROP" ]; then
    cp "$MODULE_PROP" "$BACKUP_PROP"
fi

if [ -f "$MODULE_PROP" ]; then
    sed -i "s/^description=.*/description=[ 😋 Bumbu Racik is working | ✅ ${ROOT_METHOD} Manager ] bumbu racik khas raja iblis/" "$MODULE_PROP"
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

for thermal_zone in /sys/class/thermal/thermal_zone*; do

echo '0' > "$thermal_zone"/mode

done

echo "com.roblox., com.garena., com.activision., UnityMain, libunity.so, libil2cpp.so, libfb.so" > /proc/sys/kernel/sched_lib_name
echo "240" > /proc/sys/kernel/sched_lib_mask_force

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

echo "0" > /sys/kernel/ccci/debug
echo "9 1" > /proc/ppm/policy_status
echo "3 0" > /proc/ppm/policy_status
echo "4 0" > /proc/ppm/policy_status
echo "2 0" > /proc/ppm/policy_status
echo "7 0" > /proc/ppm/policy_status
echo "0" > /sys/kernel/tracing/tracing_on
echo "1" > /proc/cpufreq/cpufreq_cci_mode
echo "off" > /proc/sys/kernel/printk_devkmsg
echo "80" > /proc/sys/vm/vfs_cache_pressure
echo "0" > /proc/sys/kernel/sched_schedstats
echo "0 0" > /proc/ppm/policy/ut_fix_freq_idx
echo "1" > /sys/devices/system/cpu/perf/enable
echo "1" > /dev/stune/top-app/schedtune.boost
echo "3" > /proc/cpufreq/cpufreq_power_mode
echo "-1 -1" > /proc/ppm/policy/ut_fix_core_num
echo "0" > /proc/sys/kernel/perf_event_paranoid
echo "1" > /proc/sys/kernel/sched_child_runs_first
echo "3 0 0" > /proc/gpufreq/gpufreq_limit_table
echo "950000" > /proc/gpufreq/gpufreq_opp_freq
echo "1" > /dev/stune/top-app/schedtune.prefer_idle
echo "3" > /proc/sys/kernel/perf_cpu_time_max_percent
echo "1" >  /proc/perfmgr/syslimiter/syslimiter_force_disable
echo "N" > /sys/module/workqueue/parameters/power_efficient
echo "0" > /sys/devices/platform/10012000.dvfsrc/helio-dvfsrc/dvfsrc_req_ddr_opp

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

echo '1' > /sys/module/msm_performance/parameters/touchboost
echo '1' > /sys/power/pnpmgr/touch_boost

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
echo "3221225472" > /sys/block/zram0/disksize
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

exit 0
