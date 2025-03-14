#!/bin/bash

# 检查是否为Windows操作系统
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    echo "错误: 不支持Windows操作系统"
    exit 1
fi

# 检查Docker是否安装
if ! command -v docker &> /dev/null; then
    echo "错误: Docker未安装，请先安装Docker"
    exit 1
fi

# 检查Docker Compose是否安装
if ! command -v docker-compose &> /dev/null; then
    echo "错误: Docker Compose未安装，请先安装Docker Compose"
    exit 1
fi

# 启动服务
echo "正在启动Kirara Agent服务..."
docker-compose up -d

echo "服务已启动，访问 http://localhost:8080 查看服务状态"