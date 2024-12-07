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

MODPATH=/data/adb/modules/bumbu_racik

mkdir -p "$MODPATH"/system/lib/egl
mkdir -p "$MODPATH"/system/lib64/egl
mkdir -p "$MODPATH"/system/vendor/lib/egl
mkdir -p "$MODPATH"/system/vendor/lib64/egl

model=$(cat /sys/class/kgsl/kgsl-3d0/gpu_model)
config="0 1 $model"

echo "$config" > "$MODPATH"/system/lib/egl/egl.cfg
echo "$config" > "$MODPATH"/system/lib64/egl/egl.cfg
echo "$config" > "$MODPATH"/system/vendor/lib/egl/egl.cfg
echo "$config" > "$MODPATH"/system/vendor/lib64/egl/egl.cfg

echo 0 > /sys/block/sda/queue/iostats
echo 0 > /sys/block/loop1/queue/iostats
echo 0 > /sys/block/loop2/queue/iostats
echo 0 > /sys/block/loop3/queue/iostats
echo 0 > /sys/block/loop4/queue/iostats
echo 0 > /sys/block/loop5/queue/iostats
echo 0 > /sys/block/loop6/queue/iostats
echo 0 > /sys/block/loop7/queue/iostats
echo 0 > /sys/block/dm-0/queue/iostats
echo 0 > /sys/block/loop0/queue/iostats
echo 0 > /sys/block/mmcblk1/queue/iostats
echo 0 > /sys/block/mmcblk0/queue/iostats
echo 0 > /sys/block/mmcblk0rpmb/queue/iostats

resetprop -n log_ao 0
resetprop -n rw.logger 0
resetprop -n log.tag.all 0
resetprop -n debug_test 0
resetprop -n log.shaders 0
resetprop -n config.stats 0
resetprop -n sys.miui.ndcd 0
resetprop -n logd.statistics 0
resetprop -n media.metrics 0
resetprop -n ro.logd.size OFF
resetprop -n debug.hwc.otf 0
resetprop -n ro.debuggable 0
resetprop -n debug.sf.ddms 0
resetprop -n log_frame_info 0
resetprop -n debug.sf.dump 0
resetprop -n vidc.debug.level 0
resetprop -n sys.init_log_level 0
resetprop -n ro.logd.kernel false
resetprop -n ro.kernel.checkjni 0
resetprop -n libc.debug.malloc 0
resetprop -n debug.egl.profiler 0
resetprop -n persist.logd.size OFF
resetprop -n persist.logd.limit OFF
resetprop -n persist.logd.limit OFF
resetprop -n log.tag.stats_log OFF
resetprop -n ro.logd.size.stats 64K
resetprop -n ro.statsd.enable false
resetprop -n persist.anr.dumpthr 0
resetprop -n config.disable_rtt true
resetprop -n persist.logd.size 65536
resetprop -n debug.hwc_dump_en 0
resetprop -n debug.mdpcomp.logs 0
resetprop -n sys.wifitracing.started 0
resetprop -n persist.ims.disabled true
resetprop -n vendor.debug.rs.visual 0
resetprop -n vendor.debug.rs.script 0
resetprop -n persist.logd.size.radio 1M
resetprop -n vendor.debug.rs.debug 0
resetprop -n vendor.debug.rs.profile 0
resetprop -n debug.rs.qcom.verbose 0
resetprop -n persist.logd.size.crash 1M
resetprop -n vendor.vidc.debug.level 0
resetprop -n vendor.debug.rs.shader 0
resetprop -n debug.enable.wl_log false
resetprop -n debug.rs.qcom.noprofile 1
resetprop -n persist.traced.enable false
resetprop -n persist.logd.size.radio OFF
resetprop -n ro.logdumpd.enabled false
resetprop -n debug.qualcomm.sns.hal 0
resetprop -n media.stagefright.log-uri 0
resetprop -n debug.cpurend.vsync false
resetprop -n persist.logd.size.crash OFF
resetprop -n persist.logd.size.system 1M
resetprop -n ro.config.ksm.support false
resetprop -n persist.debug.sensors.hal 0
resetprop -n debug.rs.qcom.noperfhint 1
resetprop -n persist.sys.perf.debug false
resetprop -n ro.hwui.path_cache_size 64
resetprop -n ro.kernel.android.checkjni 0
resetprop -n debug.rs.qcom.notextures 1
resetprop -n ro.hwui.layer_cache_size 64
resetprop -n debug.rs.qcom.blurimpl gpu
resetprop -n media.metrics.enabled false
resetprop -n persist.sys.ssr.restart_level 1
resetprop -n persist.logd.size.system OFF
resetprop -n debug.rs.qcom.noobjcache 1
resetprop -n debug.rs.qcom.force_finish 1
resetprop -n logd.logpersistd.enable false
resetprop -n debug.atrace.app_cmdlines 0
resetprop -n tombstoned.max_anr_count 0
resetprop -n debug.rs.qcom.dump_setup 0
resetprop -n debug.sqlite.journalmode OFF
resetprop -n ro.hwui.gradient_cache_size 2
resetprop -n ro.hwui.r_buffer_cache_size 16
resetprop -n db.log.slow_query_threshold 0
resetprop -n persist.debug.wfd.enable false
resetprop -n ro.hwui.texture_cache_size 128
resetprop -n net.ipv4.tcp_no_metrics_save 1
resetprop -n debug.rs.qcom.nointrinsicblur 1
resetprop -n debug.rs.qcom.nointrinsicblas 1
resetprop -n debug.rs.qcom.use_fast_math 1
resetprop -n persist.traced_perf.enable false
resetprop -n persist.data.qmi.adb_logmask 0
resetprop -n debug.rs.qcom.dump_bitcode 0
resetprop -n persist.ims.disableIMSLogs true
resetprop -n debug.sqlite.wal.syncmode OFF
resetprop -n debug.qualcomm.sns.daemon 0
resetprop -n persist.service.logd.enable false
resetprop -n debug.atrace.tags.enableflags 0
resetprop -n persist.ims.disableADBLogs true
resetprop -n debug.rs.qcom.disable_expand 1
resetprop -n persist.sys.offlinelog.kernel false
resetprop -n persist.mm.enable.prefetch false
resetprop -n persist.sys.offlinelog.logcat false
resetprop -n persist.vendor.crash.detect false
resetprop -n db.log.slow_query_threshold 999
resetprop -n vendor.debug.rs.qcom.verbose 0
resetprop -n av.debug.disable.pers.cache true
resetprop -n persist.sys.dalvik.multithread true
resetprop -n debug.qualcomm.sns.libsensor1 0
resetprop -n persist.vendor.radio.adb_log_on 0
resetprop -n vendor.debug.rs.forcerecompile 0
resetprop -n persist.sys.ssr.enable_debug false
resetprop -n persist.sys.strictmode.disable true
resetprop -n persist.ims.disableQXDMLogs true
resetprop -n persist.ims.disableDebugLogs true
resetprop -n ro.vendor.connsys.dedicated.log 0
resetprop -n vendor.debug.rs.shader.uniforms 0
resetprop -n persist.wpa_supplicant.debug false
resetprop -n ro.hwui.drop_shadow_cache_size 8
resetprop -n ro.telephony.call_ring.multiple false
resetprop -n debug.atrace.tags.enableflags false
resetprop -n ro.hwui.texture_cache_flushrate 0.2
resetprop -n vendor.debug.rs.shader.attributes 0
resetprop -n vendor.bluetooth.startbtlogger false
resetprop -n persist.vendor.sys.reduce_qdss_log 1
resetprop -n vendor.debug.rs.qcom.dump_setup 0
resetprop -n ro.hwui.text_large_cache_width 4096
resetprop -n ro.hwui.text_small_cache_width 2048
resetprop -n tombstoned.max_tombstone_count 0
resetprop -n persist.sys.dalvik.hyperthreading true
resetprop -n persist.vendor.radio.snapshot_timer 0
resetprop -n ro.hwui.text_large_cache_height 4096
resetprop -n ro.hwui.text_small_cache_height 2048
resetprop -n persist.sys.offlinelog.logcatkernel false
resetprop -n vendor.debug.rs.qcom.dump_bitcode 0
resetprop -n persist.bluetooth.btsnooplogmode disabled
resetprop -n persist.vendor.radio.snapshot_enabled false
resetprop -n debug.sf.disable_client_composition_cache 1
resetprop -n persist.vendor.verbose_logging_enabled false
resetprop -n persist.vendor.sys.modem.logging.enable false

rm "$MODPATH"/post-fs-data.sh
