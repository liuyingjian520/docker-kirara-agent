@echo off
echo 正在启动Kirara Agent服务...

:: 检查Docker是否安装
docker --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo 错误: Docker未安装，请先安装Docker
    echo 您可以从 https://www.docker.com/products/docker-desktop 下载安装
    pause
    exit /b 1
)

:: 检查Docker Compose是否安装
docker-compose --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo 错误: Docker Compose未安装，请先安装Docker Compose
    echo Docker Desktop通常已包含Docker Compose
    pause
    exit /b 1
)

:: 启动服务
docker-compose up -d

:: 添加日志记录
echo %date% %time% [info] Kirara Agent服务已启动 >> service.log

echo 服务已启动，访问 http://localhost:8080 查看服务状态
pause