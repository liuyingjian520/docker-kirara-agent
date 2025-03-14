module.exports = {
  // 服务配置
  server: {
    port: process.env.PORT || 8080,
    logLevel: process.env.LOG_LEVEL || 'info'
  },
  
  // 代理配置
  proxy: {
    timeout: 30000, // 请求超时时间（毫秒）
    retries: 3,     // 重试次数
    cacheEnabled: true // 是否启用缓存
  },
  
  // 安全配置
  security: {
    rateLimiting: true, // 是否启用速率限制
    maxRequests: 100,   // 每分钟最大请求数
    corsEnabled: true   // 是否启用CORS
  }
};