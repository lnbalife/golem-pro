# Golem Provider Docker 部署指南

## ⚠️ 重要：架构要求

**Golem Provider 官方只支持 x86-64 架构！**

你的 Mac mini (ARM) 需要使用 QEMU 模拟 x86-64，性能会下降。

### 推荐方案

#### 方案 1：使用 GitHub Actions 构建（推荐）
```bash
docker buildx create --use --name multi-platform --platform linux/amd64,linux/arm64
docker buildx build --platform linux/amd64 -t golem-provider:latest --push .
```

#### 方案 2：在云服务器上构建（性能最佳）
在 x86-64 Linux 服务器上直接构建后传输到 Mac mini。

## 快速开始（x86-64 服务器）

```bash
cd golem-provider
docker build -t golem-provider:latest .
docker-compose up -d
docker exec golem-provider golemsp status
```

## 文件结构
```
golem-provider/
├── Dockerfile
├── docker-compose.yml
├── start-provider.sh
└── README.md
```

## 端口要求
- **UDP 11500**: Yagna 服务通信端口（必须开放）
- 建议配置路由器端口转发

## 资源要求
- 最低 4GB RAM
- 至少 20GB 磁盘空间
