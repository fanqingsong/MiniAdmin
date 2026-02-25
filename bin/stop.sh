#!/bin/bash
# MiniAdmin 一键停止脚本
# Description: 停止 MiniAdmin 服务

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目根目录
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}    MiniAdmin 服务停止脚本${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 检查是否有运行中的容器
RUNNING_CONTAINERS=$(docker compose ps -q 2>/dev/null | wc -l)

if [ "$RUNNING_CONTAINERS" -eq 0 ]; then
    echo -e "${YELLOW}没有运行中的 MiniAdmin 服务${NC}"
    exit 0
fi

echo -e "${GREEN}[1/2] 当前运行的服务:${NC}"
docker compose ps
echo ""

echo -e "${GREEN}[2/2] 停止服务...${NC}"
docker compose down

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✓ MiniAdmin 服务已停止${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "${YELLOW}使用 './bin/start.sh' 重新启动服务${NC}"
echo -e "${YELLOW}使用 './bin/clean.sh' 清理数据卷${NC}"
echo ""
