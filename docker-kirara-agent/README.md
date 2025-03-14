# Docker Kirara Agent

这是一个Docker Kirara代理项目，用于提供Kirara服务的Docker容器化解决方案。

## 功能特点

- 简化Kirara服务的部署
- 提供容器化的Kirara代理服务
- 支持快速配置和使用
- 支持多种环境部署
- 高性能、低延迟的服务体验

## 安装要求

- Docker 19.03+
- Docker Compose 1.27+
- 至少1GB可用内存
- 至少10GB可用磁盘空间

## 使用方法

### 快速开始

```bash
# 克隆仓库
git clone https://github.com/liuyingjian520/docker-kirara-agent.git
cd docker-kirara-agent

# 启动服务 (Linux/Mac)
./start.sh

# 启动服务 (Windows)
start.bat
docker-compose up -d

# 使用脚本URL部署
wget -O- https://raw.githubusercontent.com/liuyingjian520/docker-kirara-agent/main/start.sh | bash
```

### 配置

编辑 `.env` 文件来自定义配置：

```
PORT=8080
LOG_LEVEL=info
```

## 项目结构

```
.
├── docker-compose.yml    # Docker Compose配置文件
├── Dockerfile            # Docker构建文件
├── src/                  # 源代码目录
├── config/               # 配置文件目录
└── README.md             # 项目说明文档
```

## 贡献指南

欢迎提交问题和合并请求，共同改进项目。

## 许可证

本项目采用MIT许可证 - 详见 [LICENSE](LICENSE) 文件。
