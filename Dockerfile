FROM node:16-alpine

WORKDIR /app

# 创建必要的目录
RUN mkdir -p /app/src /app/config

# 复制源代码和配置文件
COPY src/ /app/src/
COPY config/ /app/config/

# 安装依赖
COPY package.json /app/
RUN npm install --production

# 设置环境变量
ENV PORT=8080
ENV LOG_LEVEL=info

# 暴露端口
EXPOSE 8080

# 启动命令
CMD ["node", "src/index.js"]

LABEL Name=kirara-agent Version=1.0.0
