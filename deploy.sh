#!/bin/bash

# Kirara Agent 一键部署脚本
# 支持通过 URL 部署，适合纯小白操作

# 设置颜色输出
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

# 显示欢迎信息
echo -e "${BLUE}==================================================${NC}"
echo -e "${BLUE}       Kirara Agent 一键部署脚本${NC}"
echo -e "${BLUE}       适合小白用户的简易安装方式${NC}"
echo -e "${BLUE}==================================================${NC}"
echo ""

# 检查是否为 root 用户
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}请使用 root 用户运行此脚本${NC}"
    echo -e "${YELLOW}请尝试: sudo bash $0${NC}"
    exit 1
fi

# 创建日志文件
LOG_FILE="kirara-deploy.log"
echo "Kirara Agent 部署日志" > $LOG_FILE
echo "部署时间: $(date)" >> $LOG_FILE
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

# 检查并安装必要工具
check_and_install_tool() {
    local tool=$1
    if ! command -v $tool &> /dev/null; then
        log_warn "正在安装 $tool..."
        if command -v apt-get &> /dev/null; then
            apt-get update && apt-get install -y $tool
        elif command -v yum &> /dev/null; then
            yum install -y $tool
        elif command -v dnf &> /dev/null; then
            dnf install -y $tool
        elif command -v zypper &> /dev/null; then
            zypper install -y $tool
        elif command -v apk &> /dev/null; then
            apk add --no-cache $tool
        else
            log_error "无法安装 $tool，请手动安装后重试"
            exit 1
        fi
    fi
}

# 检查并安装 curl 和 git
check_and_install_tool "curl"
check_and_install_tool "git"

# 创建临时目录
TMP_DIR=$(mktemp -d)
log "创建临时目录: $TMP_DIR"

# 克隆仓库
log "正在克隆 Kirara Agent 仓库..."
git clone https://github.com/user/docker-kirara-agent.git $TMP_DIR/docker-kirara-agent
if [ $? -ne 0 ]; then
    log_error "克隆仓库失败，尝试使用备用方法下载..."
    # 备用下载方法
    mkdir -p $TMP_DIR/docker-kirara-agent
    curl -fsSL https://raw.githubusercontent.com/user/docker-kirara-agent/main/install.sh -o $TMP_DIR/docker-kirara-agent/install.sh
    chmod +x $TMP_DIR/docker-kirara-agent/install.sh

    if [ ! -f $TMP_DIR/docker-kirara-agent/install.sh ]; then
        log_error "下载安装脚本失败，请检查网络连接"
        exit 1
    fi
fi

# 进入项目目录
cd $TMP_DIR/docker-kirara-agent

# 执行安装脚本
log "开始安装 Kirara Agent..."
bash install.sh

# 清理临时文件
log "清理临时文件..."
rm -rf $TMP_DIR

log_success "Kirara Agent 部署完成！"
log_success "您可以通过 https://localhost:8443 访问服务"
log_success "如需帮助，请查看 README.md 文件或联系开发团队"
