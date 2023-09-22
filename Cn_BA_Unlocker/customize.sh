SKIPUNZIP=0
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


echo "正在准备安装" > ${MODPATH}/install.log

#环境检测
ui_print "正在检测运行环境"
if [[ $KSU == true ]]; then
  ui_print "- KernelSU 用户空间当前的版本号: $KSU_VER_CODE"
  ui_print "- KernelSU 内核空间当前的版本号: $KSU_KERNEL_VER_CODE"
  echo "Kernel SU" >> ${MODPATH}/install.log
else
  ui_print "- Magisk 版本: $MAGISK_VER_CODE"
  if [ "$MAGISK_VER_CODE" -lt 24000 ]; then
    ui_print "*********************************************"
    ui_print "! 请安装 Magisk 24.0+"
    abort "*********************************************"
  else
    ui_print "- Magisk 版本号: $MAGISK_VER_CODE"
    echo "Magisk" >> ${MODPATH}/install.log
  fi
fi

echo "准备进行解压释放" >> ${MODPATH}/install.log

unzip -o "${ZIPFILE}" -x 'META-INF/*' -d ${MODPATH} >> ${MODPATH}/install.log 2>&1

echo "释放命令执行完成" >> ${MODPATH}/install.log

ui_print "正在准备替换和谐立绘"

if [ ! -d "/data/media/0/Android/data/com.RoamingStar.BlueArchive" ] && [ ! -d "/data/media/0/Android/data/com.RoamingStar.BlueArchive.bilibili" ]; then
  ui_print "未检测到游戏"
  echo "未检测到游戏" >> ${MODPATH}/install.log
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
      echo "官服安装完成" >> ${MODPATH}/install.log
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
      echo "b服安装完成" >> ${MODPATH}/install.log
  else
      ui_print "未检测到b服"
  fi

  ui_print "安装完成"
  echo "安装完成" >> ${MODPATH}/install.log
fi