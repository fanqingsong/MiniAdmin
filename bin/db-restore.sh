#!/bin/bash
# MiniAdmin 数据库恢复脚本
# Description: 从备份文件恢复 PostgreSQL 数据库

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

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}    MiniAdmin 数据库恢复${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 检查是否指定了备份文件
if [ -z "$1" ]; then
    echo -e "${YELLOW}可用的备份文件:${NC}"
    echo ""
    ls -lth backups/*.sql 2>/dev/null || echo "没有找到备份文件"
    echo ""
    echo -e "${YELLOW}使用方法: ./bin/db-restore.sh <backup-file>${NC}"
    exit 1
fi

BACKUP_FILE="$1"

# 检查备份文件是否存在
if [ ! -f "$BACKUP_FILE" ]; then
    # 尝试在 backups 目录中查找
    if [ -f "backups/$BACKUP_FILE" ]; then
        BACKUP_FILE="backups/$BACKUP_FILE"
    else
        echo -e "${RED}备份文件不存在: $BACKUP_FILE${NC}"
        exit 1
    fi
fi

# 检查 PostgreSQL 容器是否运行
if ! docker ps | grep -q miniadmin-postgres; then
    echo -e "${RED}PostgreSQL 容器未运行${NC}"
    echo -e "${YELLOW}请先启动服务: ./bin/start.sh${NC}"
    exit 1
fi

echo -e "${YELLOW}警告: 此操作将覆盖当前数据库！${NC}"
echo -e "${YELLOW}备份文件: $BACKUP_FILE${NC}"
echo ""
read -p "确定要继续吗？(yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo -e "${GREEN}已取消恢复操作${NC}"
    exit 0
fi

echo -e "${GREEN}正在恢复数据库...${NC}"
docker exec -i miniadmin-postgres psql -U ${DB_USER} ${DB_NAME} < "$BACKUP_FILE"

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✓ 恢复完成${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
