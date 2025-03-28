/**
 * Kirara Agent 服务入口文件
 */

const express = require('express');
const app = express();
const port = process.env.PORT || 8080;

// 中间件
app.use(express.json());
app.use(express.static('public'));

// 路由
app.get('/', (req, res) => {
  res.send('Kirara Agent 服务正在运行');
});

app.get('/status', (req, res) => {
  res.json({
    status: 'running',
    version: '1.0.0',
    timestamp: new Date().toISOString()
  });
});

// 启动服务器
app.listen(port, () => {
  console.log(`Kirara Agent 服务已启动，监听端口: ${port}`);
});
