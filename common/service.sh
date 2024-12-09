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

chmod 644 /sys/devices/virtual/thermal/thermal_message/cpu_limits
affected_cpus=$(awk '{print $1}' "$path/affected_cpus")
cpu_maxfreq=$(cat "$path/cpuinfo_max_freq")
chmod 000 /sys/devices/virtual/thermal/thermal_message/cpu_limits

echo "cpu${affected_cpus} ${cpu_maxfreq}" > "$thermal_limits"

echo "N" > /sys/module/workqueue/parameters/power_efficient
echo "N" > /sys/module/workqueue/parameters/disable_numa

echo 1 > /proc/ppm/enabled
for i in {0..9}; do
    echo "$i 0" > "/proc/ppm/policy_status"
done
echo "7 1" > "/proc/ppm/policy_status"

cmd power set-adaptive-power-saver-enabled false
cmd power set-fixed-performance-mode-enabled true

for cpu in /sys/devices/system/cpu/cpu[0-7]; do
    if [ -f "$cpu/online" ]; then
        echo 1 > "$cpu/online"
    fi
done

for policy in /sys/devices/system/cpu/cpufreq/policy*; do
    echo "performance" > "$policy/scaling_governor"
done

for device in /sys/class/devfreq/*; do
    if [ -f "$device/governor" ]; then
        echo "performance" > "$device/governor"
    fi
done

if [ -d /proc/gpufreq ]; then
    gpu_freq=$(awk '/freq = [0-9]+/ {print $3}' /proc/gpufreq/gpufreq_opp_dump | sort -nr | head -n 1)
    echo "$gpu_freq" > "/proc/gpufreq/gpufreq_opp_freq"
elif [ -d /proc/gpufreqv2 ]; then
    echo "00" > "/proc/gpufreqv2/fix_target_opp_index"
fi

for path in /sys/devices/system/cpu/cpufreq/policy*; do
    max_freq=$(awk '{print $1}' "$path/scaling_available_frequencies")
    min_freq=$(awk '{print $NF}' "$path/scaling_available_frequencies")
    cluster=0
    echo "$cluster $min_freq" > "/proc/ppm/policy/hard_userlimit_min_cpu_freq"
    echo "$cluster $max_freq" > "/proc/ppm/policy/hard_userlimit_max_cpu_freq"
    cluster=$((cluster + 1))
done

echo "coarse_demand" > /sys/class/misc/mali0/device/power_policy

if [ -f "/proc/gpufreq/gpufreq_power_limited" ]; then
    for setting in ignore_batt_oc ignore_batt_percent ignore_low_batt ignore_thermal_protect ignore_pbm_limited; do
        echo "$setting 1" > "/proc/gpufreq/gpufreq_power_limited"
    done
fi

echo 1 > /sys/kernel/ged/hal/custom_upbound_gpu_freq
echo 1 > /sys/kernel/ged/hal/custom_boost_gpu_freq

echo 0 > /sys/devices/system/cpu/eas/enable
echo 3 > /proc/cpufreq/cpufreq_power_mode
echo 1 > /proc/cpufreq/cpufreq_cci_mode
echo 1 > /proc/cpufreq/cpufreq_sched_disable
echo 0 > /sys/kernel/eara_thermal/enable
echo "stop 1" > /proc/pbm/pbm_stop

for cs in /dev/cpuset/*; do
    echo "0-7" > "$cs/cpus"
    echo "0-5" > "$cs/background/cpus"
    echo "0-4" > "$cs/system-background/cpus"
    echo "0-7" > "$cs/foreground/cpus"
    echo "0-7" > "$cs/top-app/cpus"
    echo "0-5" > "$cs/restricted/cpus"
    echo "0-7" > "$cs/camera-daemon/cpus"
done

for dlp in /proc/displowpower/*; do
    echo 1 > "$dlp/hrt_lp"
    echo 1 > "$dlp/idlevfp"
    echo 100 > "$dlp/idletime"
done

echo 5 > /proc/sys/kernel/perf_cpu_time_max_percent
echo 1 > /proc/sys/kernel/sched_child_runs_first
echo 0 > /proc/sys/kernel/sched_energy_aware
echo 0 > /proc/sys/kernel/sched_schedstats

for device in /sys/block/*; do
    if [ -d "$device/queue" ]; then
        echo 128 > "$device/queue/nr_requests"
        echo 2048 > "$device/queue/read_ahead_kb"
    fi
done

echo 100 > /proc/perfmgr/boost_ctrl/eas_ctrl/perfserv_fg_boost
echo 100 > /proc/perfmgr/boost_ctrl/eas_ctrl/perfserv_ta_boost
echo 1 > /proc/perfmgr/boost_ctrl/cpu_ctrl/perfserv_all_cpu_deisolated
echo 1 > /proc/perfmgr/syslimiter/syslimiter_force_disable
echo 1 > /proc/perfmgr/boost_ctrl/cpu_ctrl/cfp_enable
echo 100 > /proc/perfmgr/boost_ctrl/cpu_ctrl/cfp_up_time

echo "default_mode" > /sys/pnpmgr/fpsgo_boost/boost_enable

if [ -w "/sys/kernel/fpsgo/fstb/boost_ta" ]; then echo "1" > "/sys/kernel/fpsgo/fstb/boost_ta"; fi
if [ -w "/sys/kernel/fpsgo/fstb/enable_switch_sync_flag" ]; then echo "0" > "/sys/kernel/fpsgo/fstb/enable_switch_sync_flag"; fi
if [ -w "/sys/kernel/fpsgo/fbt/boost_VIP" ]; then echo "1" > "/sys/kernel/fpsgo/fbt/boost_VIP"; fi
if [ -w "/sys/kernel/fpsgo/fstb/gpu_slowdown_check" ]; then echo "0" > "/sys/kernel/fpsgo/fstb/gpu_slowdown_check"; fi
if [ -w "/sys/kernel/fpsgo/fbt/thrm_limit_cpu" ]; then echo "0" > "/sys/kernel/fpsgo/fbt/thrm_limit_cpu"; fi
if [ -w "/sys/kernel/fpsgo/fbt/thrm_temp_th" ]; then echo "100" > "/sys/kernel/fpsgo/fbt/thrm_temp_th"; fi
if [ -w "/sys/kernel/fpsgo/fbt/llf_task_policy" ]; then echo "2" > "/sys/kernel/fpsgo/fbt/llf_task_policy"; fi
if [ -w "/sys/kernel/ged/hal/gpu_boost_level" ]; then echo "101" > "/sys/kernel/ged/hal/gpu_boost_level"; fi

for param in ged_smart_boost enable_gpu_boost ged_boost_enable boost_gpu_enable gpu_dvfs_enable gpu_idle gx_frc_mode gx_boost_on gx_game_mode gx_3D_benchmark_on cpu_boost_policy boost_extra; do
    if [ -w "/sys/module/ged/parameters/$param" ]; then
        echo "1" > "/sys/module/ged/parameters/$param"
    fi
done

if [ -w "/sys/module/ged/parameters/is_GED_KPI_enabled" ]; then
    echo "0" > "/sys/module/ged/parameters/is_GED_KPI_enabled"
fi

if [ -w "/sys/pnpmgr/install" ]; then
    echo "1" > "/sys/pnpmgr/install"
fi
if [ -w "/sys/pnpmgr/mwn" ]; then
    echo "1" > "/sys/pnpmgr/mwn"
fi

for param in boost_affinity boost_LR xgf_uboost xgf_extra_sub gcc_enable gcc_hwui_hint; do
    if [ -w "/sys/module/mtk_fpsgo/parameters/$param" ]; then
        echo "1" > "/sys/module/mtk_fpsgo/parameters/$param"
    fi
done

if [ -w "/sys/module/mtk_fpsgo/parameters/xgf_stddev_multi" ]; then
    echo "4" > "/sys/module/mtk_fpsgo/parameters/xgf_stddev_multi"
fi
if [ -w "/sys/module/mtk_fpsgo/parameters/gcc_up_sec_pct" ]; then
    echo "100" > "/sys/module/mtk_fpsgo/parameters/gcc_up_sec_pct"
fi
if [ -w "/sys/module/mtk_fpsgo/parameters/gcc_up_step" ]; then
    echo "100" > "/sys/module/mtk_fpsgo/parameters/gcc_up_step"
fi

for device in /sys/block/*; do
    queue="$device/queue"
    if [ -f "$queue/scheduler" ]; then
        echo "deadline" > "$queue/scheduler"
    fi
    if [ -f "$queue/nomerges" ]; then
        echo "2" > "$queue/nomerges"
    fi
    if [ -f "$queue/rq_affinity" ]; then
        echo "2" > "$queue/rq_affinity"
    fi
    if [ -f "$queue/iostats" ]; then
        echo "0" > "$queue/iostats"
    fi
done

if [ -w "/sys/module/sync/parameters/fsync_enabled" ]; then
    echo "N" > "/sys/module/sync/parameters/fsync_enabled"
fi

if [ -w "/proc/sys/kernel/printk" ]; then
    echo "0 0 0 0" > "/proc/sys/kernel/printk"
fi
if [ -w "/proc/sys/kernel/printk_devkmsg" ]; then
    echo "off" > "/proc/sys/kernel/printk_devkmsg"
fi
if [ -w "/sys/module/printk/parameters/console_suspend" ]; then
    echo "Y" > "/sys/module/printk/parameters/console_suspend"
fi
if [ -w "/sys/module/printk/parameters/cpu" ]; then
    echo "N" > "/sys/module/printk/parameters/cpu"
fi

for cpu in /sys/devices/system/cpu/cpu[1-7] /sys/devices/system/cpu/cpu1[0-7]; do
    if [ -w "$cpu/core_ctl/enable" ]; then
        echo "1" > "$cpu/core_ctl/enable"
    fi
    if [ -w "$cpu/core_ctl/core_ctl_boost" ]; then
        echo "1" > "$cpu/core_ctl/core_ctl_boost"
    fi
done

for zone in /sys/class/thermal/thermal_zone*; do
    if [ -w "$zone/trip_point_0_temp" ]; then
        echo "150000" > "$zone/trip_point_0_temp"
    fi
done

if [ -w "/proc/touch_boost/enable" ]; then
    echo "1" > "/proc/touch_boost/enable"
fi
if [ -w "/proc/touch_boost/active_time" ]; then
    echo "1000" > "/proc/touch_boost/active_time"
fi
if [ -w "/proc/touch_boost/boost_duration" ]; then
    echo "1000" > "/proc/touch_boost/boost_duration"
fi
if [ -w "/proc/touch_boost/boost_up" ]; then
    echo "1" > "/proc/touch_boost/boost_up"
fi
if [ -w "/proc/touch_boost/idleprefer_fg" ]; then
    echo "0" > "/proc/touch_boost/idleprefer_fg"
fi

if [ -w "/sys/kernel/ged/hal/dcs_mode" ]; then
    echo "66" > "/sys/kernel/ged/hal/dcs_mode"
fi

if [ -w "/proc/mtk_batoc_throttling/battery_oc_protect_stop" ]; then
    echo "stop 1" > "/proc/mtk_batoc_throttling/battery_oc_protect_stop"
fi

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
