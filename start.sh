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

# 检查Docker是否安装
if ! command -v docker &>/dev/null; then
    log_error "Docker未安装，请先安装Docker"
    log_error "可以运行 install.sh 脚本自动安装所需环境"
    exit 1
fi

# 检查Docker Compose是否安装
if ! command -v docker-compose &>/dev/null; then
    log_error "Docker Compose未安装，请先安装Docker Compose"
    log_error "可以运行 install.sh 脚本自动安装所需环境"
    exit 1
fi

# 检查配置文件
if [ ! -f "config/default.json" ]; then
    log_warn "配置文件不存在，正在创建默认配置..."
    mkdir -p config
    # 复制默认配置文件
    if [ -f "config/default.json.example" ]; then
        cp config/default.json.example config/default.json
        log_success "已创建默认配置文件"
    else
        log_error "默认配置文件模板不存在，请手动配置"
        exit 1
    fi
fi

# 启动服务
log "正在启动Kirara Agent服务..."

# 使用Docker Compose启动服务
docker-compose up -d

# 检查服务是否成功启动
if [ $? -eq 0 ]; then
    log_success "Kirara Agent服务启动成功！"
    log_success "您可以通过 https://localhost:8443 访问服务"
    
    # 显示容器状态
    docker-compose ps
else
    log_error "Kirara Agent服务启动失败，请检查日志"
    exit 1
fi