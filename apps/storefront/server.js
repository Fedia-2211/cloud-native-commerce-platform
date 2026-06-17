const express = require('express');
const fetch = require('node-fetch');
const app = express();

const API_URL = 'https://api.samadov.xyz/graphql/';

app.get('/', async (req, res) => {
  try {
    const response = await fetch(API_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        query: `{
          shop { name description }
          products(first: 6, channel: "default-channel") {
            edges {
              node {
                id name
                thumbnail { url }
                pricing {
                  priceRange {
                    start { gross { amount currency } }
                  }
                }
              }
            }
          }
        }`
      })
    });
    const data = await response.json();
    const shop = data.data?.shop || {};
    const products = data.data?.products?.edges || [];

    res.send(`<!DOCTYPE html>
<html>
<head>
  <title>${shop.name || 'Saleor Store'}</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; background: #f8f8f8; }
    header { background: #1a1a2e; color: white; padding: 20px 40px; display: flex; justify-content: space-between; align-items: center; }
    header h1 { font-size: 1.8rem; font-weight: 700; }
    header span { font-size: 0.9rem; opacity: 0.7; }
    .hero { background: linear-gradient(135deg, #16213e, #0f3460); color: white; padding: 60px 40px; text-align: center; }
    .hero h2 { font-size: 2.5rem; margin-bottom: 16px; }
    .hero p { font-size: 1.1rem; opacity: 0.8; margin-bottom: 30px; }
    .badge { display: inline-block; background: rgba(255,255,255,0.15); border: 1px solid rgba(255,255,255,0.3); padding: 6px 16px; border-radius: 20px; font-size: 0.8rem; margin: 4px; }
    .container { max-width: 1200px; margin: 0 auto; padding: 40px 20px; }
    .section-title { font-size: 1.5rem; font-weight: 600; margin-bottom: 24px; color: #1a1a2e; }
    .products { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 24px; }
    .product-card { background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.08); transition: transform 0.2s, box-shadow 0.2s; }
    .product-card:hover { transform: translateY(-4px); box-shadow: 0 8px 24px rgba(0,0,0,0.12); }
    .product-img { width: 100%; height: 200px; object-fit: cover; background: #e8e8e8; display: flex; align-items: center; justify-content: center; color: #999; font-size: 0.9rem; }
    .product-img img { width: 100%; height: 100%; object-fit: cover; }
    .product-info { padding: 16px; }
    .product-name { font-weight: 600; font-size: 1rem; color: #1a1a2e; margin-bottom: 8px; }
    .product-price { color: #e94560; font-weight: 700; font-size: 1.1rem; }
    .no-products { text-align: center; padding: 60px; color: #666; }
    .api-status { background: white; border-radius: 12px; padding: 20px; margin-bottom: 30px; border-left: 4px solid #00b09b; }
    .api-status h3 { color: #00b09b; margin-bottom: 8px; }
    .stack-badges { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 8px; }
    .stack-badge { background: #f0f0f0; padding: 4px 12px; border-radius: 20px; font-size: 0.8rem; color: #444; }
    footer { text-align: center; padding: 30px; color: #666; font-size: 0.85rem; background: #1a1a2e; color: rgba(255,255,255,0.5); margin-top: 60px; }
  </style>
</head>
<body>
  <header>
    <h1>🛍️ ${shop.name || 'Commerce Platform'}</h1>
    <span>cloud-native-commerce-platform.samadov.xyz</span>
  </header>

  <div class="hero">
    <h2>Production-grade E-Commerce</h2>
    <p>${shop.description || 'Built on Kubernetes with GitOps, autoscaling, and observability'}</p>
    <div>
      <span class="badge">⚡ Saleor 3.20 GraphQL API</span>
      <span class="badge">☸️ Kubernetes + ArgoCD</span>
      <span class="badge">📈 HPA + KEDA Autoscaling</span>
      <span class="badge">🔒 AWS RDS Postgres</span>
    </div>
  </div>

  <div class="container">
    <div class="api-status">
      <h3>✅ Live API Connection</h3>
      <p>Connected to Saleor GraphQL API at <strong>api.samadov.xyz/graphql/</strong></p>
      <div class="stack-badges">
        <span class="stack-badge">AWS EC2 k3s</span>
        <span class="stack-badge">RDS Postgres 15</span>
        <span class="stack-badge">Redis Cache</span>
        <span class="stack-badge">Celery Workers</span>
        <span class="stack-badge">NGINX Ingress</span>
        <span class="stack-badge">cert-manager TLS</span>
        <span class="stack-badge">Prometheus + Grafana</span>
      </div>
    </div>

    <h2 class="section-title">Featured Products</h2>
    ${products.length > 0 ? `
    <div class="products">
      ${products.map(({node}) => `
        <div class="product-card">
          <div class="product-img">
            ${node.thumbnail ? `<img src="${node.thumbnail.url}" alt="${node.name}">` : '<span>No image</span>'}
          </div>
          <div class="product-info">
            <div class="product-name">${node.name}</div>
            <div class="product-price">
              ${node.pricing?.priceRange?.start?.gross ?
                `${node.pricing.priceRange.start.gross.currency} ${node.pricing.priceRange.start.gross.amount.toFixed(2)}` :
                'Price on request'}
            </div>
          </div>
        </div>
      `).join('')}
    </div>` : `
    <div class="no-products">
      <p>🏪 Store is ready — add products via the <a href="https://dashboard.samadov.xyz">admin dashboard</a></p>
    </div>`}
  </div>

  <footer>
    <p>cloud-native-commerce-platform | Built with Saleor Commerce | Deployed on AWS Kubernetes</p>
    <p style="margin-top:8px">Firdavs Samadov — DevOps & Cloud Engineering Portfolio</p>
  </footer>
</body>
</html>`);
  } catch (err) {
    res.status(500).send(`<h1>Error connecting to API</h1><p>${err.message}</p>`);
  }
});

app.get('/health', (req, res) => res.json({ status: 'ok' }));

app.listen(3000, () => console.log('Shop frontend running on port 3000'));
// version: 1781687811
