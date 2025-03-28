#!/bin/bash

# Kirara Agent 服务启动脚本

# 设置颜色输出
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

# 创建日志文件
LOG_FILE="service.log"
echo "Kirara Agent 服务日志" > $LOG_FILE
echo "启动时间: $(date)" >> $LOG_FILE
echo "" >> $LOG_FILE

# 日志函数
log() {
    echo -e "${GREEN}$(date +'%Y-%m-%d %H:%M:%S') [INFO]${NC} $1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') [INFO] $1" >> $LOG_FILE
}

log_warn() {
    echo -e "${YELLOW}$(date +'%Y-%m-%d %H:%M:%S') [WARN]${NC} $1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') [WARN] $1" >> $LOG_FILE
}

log_error() {
    echo -e "${RED}$(date +'%Y-%m-%d %H:%M:%S') [ERROR]${NC} $1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') [ERROR] $1" >> $LOG_FILE
}

log_success() {
    echo -e "${BLUE}$(date +'%Y-%m-%d %H:%M:%S') [SUCCESS]${NC} $1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') [SUCCESS] $1" >> $LOG_FILE
}

# 显示欢迎信息
echo -e "${BLUE}==================================================${NC}"
echo -e "${BLUE}       Kirara Agent 服务启动脚本${NC}"
echo -e "${BLUE}==================================================${NC}"
echo ""

# 检查是否为root用户
if [ "$(id -u)" -ne 0 ]; then
    log_error "请使用root用户运行此脚本"
    log_error "请尝试: sudo bash $0"
    exit 1
fi