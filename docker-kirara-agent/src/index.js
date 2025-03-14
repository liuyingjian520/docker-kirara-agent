const express = require('express');
const dotenv = require('dotenv');
const cors = require('cors');
const config = require('../config/config');
const path = require('path');

// 加载环境变量
dotenv.config();

const app = express();
const PORT = process.env.PORT || 8080;

// 中间件
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors()); // 启用CORS中间件

// 静态文件服务
app.use(express.static(path.join(__dirname, 'public')));

// 基本路由
app.get('/', (req, res) => {
  res.json({ 
    message: 'Kirara Agent服务正在运行',
    version: require('../package.json').version,
    documentation: '/docs'
  });
});

// 文档路由
app.get('/docs', (req, res) => {
  res.json({
    description: 'Kirara Agent API 文档',
    endpoints: {
      '/': 'API根路径，返回服务状态',
      '/api/status': '获取代理状态',
      '/api/health': '健康检查端点',
      '/api/config': '代理配置接口',
      '/api/proxy': '代理服务接口'
    }
  });
});

// API路由
app.use('/api', require('./routes/api'));

// 错误处理中间件
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: '服务器内部错误', message: err.message });
});

// 启动服务器
app.listen(PORT, () => {
  console.log(`Kirara Agent服务已启动，监听端口: ${PORT}`);
  console.log(`日志级别: ${process.env.LOG_LEVEL || 'info'}`);
  console.log(`访问 http://localhost:${PORT} 查看服务状态`);
});