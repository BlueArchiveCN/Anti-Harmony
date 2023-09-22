# 通用部分
# SKIPUNZIP: 解压方式。0=自动，1=手动
# MODPATH (path): 当前模块的安装目录
# TMPDIR (path): 可以存放临时文件的目录
# ZIPFILE (path): 当前模块的安装包文件
# ARCH (string): 设备的 CPU 构架，有如下几种arm, arm64, x86, or x64
# IS64BIT (bool): 是否是 64 位设备
# API (int): 当前设备的 Android API 版本 (如: Android 13.0 上为 33)

# For Magisk
# MAGISK_VER (string): 当前安装的 Magisk 的版本字符串 (如: 26.1)
# MAGISK_VER_CODE (int): 当前安装的 Magisk 的版本代码 (如: 26100)
# BOOTMODE (bool): 如果模块被安装在 Magisk 应用程序中则值为true

# For KernelSU
# KSU (bool): 标记此脚本运行在 KernelSU 环境下，此变量的值将永远为 true，你可以通过它区分 Magisk。
# KSU_VER (string): KernelSU 当前的版本名字 (如: v0.4.0)
# KSU_VER_CODE (int): KernelSU 用户空间当前的版本号 (如: 10672)
# KSU_KERNEL_VER_CODE (int): KernelSU 内核空间当前的版本号 (如: 10672)
# BOOTMODE (bool): 此变量在 KernelSU 中永远为 true

SKIPUNZIP=0
# system 启用=true,关闭=false
SKIPMOUNT=false

# system.prop 启用=true,关闭=false
PROPFILE=false

# post-fs-data 启用=true,关闭=false
POSTFSDATA=false

# service.sh 启用=true,关闭=false
LATESTARTSERVICE=true

on_install() {
  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2

  ui_print "正在准备替换和谐立绘"

  if [ ! -d "/data/media/0/Android/data/com.RoamingStar.BlueArchive" ] && [ ! -d "/data/media/0/Android/data/com.RoamingStar.BlueArchive.bilibili" ]; then
    ui_print "未检测到游戏"
  else
    #官服检测
    if [ -d "/data/media/0/Android/data/com.RoamingStar.BlueArchive" ]; then
        ui_print "已检测到官服"
        mkdir -p /sdcard/Documents/BA-backups
        for file in ${MODPATH}/files/*; do
            filename=$(basename "$file")
            if [ -f "/data/media/0/Android/data/com.RoamingStar.BlueArchive/files/AssetBundls/$filename" ]; then
                cp "/data/media/0/Android/data/com.RoamingStar.BlueArchive/files/AssetBundls/$filename" "/sdcard/Documents/BA-backups/$filename"
            fi
        done
        cp -r ${MODPATH}/files/* /data/media/0/Android/data/com.RoamingStar.BlueArchive/files/AssetBundls/
    else
        ui_print "未检测到官服"
    fi

    #b服安装
    if [ -d "/data/media/0/Android/data/com.RoamingStar.BlueArchive.bilibili" ]; then
        ui_print "已检测到b服"
        mkdir -p /sdcard/Documents/BA-b-backups
        for file in ${MODPATH}/files/*; do
            filename=$(basename "$file")
            if [ -f "/data/media/0/Android/data/com.RoamingStar.BlueArchive.bilibili/files/AssetBundls/$filename" ]; then
                cp "/data/media/0/Android/data/com.RoamingStar.BlueArchive.bilibili/files/AssetBundls/$filename" "/sdcard/Documents/BA-b-backups/$filename"
            fi
        done
        cp -r ${MODPATH}/files/* /data/media/0/Android/data/com.RoamingStar.BlueArchive/files/AssetBundls/
    else
        ui_print "未检测到b服"
    fi


    ui_print "*********************************************"
    ui_print "删除模块可能有掉Magisk得风险，谨慎删除！"
    ui_print "*********************************************"
    ui_print "安装完成"
  fi
}

set_permissions() {
  # 以下是默认规则,请勿删除
  set_perm_recursive $MODPATH 0 0 0755 0644

  # 以下是一些例子:
  # set_perm_recursive  $MODPATH/system/lib       0     0       0755      0644
  # set_perm  $MODPATH/system/bin/app_process32   0     2000    0755      u:object_r:zygote_exec:s0
  # set_perm  $MODPATH/system/bin/dex2oat         0     2000    0755      u:object_r:dex2oat_exec:s0
  # set_perm  $MODPATH/system/lib/libart.so       0     0       0644
}