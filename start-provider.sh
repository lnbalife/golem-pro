#!/bin/bash
# Golem Provider 启动脚本

set -e

# 检查是否为 root 用户运行
if [ "$EUID" -ne 0 ]; then
    echo "警告: 建议使用 root 权限运行以获得最佳性能"
fi

# 检查 Docker 环境
if ! command -v docker &> /dev/null; then
    echo "错误: 未检测到 Docker，请先安装 Docker"
    exit 1
fi

# 等待网络就绪
sleep 5

# 设置 PATH
export PATH="$HOME/.local/bin:$PATH"

# 检查并安装 Provider（如果尚未安装）
if ! command -v golemsp &> /dev/null; then
    echo "正在安装 Golem Provider..."
    curl -sSf https://join.golem.network/as-provider | bash -
fi

# 打印配置信息
echo "==================================="
echo "Golem Provider 配置:"
echo "网络: ${NETWORK:-mainnet}"
echo "价格: ${GLM_PRICING_PER_HOUR:-0.1} GLM/小时/线程"
echo "==================================="

# 启动 Provider
exec golemsp run
