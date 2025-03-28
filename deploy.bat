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

:: 下载安装脚本
echo %GREEN%正在下载Kirara Agent安装脚本...%NC%
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/user/docker-kirara-agent/main/install.bat' -OutFile '%TEMP%\install.bat'"

if %errorLevel% neq 0 (
    echo %RED%下载安装脚本失败，请检查网络连接%NC%
    pause
    exit /b 1
)

:: 执行安装脚本
echo %GREEN%开始安装Kirara Agent...%NC%
call %TEMP%\install.bat

:: 清理临时文件
del /f /q %TEMP%\install.bat >nul 2>&1

echo %BLUE%=================================================%NC%
echo %BLUE%       Kirara Agent 部署完成%NC%
echo %BLUE%=================================================%NC%
pause