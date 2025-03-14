@echo off

echo 正在启动Kirara Agent服务...
docker-compose up -d

echo %date% %time% [info] Kirara Agent服务已启动 >> service.log

echo 服务已启动，访问 http://localhost:8080 查看服务状态