@echo off
setlocal enabledelayedexpansion

:: Kirara Agent Windows一键部署脚本
:: 支持通过URL部署，适合纯小白操作

:: 设置颜色输出
set "GREEN=[92m"
set "YELLOW=[93m"
set "RED=[91m"
set "BLUE=[94m"
set "NC=[0m"

:: 显示欢迎信息
cls
echo %BLUE%=================================================%NC%
echo %BLUE%       Kirara Agent Windows一键部署脚本%NC%
echo %BLUE%=================================================%NC%
echo.

:: 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo %RED%请以管理员身份运行此脚本%NC%
    echo %YELLOW%请右键点击此脚本，选择"以管理员身份运行"%NC%
    pause
    exit /b 1
)

:: 检查PowerShell是否可用
powershell -Command "Write-Host 'PowerShell可用'" >nul 2>&1
if %errorLevel% neq 0 (
    echo %RED%PowerShell不可用，请确保您的系统支持PowerShell%NC%
    pause
    exit /b 1
)

:: 检查Git是否安装
git --version >nul 2>&1
if %errorLevel% neq 0 (
    echo %RED%Git未安装，请先安装Git%NC%
    echo %YELLOW%您可以从 https://git-scm.com/downloads 下载安装%NC%
    pause
    exit /b 1
)

:: 创建临时目录
set "TMP_DIR=%TEMP%\docker-kirara-agent"
rmdir /s /q "%TMP_DIR%" 2>nul
mkdir "%TMP_DIR%"

:: 克隆仓库
echo %GREEN%正在克隆Kirara Agent仓库...%NC%
git clone https://github.com/user/docker-kirara-agent.git "%TMP_DIR%"
if %errorLevel% neq 0 (
    echo %RED%克隆仓库失败，请检查网络连接或仓库URL%NC%
    pause
    exit /b 1
)

:: 进入项目目录
cd /d "%TMP_DIR%"

:: 执行安装脚本
echo %GREEN%开始安装Kirara Agent...%NC%
call install.bat

:: 清理临时文件
rmdir /s /q "%TMP_DIR%"

echo %BLUE%=================================================%NC%
echo %BLUE%       Kirara Agent 部署完成%NC%
echo %BLUE%=================================================%NC%
pause
