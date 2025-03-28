@echo off
setlocal enabledelayedexpansion

:: Kirara Agent Windows自动安装脚本
:: 支持自动检测系统环境、自动安装Docker和Docker Compose

:: 设置颜色输出
set "GREEN=[92m"
set "YELLOW=[93m"
set "RED=[91m"
set "BLUE=[94m"
set "NC=[0m"

:: 创建日志文件
set "LOG_FILE=kirara-install.log"
echo Kirara Agent 安装日志 > %LOG_FILE%
echo 安装时间: %date% %time% >> %LOG_FILE%
echo. >> %LOG_FILE%

:: 日志函数
:log
echo %GREEN%%date% %time% [INFO]%NC% %~1
echo %date% %time% [INFO] %~1 >> %LOG_FILE%
goto :eof

:log_warn
echo %YELLOW%%date% %time% [WARN]%NC% %~1
echo %date% %time% [WARN] %~1 >> %LOG_FILE%
goto :eof

:log_error
echo %RED%%date% %time% [ERROR]%NC% %~1
echo %date% %time% [ERROR] %~1 >> %LOG_FILE%
goto :eof

:log_success
echo %BLUE%%date% %time% [SUCCESS]%NC% %~1
echo %date% %time% [SUCCESS] %~1 >> %LOG_FILE%
goto :eof

:: 主程序
cls
echo %BLUE%=================================================%NC%
echo %BLUE%       Kirara Agent Windows自动安装脚本%NC%
echo %BLUE%       适合小白用户的简易安装方式%NC%
echo %BLUE%=================================================%NC%
echo.

:: 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    call :log_error "请以管理员身份运行此脚本"
    call :log