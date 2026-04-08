// OctoWork Service Worker - PWA 支持
// 修复版本：过滤非http请求，避免fetch错误
// 修复时间：2026-03-19 04:20 GMT+8
// 修复人：章鱼博士

self.addEventListener('install', (event) => {
  console.log('[SW] Service Worker 安装中...');
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  console.log('[SW] Service Worker 已激活');
  event.waitUntil(self.clients.claim());
});

self.addEventListener('fetch', (event) => {
  const url = event.request.url;
  
  // 跳过非http/https协议请求
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    console.log('[SW] 跳过非HTTP请求:', url);
    return; // 让浏览器直接处理
  }
  
  // 检查是否为跨域请求
  try {
    const requestUrl = new URL(url);
    const currentOrigin = self.location.origin;
    
    if (requestUrl.origin !== currentOrigin) {
      console.log('[SW] 跳过跨域请求:', url);
      return; // 让浏览器直接处理跨域请求，避免CORS错误
    }
    
    // 跳过对根路径的请求（页面加载）
    if (requestUrl.pathname === '/') {
      console.log('[SW] 跳过根路径请求:', url);
      return; // 让浏览器直接处理页面加载
    }
  } catch (e) {
    console.warn('[SW] URL解析失败:', url, e);
    return; // 解析失败也跳过
  }
  
  // 仅处理同源HTTP请求
  console.log('[SW] 处理同源请求:', url);
  
  // 使用更健壮的错误处理
  event.respondWith(
    fetch(event.request)
      .then(response => {
        if (!response.ok) {
          console.warn('[SW] 请求返回非200状态:', url, response.status);
        }
        return response;
      })
      .catch(error => {
        console.warn('[SW] 网络请求失败:', url, error.message);
        // 返回一个友好的错误页面，而不是抛出未捕获的异常
        return new Response(
          JSON.stringify({
            error: '网络请求失败',
            url: url,
            message: error.message
          }),
          {
            status: 503,
            statusText: 'Service Unavailable',
            headers: {
              'Content-Type': 'application/json; charset=utf-8'
            }
          }
        );
      })
  );
});

// 监听消息（用于更新通知）
self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'SKIP_WAITING') {
    self.skipWaiting();
  }
});

console.log('[SW] Service Worker 已加载 - 修复版本');