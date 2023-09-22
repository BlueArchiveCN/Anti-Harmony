#!/system/bin/sh

if [ ! -d "/data/media/0/Android/data/com.RoamingStar.BlueArchive" ] && [ ! -d "/data/media/0/Android/data/com.RoamingStar.BlueArchive.bilibili" ]; then
    ui_print "未检测到备份文件夹"
    su
    rm -f /data/media/0/Android/data/com.RoamingStar.BlueArchive/files/AssetBundls/*
    rm -f /data/media/0/Android/data/com.RoamingStar.BlueArchive.bilibili/files/AssetBundls/*
else
    ui_print "替换回原有文件"
    if [ -d "/sdcard/Documents/BA-backups/" ]; then
        su
        mv -f "/sdcard/Documents/BA-backups/"* "/data/media/0/Android/data/com.RoamingStar.BlueArchive/files/AssetBundls/"
        rm -rf "/sdcard/Documents/BA-backups/"
    fi

    if [ -d "/sdcard/Documents/BA-b-backups/" ]; then
        su
        mv -f "/sdcard/Documents/BA-b-backups/"* "/data/media/0/Android/data/com.RoamingStar.BlueArchive.bilibili/files/AssetBundls/"
        rm -rf "/sdcard/Documents/BA-b-backups/"
    fi
fi