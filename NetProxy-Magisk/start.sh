#!/system/bin/sh

MODDIR=${0%/*}
LOG_FILE="$MODDIR/xraycore/log/service.log"
XRAY_BIN="$MODDIR/xraycore/xray"
STATUS_FILE="$MODDIR/xraycore/xray_status.yaml"
XRAY_LOG_FILE="$MODDIR/xraycore/log/xray.log"

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# 更新状态文件
update_status() {
    CONFIG_PATH=$1
    echo "status: \"running\"" > "$STATUS_FILE"
    echo "config: \"$CONFIG_PATH\"" >> "$STATUS_FILE"
    log "更新状态文件: 运行配置: $CONFIG_PATH"
}

# 启动Xray
start_xray() {
    log "开始启动Xray服务..."

    # 从状态文件中读取配置
    CONFIG_PATH=$(awk '/config:/ {print $2}' "$STATUS_FILE" | tr -d '"')

    # 检查配置文件是否存在
    if [ ! -f "$CONFIG_PATH" ]; then
        log "错误：配置文件不存在: $CONFIG_PATH"
        exit 1
    fi

    # 启动 Xray
    nohup $XRAY_BIN -config $CONFIG_PATH > "$XRAY_LOG_FILE" 2>&1 &
    XRAY_PID=$!
    log "Xray启动成功，PID: $XRAY_PID"

    # 更新状态文件为运行状态
    update_status "$CONFIG_PATH"
     
    log "设置iptables规则..."
    iptables -w 3 -t nat -N XRAY 2>/dev/null
   
    iptables -w 3 -t nat -A XRAY -p tcp -j REDIRECT --to-ports 1080
    log "添加端口重定向规则"

    iptables -w 3 -t nat -I OUTPUT -p tcp -m owner --uid-owner 0 -j RETURN
    log "添加root进程直连规则"

    iptables -w 3 -t nat -A OUTPUT -p tcp -j XRAY
    log "添加全局代理规则"
}

# 检查Xray是否正在运行
check_xray_running() {
    PID=$(pgrep xray)
    if [ -n "$PID" ]; then
        log "Xray正在运行，PID: $PID"
        return 0  # 进程正在运行
    else
        log "Xray未运行"
        return 1  # 进程未运行
    fi
}

# 启动Xray服务
check_xray_running
if [ $? -eq 0 ]; then
    log "Xray已经在运行，不需要再次启动"
else
    start_xray
fi