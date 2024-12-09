#!/system/bin/sh
SKIPMOUNT=false
PROPFILE=true
POSTFSDATA=true
LATESTARTSERVICE=true

ui_print "█▄▄ █░█ █▀▄▀█ █▄▄ █░█   █▀█ ▄▀█ █▀▀ █ █▄▀"
ui_print "█▄█ █▄█ █░▀░█ █▄█ █▄█   █▀▄ █▀█ █▄▄ █ █░█"
ui_print "- Author : @al4uu"
ui_print "- Version : 2.3"
ui_print " "
ui_print "- Installing.."

sleep 5

unzip "$ZIPFILE" system/* -d "$MODPATH/" >/dev/null 2>&1

cp -af "$TMPDIR"/common/uninstall.sh "$MODPATH"/uninstall.sh >/dev/null 2>&1

sleep 5

ui_print " "
