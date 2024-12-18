#!/system/bin/sh
SKIPMOUNT=false
PROPFILE=true
POSTFSDATA=true
LATESTARTSERVICE=true

ui_print "| ⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀"
ui_print "| ⢀⢀⢀⢀⢀⢀⢀⡤⠒⠋⠉⠉⠉⠉⠉⠑⠲⢄⢀⢀⢀⢀⢀⢀⢀"
ui_print "| ⢀⢀⢀⢀⢀⠔⢁⡠⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⠉⢢⢀⢀⢀⢀⢀"
ui_print "| ⢀⢀⢀⢠⠃⣴⡇⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⠱⡄⢀⢀⢀"
ui_print "| ⢀⢀⢠⠃⢀⣿⣧⣀⢀⢀⣀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⠹⡀⢀⢀"
ui_print "| ⢀⢀⡇⢀⢀⠹⣶⣿⣿⣿⣿⣿⣶⣶⣶⣤⡀⢀⢀⣴⡿⢀⡇⢀⢀"
ui_print "| ⢀⢀⡇⢀⢀⢀⠤⣾⣿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⢀⡇⢀⢀"
ui_print "| ⢀⢀⡇⢀⣠⣤⣶⣿⣿⣧⣉⣿⣿⡟⣃⣿⢿⡿⢀⢀⢀⢀⡇⢀⢀"
ui_print "| ⢀⢀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⢀⢀⢀⢀⢀⡰⠁⢀⢀"
ui_print "| ⢀⢀⢀⠘⣿⣿⣿⣿⣿⣏⡀⢀⣸⣿⣿⢀⢀⢀⢀⢀⡰⠃⢀⢀⢀"
ui_print "| ⢀⢀⢀⢀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⡏⢀⢀⢀⣠⠞⠁⢀⢀⢀⢀"
ui_print "| ⢀⢀⢀⢀⢀⢀⠈⠙⠿⢿⣿⣿⣿⣿⣇⡠⠔⠊⠁⢀⢀⢀⢀⢀⢀"
ui_print "| ⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀"
ui_print " "
sleep 1
ui_print "| █▄▄ █░█ █▀▄▀█ █▄▄ █░█   █▀█ ▄▀█ █▀▀ █ █▄▀"
ui_print "| █▄█ █▄█ █░▀░█ █▄█ █▄█   █▀▄ █▀█ █▄▄ █ █░█"
ui_print "- Author : @al4uu"
ui_print "- Version : 2.6"
ui_print " "
sleep 1
ui_print "- Device : $(getprop ro.product.manufacturer), $(getprop ro.product.device)"
sleep 1
ui_print "- SELinux Status : $(getenforce)"
sleep 1
ui_print "- Kernel Version : $(uname -r)"
sleep 1
ui_print " "
sleep 1
ui_print "- Installing.."

sleep 5

unzip "$ZIPFILE" system/* -d "$MODPATH/" >/dev/null 2>&1

cp -af "$TMPDIR"/common/uninstall.sh "$MODPATH"/uninstall.sh >/dev/null 2>&1

sleep 5

ui_print " "
