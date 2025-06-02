#!/system/bin/sh

MODDIR=${0%/*}
LOG_FILE="$MODDIR/xraycore/log/service.log"
STATUS_FILE="$MODDIR/xraycore/xray_status.yaml"
XRAY_LOG_FILE="$MODDIR/xraycore/log/xray.log"

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# 更新状态文件
update_status() {
    CONFIG_PATH=$(awk '/config:/ {print $2}' "$STATUS_FILE" | tr -d '"')
    echo "status: \"stopped\"" > "$STATUS_FILE"
    echo "config: \"$CONFIG_PATH\"" >> "$STATUS_FILE"
    log "更新状态文件: Xray已停止"
}

# 停止Xray
stop_xray() {
    log "开始停止Xray服务..."
    PID=$(pgrep xray)
    if [ -n "$PID" ]; then
        kill -9 $PID
        log "Xray进程已终止，PID: $PID"

        log "恢复 iptables 规则..."

        # 删除 XRAY 链
        iptables -w 3 -t nat -F XRAY
        iptables -w 3 -t nat -X XRAY
        log "删除 XRAY 链"

        # 恢复 OUTPUT 规则
        iptables -w 3 -t nat -D OUTPUT -p tcp -j XRAY
        log "删除全局代理规则"

        log "iptables规则恢复完成"
    else
        log "错误：未找到Xray进程PID"
    fi

    # 更新状态文件为停止状态
    update_status
}

# 停止Xray服务
stop_xray