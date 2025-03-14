FROM lss233/kirara-agent-framework:latest

LABEL maintainer="liuyingjian520"

# 设置工作目录
WORKDIR /app

# 设置时区
ENV TZ=Asia/Shanghai

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:8080/api/health || exit 1

# 复制依赖文件并安装
COPY package*.json ./
RUN npm install

# 复制源代码
COPY src/ ./src/
COPY config/ ./config/

# 暴露端口
EXPOSE 8080

# 启动命令
CMD ["node", "src/index.js"]