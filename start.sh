#!/bin/bash

# 检查是否为Windows操作系统
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    echo "错误: 不支持Windows操作系统"
    exit 1
fi

# 日志函数
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') [info] $1" | tee -a service.log
    echo "$1"
}

log "开始检测系统环境..."

# 检测Linux发行版
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    VERSION=$VERSION_ID
    log "检测到操作系统: $OS $VERSION"
else
    OS=$(uname -s)
    VERSION=$(uname -r)
    log "检测到操作系统: $OS $VERSION"
fi

# 检查并安装Docker
install_docker() {
    log "正在安装Docker..."
    case $OS in
        *Ubuntu*|*Debian*)
            apt-get update
            apt-get install -y apt-transport-https ca-certificates curl software-properties-common
            curl -fsSL https://download.docker.com/linux/$ID/gpg | apt-key add -
            add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$ID $(lsb_release -cs) stable"
            apt-get update
            apt-get install -y docker-ce docker-ce-cli containerd.io
            ;;
        *CentOS*|*Red*|*Fedora*)
            yum install -y yum-utils
            yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
            yum install -y docker-ce docker-ce-cli containerd.io
            ;;
        *SUSE*)
            zypper install -y docker
            ;;
        *Arch*)
            pacman -Sy docker --noconfirm
            ;;
        *)
            log "无法识别的Linux发行版，请手动安装Docker"
            exit 1
            ;;
    esac
    
    # 启动Docker服务
    systemctl enable docker
    systemctl start docker
    log "Docker安装完成"
}

# 检查并安装Docker Compose
install_docker_compose() {
    log "正在安装Docker Compose..."
    COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
    curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
    log "Docker Compose安装完成"
}

# 检查Docker是否安装
if ! command -v docker &> /dev/null; then
    log "Docker未安装，正在自动安装..."
    install_docker
else
    log "Docker已安装，版本: $(docker --version)"
fi

# 检查Docker Compose是否安装
if ! command -v docker-compose &> /dev/null; then
    log "Docker Compose未安装，正在自动安装..."
    install_docker_compose
else
    log "Docker Compose已安装，版本: $(docker-compose --version)"
fi

# 启动服务
log "正在启动Kirara Agent服务..."
docker-compose up -d

log "服务已启动，访问 http://localhost:8080 查看服务状态"