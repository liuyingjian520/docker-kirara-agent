# Docker Kirara Agent

一个基于Docker的Kirara Agent部署工具，支持自动安装Docker和Docker Compose，实现无人值守部署。

## 特性

- 自动检测系统环境
- 智能识别Linux发行版
- 自动安装Docker和Docker Compose
- 无人值守部署
- 支持Windows和Linux系统

## 系统要求

- Linux (Ubuntu, Debian, CentOS, Fedora, SUSE, Arch等)
- Windows (需要手动安装Docker Desktop)

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

# 使用脚本URL部署 (仅限Linux)
curl -fsSL https://raw.githubusercontent.com/liuyingjian520/docker-kirara-agent/main/start.sh | bash
wget -O- https://raw.githubusercontent.com/liuyingjian520/docker-kirara-agent/main/start.sh | bash
```

## 功能说明

### Linux自动安装

在Linux系统上，脚本会自动检测系统环境，并根据不同的Linux发行版自动安装Docker和Docker Compose。支持的Linux发行版包括：

- Ubuntu/Debian系列
- CentOS/RHEL/Fedora系列
- SUSE系列
- Arch系列

### Windows手动安装

在Windows系统上，脚本会检测Docker和Docker Compose是否已安装，如果未安装，会提示用户手动安装。

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