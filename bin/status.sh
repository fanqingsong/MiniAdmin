#!/bin/bash
# MiniAdmin 状态查看脚本
# Description: 查看 MiniAdmin 服务状态

# 颜色定义
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 项目根目录
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}    MiniAdmin 服务状态${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 检查容器状态
CONTAINERS=$(docker compose ps -a 2>/dev/null)

if [ -z "$CONTAINERS" ] || [ $(echo "$CONTAINERS" | wc -l) -eq 1 ]; then
    echo -e "${YELLOW}未找到 MiniAdmin 容器${NC}"
    echo ""
    echo -e "${YELLOW}使用 './bin/start.sh' 启动服务${NC}"
    exit 0
fi

echo -e "${GREEN}容器状态:${NC}"
docker compose ps
echo ""

# 检查服务健康状态
echo -e "${GREEN}健康检查:${NC}"
BACKEND_STATUS=$(docker inspect miniadmin-backend 2>/dev/null | jq -r '.[0].State.Health.Status // "无健康检查"' 2>/dev/null || echo "未知")
FRONTEND_STATUS=$(docker inspect miniadmin-frontend 2>/dev/null | jq -r '.[0].State.Status // "未知"' 2>/dev/null || echo "未知")

echo -e "后端服务: ${BACKEND_STATUS}"
echo -e "前端服务: ${FRONTEND_STATUS}"
echo ""

# 检查端口占用
echo -e "${GREEN}端口检查:${NC}"
if command -v netstat &> /dev/null; then
    echo "端口 80 (前端): $(netstat -tuln 2>/dev/null | grep ':80 ' || echo '未监听')"
    echo "端口 8000 (后端): $(netstat -tuln 2>/dev/null | grep ':8000 ' || echo '未监听')"
elif command -v ss &> /dev/null; then
    echo "端口 80 (前端): $(ss -tuln 2>/dev/null | grep ':80 ' || echo '未监听')"
    echo "端口 8000 (后端): $(ss -tuln 2>/dev/null | grep ':8000 ' || echo '未监听')"
fi
echo ""

# 资源使用
echo -e "${GREEN}资源使用:${NC}"
docker stats --no-stream miniadmin-backend miniadmin-frontend 2>/dev/null || echo "无法获取资源使用信息"
echo ""
