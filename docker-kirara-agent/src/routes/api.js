const express = require('express');
const router = express.Router();

// 获取代理状态
router.get('/status', (req, res) => {
  res.json({
    status: 'running',
    version: '1.0.0',
    uptime: process.uptime()
  });
});

// 健康检查端点
router.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

// 代理配置接口
router.post('/config', (req, res) => {
  // 这里可以添加配置更新逻辑
  res.json({ message: '配置已更新' });
});

// 代理服务接口
router.post('/proxy', (req, res) => {
  // 这里可以添加代理服务逻辑
  res.json({ message: '代理请求已处理' });
});

module.exports = router;