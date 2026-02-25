#!/bin/bash
# MiniAdmin 数据库 Shell 脚本
# Description: 连接到 PostgreSQL 数据库 shell

set -e

# 颜色定义
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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
echo -e "${BLUE}    连接到 PostgreSQL Shell${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 检查 PostgreSQL 容器是否运行
if ! docker ps | grep -q miniadmin-postgres; then
    echo -e "${YELLOW}PostgreSQL 容器未运行${NC}"
    echo -e "${YELLOW}请先启动服务: ./bin/start.sh${NC}"
    exit 1
fi

echo -e "${GREEN}连接到数据库: ${DB_NAME}${NC}"
echo -e "${YELLOW}输入 \\q 退出${NC}"
echo ""

docker exec -it miniadmin-postgres psql -U ${DB_USER} -d ${DB_NAME}
