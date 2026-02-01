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

# 启动 SSH 服务
exec /usr/sbin/sshd -D