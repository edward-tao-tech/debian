#!/bin/bash
set -e

# 如果设置了 SSH_PASSWORD 环境变量，则修改 root 密码
if [ -n "$SSH_PASSWORD" ]; then
    echo "root:$SSH_PASSWORD" | chpasswd
    echo "Root password has been updated."
else
    # 默认密码（如果不设置环境变量）
    echo "root:debian" | chpasswd
    echo "No SSH_PASSWORD env found, using default password: debian"
fi

# 哪吒 Agent 启动逻辑
# 检查是否提供了必要的哪吒参数
if [ -n "$NZ_SERVER" ] && [ -n "$NZ_CLIENT_SECRET" ]; then
    echo "Installing Nezha Agent..."
    curl -L https://raw.githubusercontent.com/nezhahq/scripts/main/agent/install.sh -o agent.sh && chmod +x agent.sh
    
    # 根据是否有 NZ_TLS 环境变量来决定执行命令
    if [ "$NZ_TLS" = "true" ]; then
        echo "Starting Agent with TLS..."
        env NZ_SERVER="$NZ_SERVER" NZ_TLS=true NZ_CLIENT_SECRET="$NZ_CLIENT_SECRET" ./agent.sh install_run &
    else
        echo "Starting Agent without TLS..."
        env NZ_SERVER="$NZ_SERVER" NZ_CLIENT_SECRET="$NZ_CLIENT_SECRET" ./agent.sh install_run &
    fi
    echo "Nezha Agent is running in background."
fi

# 启动 SSH 服务
exec /usr/sbin/sshd -D