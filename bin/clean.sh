#!/bin/bash
# MiniAdmin 清理脚本
# Description: 清理容器、镜像和数据卷

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

echo -e "${RED}========================================${NC}"
echo -e "${RED}    MiniAdmin 清理脚本${NC}"
echo -e "${RED}========================================${NC}"
echo ""

echo -e "${YELLOW}警告: 此操作将删除所有容器、镜像和数据卷！${NC}"
echo -e "${YELLOW}数据库中的所有数据将丢失！${NC}"
echo ""

read -p "确定要继续吗？(yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo -e "${GREEN}已取消清理操作${NC}"
    exit 0
fi

echo -e "${GREEN}[1/4] 停止并删除容器...${NC}"
docker compose down -v

echo ""
echo -e "${GREEN}[2/4] 删除镜像...${NC}"
docker images | grep miniadmin | awk '{print $3}' | xargs -r docker rmi -f 2>/dev/null || true

echo ""
echo -e "${GREEN}[3/4] 删除数据卷...${NC}"
docker volume ls | grep -E 'miniadmin|postgres' | awk '{print $2}' | xargs -r docker volume rm -f 2>/dev/null || true

echo ""
echo -e "${GREEN}[4/4] 清理构建缓存...${NC}"
docker builder prune -f

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✓ 清理完成${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
