#!/bin/bash
# MiniAdmin 数据库备份脚本
# Description: 备份 PostgreSQL 数据库

set -e

# 颜色定义
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 项目根目录
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

# 加载环境变量
if [ -f .env ]; then
    source .env
else
    DB_NAME="miniadmin"
    DB_USER="miniadmin"
fi

# 创建备份目录
BACKUP_DIR="$PROJECT_ROOT/backups"
mkdir -p "$BACKUP_DIR"

# 生成备份文件名
BACKUP_FILE="$BACKUP_DIR/miniadmin_$(date +%Y%m%d_%H%M%S).sql"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}    MiniAdmin 数据库备份${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 检查 PostgreSQL 容器是否运行
if ! docker ps | grep -q miniadmin-postgres; then
    echo -e "${RED}PostgreSQL 容器未运行${NC}"
    echo -e "${YELLOW}请先启动服务: ./bin/start.sh${NC}"
    exit 1
fi

echo -e "${GREEN}正在备份数据库...${NC}"
docker exec miniadmin-postgres pg_dump -U ${DB_USER} ${DB_NAME} > "$BACKUP_FILE"

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✓ 备份完成${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}备份文件: ${BACKUP_FILE}${NC}"
echo ""
