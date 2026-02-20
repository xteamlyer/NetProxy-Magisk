#!/system/bin/sh
# NetProxy Action Script
# 用于 Magisk Manager 中的模块操作按钮 (启动/停止切换)

readonly MODDIR="${0%/*}"
readonly SERVICE_SCRIPT="$MODDIR/scripts/core/service.sh"
readonly LOG_FILE="$MODDIR/logs/service.log"
readonly XRAY_BIN="$MODDIR/bin/xray"

. "$MODDIR/scripts/utils/log.sh"

#######################################
# 检查 Xray 是否运行
#######################################
is_xray_running() {
    pidof -s "$XRAY_BIN" >/dev/null 2>&1
}

# 主流程
if is_xray_running; then
    log "检测到 Xray 正在运行，执行停止操作"
    sh "$SERVICE_SCRIPT" stop
else
    log "检测到 Xray 未运行，执行启动操作"
    sh "$SERVICE_SCRIPT" start
fi