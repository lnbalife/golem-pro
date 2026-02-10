# Golem Network Provider Docker Image
# ⚠️ 只支持 x86-64 架构！不支持 ARM (Apple Silicon)
# ARM 用户请使用 CI/CD 或云服务器构建

FROM --platform=linux/amd64 ubuntu:22.04

LABEL maintainer="your-email@example.com"
LABEL description="Golem Network Provider Node"
LABEL version="1.0"

# 安装依赖
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# 安装 Golem Provider (仅 x86-64)
RUN curl -sSf https://join.golem.network/as-provider | bash - \
    && echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

# 创建非 root 用户
RUN useradd -m -s /bin/bash provider && \
    echo "provider ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

WORKDIR /home/provider

# 暴露 UDP 端口 11500
EXPOSE 11500/udp

# 环境变量
ENV GLM_PRICING_PER_HOUR=0.1
ENV NETWORK=mainnet

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD golemsp status | grep -q "Service is running" || exit 1

# 启动脚本
COPY start-provider.sh /usr/local/bin/start-provider.sh
RUN chmod +x /usr/local/bin/start-provider.sh

ENTRYPOINT ["/usr/local/bin/start-provider.sh"]
