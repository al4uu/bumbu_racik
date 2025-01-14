#!/system/bin/sh
SKIPMOUNT=false
PROPFILE=true
POSTFSDATA=true
LATESTARTSERVICE=true

ui_print "************************"
ui_print "*   Bumbu Racik V3.1   *"
ui_print "***********************"
ui_print "*   @al4uu @allprjkt   *"
ui_print "************************"
ui_print " "
sleep 1
ui_print "- Device : $(getprop ro.product.manufacturer), $(getprop ro.product.device)"
sleep 1
ui_print "- SELinux Status : $(getenforce)"
sleep 1
ui_print "- Kernel Version : $(uname -r)"
sleep 1
ui_print " "
ui_print "- Installing.."

sleep 5

unzip "$ZIPFILE" system/* -d "$MODPATH/" >/dev/null 2>&1

cp -af "$TMPDIR"/common/uninstall.sh "$MODPATH"/uninstall.sh >/dev/null 2>&1

sleep 5

ui_print "- Installation Successful."
sleep 2
ui_print "- The secret recipe is gonna take over your Device !"
ui_print " "
