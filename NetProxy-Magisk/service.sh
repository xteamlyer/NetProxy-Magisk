#!/system/bin/sh

# 等待设备启动完成（系统启动已完成标志 sys.boot_completed 为 1）
until [ "$(getprop sys.boot_completed)" = 1 ]; do sleep 1; done

# 等待 /sdcard/Android 目录出现，确保存储卡挂载完成
until [ -d "/sdcard/Android" ]; do sleep 1; done

MODDIR=${0%/*}
START_SCRIPT="$MODDIR/start.sh"

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$MODDIR/xraycore/log/service.log"
}

# 检查 start.sh 脚本是否存在
if [ ! -f "$START_SCRIPT" ]; then
    log "错误：start.sh脚本不存在，无法启动Xray"
    exit 1
fi

# 运行 start.sh 脚本
log "正在启动 Xray..."
sh "$START_SCRIPT"

# 检查 start.sh 是否成功运行
if [ $? -eq 0 ]; then
    log "Xray启动成功"
else
    log "Xray启动失败"
    exit 1
fi