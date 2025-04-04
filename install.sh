#!/bin/bash

# Kirara Agent 自动安装脚本
# 支持自动检测系统环境、智能识别 Linux 发行版、自动安装 Docker 和 Docker Compose

# 设置颜色输出
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

# 日志函数
log() {
    echo -e "${GREEN}$(date +'%Y-%m-%d %H:%M:%S') [INFO]${NC} $1" | tee -a kirara-install.log
}

log_warn() {
    echo -e "${YELLOW}$(date +'%Y-%m-%d %H:%M:%S') [WARN]${NC} $1" | tee -a kirara-install.log
}

log_error() {
    echo -e "${RED}$(date +'%Y-%m-%d %H:%M:%S') [ERROR]${NC} $1" | tee -a kirara-install.log
}

log_success() {
    echo -e "${BLUE}$(date +'%Y-%m-%d %H:%M:%S') [SUCCESS]${NC} $1" | tee -a kirara-install.log
}

# 显示欢迎信息
echo -e "${BLUE}==================================================${NC}"
echo -e "${BLUE}       Kirara Agent 自动安装脚本${NC}"
echo -e "${BLUE}       适合小白用户的简易安装方式${NC}"
echo -e "${BLUE}==================================================${NC}"
echo ""

# 检查是否为 root 用户
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        log_error "请使用 root 用户运行此脚本"
        log_error "请尝试: sudo bash $0"
        exit 1
    fi
}

# 检查系统环境
check_system() {
    log "正在检测系统环境..."

    # 检查是否为 Windows 操作系统
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
        log_error "不支持 Windows 操作系统，请使用 Linux 系统"
        exit 1
    fi

    # 检测 Linux 发行版
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
}

# 安装 Docker
install_docker() {
    log "正在检查 Docker..."

    # 检查 Docker 是否已安装
    if command -v docker &>/dev/null; then
        DOCKER_VERSION=$(docker --version | sed 's/.*version \([0-9.]*\).*/\1/')
        log "Docker 已安装，版本: $DOCKER_VERSION"
    else
        log "Docker 未安装，正在自动安装..."

        # 安装依赖
        if command -v apt-get &>/dev/null; then
            apt-get update
            apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

            # 添加 Docker 官方 GPG 密钥
            curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

            # 设置稳定版仓库
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

            # 安装 Docker
            apt-get update
            apt-get install -y docker-ce docker-ce-cli containerd.io
        elif command -v yum &>/dev/null; then
            yum install -y yum-utils
            yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
            yum install -y docker-ce docker-ce-cli containerd.io
        elif command -v dnf &>/dev/null; then
            dnf -y install dnf-plugins-core
            dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
            dnf install -y docker-ce docker-ce-cli containerd.io
        else
            log_error "无法识别的包管理器，请手动安装 Docker"
            exit 1
        fi

        # 启动 Docker 服务
        systemctl start docker
        systemctl enable docker

        # 验证 Docker 安装
        if command -v docker &>/dev/null; then
            DOCKER_VERSION=$(docker --version | sed 's/.*version \([0-9.]*\).*/\1/')
            log_success "Docker 安装成功，版本: $DOCKER_VERSION"
        else
            log_error "Docker 安装失败"
            exit 1
        fi
    fi
}

# 安装 Docker Compose
install_docker_compose() {
    log "正在检查 Docker Compose..."

    # 检查 Docker Compose 是否已安装
    if command -v docker-compose &>/dev/null; then
        COMPOSE_VERSION=$(docker-compose --version | sed 's/.*version \([0-9.]*\).*/\1/')
        log "Docker Compose 已安装，版本: $COMPOSE_VERSION"
    else
        log "Docker Compose 未安装，正在自动安装..."

        # 安装最新版 Docker Compose
        COMPOSE_VERSION="2.18.1"
        curl -L "https://github.com/docker/compose/releases/download/v${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose

        # 验证 Docker Compose 安装
        if command -v docker-compose &>/dev/null; then
            COMPOSE_VERSION=$(docker-compose --version | sed 's/.*version \([0-9.]*\).*/\1/')
            log_success "Docker Compose 安装成功，版本: $COMPOSE_VERSION"
        else
            log_error "Docker Compose 安装失败"
            exit 1
        fi
    fi
}

# 创建 SSL 证书目录
create_ssl_cert() {
    log "正在创建 SSL 证书目录..."
    mkdir -p ssl

    # 检查是否已存在证书
    if [ -f "ssl/cert.pem" ] && [ -f "ssl/key.pem" ]; then
        log "SSL 证书已存在"
    else
        log "生成自签名 SSL 证书..."

        # 安装 OpenSSL（如果需要）
        if ! command -v openssl &>/dev/null; then
            log_warn "OpenSSL 未安装，正在安装..."
            if command -v apt-get &>/dev/null; then
                apt-get update && apt-get install -y openssl
            elif command -v yum &>/dev/null; then
                yum install -y openssl
            elif command -v dnf &>/dev/null; then
                dnf install -y openssl
            else
                log_error "无法安装 OpenSSL，请手动安装"
                exit 1
            fi
        fi

        # 生成自签名证书
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -keyout ssl/key.pem -out ssl/cert.pem \
            -subj "/C=CN/ST=State/L=City/O=Organization/CN=localhost"

        log_success "SSL 证书生成成功"
    fi
}

# 配置项目
configure_project() {
    log "正在配置项目..."

    # 创建数据目录
    mkdir -p data

    # 确保配置目录存在
    mkdir -p config

    # 更新配置文件
    cat > config/default.json << EOF
{
  "server": {
    "port": 8443,
    "logLevel": "info"
  },
  "agent": {
    "name": "Kirara Agent",
    "version": "1.0.0"
  },
  "security": {
    "enabled": true,
    "ssl": {
      "enabled": true,
      "cert": "/app/ssl/cert.pem",
      "key": "/app/ssl/key.pem"
    },
    "authentication": {
      "enabled": true,
      "tokenExpiration": 86400,
      "users": [
        {
          "username": "admin",
          "password": "change_me_immediately",
          "role": "admin"
        }
      ]
    },
    "rateLimiting": {
      "enabled": true,
      "maxRequests": 100,
      "windowMs": 60000
    }
  }
}
EOF

    log_success "项目配置完成"
}

# 启动服务
start_service() {
    log "正在启动 Kirara Agent 服务..."

    # 使用 Docker Compose 启动服务
    docker-compose up -d

    # 检查服务是否成功启动
    if [ $? -eq 0 ]; then
        log_success "Kirara Agent 服务启动成功！"
        log_success "您可以通过 https://localhost:8443 访问服务"
    else
        log_error "Kirara Agent 服务启动失败，请检查日志"
        exit 1
    fi
}

# 主函数
main() {
    # 检查 root 权限
    check_root

    # 检查系统环境
    check_system

    # 安装 Docker
    install_docker

    # 安装 Docker Compose
    install_docker_compose

    # 创建 SSL 证书
    create_ssl_cert

    # 配置项目
    configure_project

    # 启动服务
    start_service

    log_success "=================================================="
    log_success "       Kirara Agent 安装完成！"
    log_success "       访问地址: https://localhost:8443"
    log_success "       默认用户名: admin"
    log_success "       默认密码: change_me_immediately"
    log_success "       请务必修改默认密码！"
    log_success "=================================================="
}

# 执行主函数
main
