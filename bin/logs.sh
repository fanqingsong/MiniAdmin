#!/bin/bash
# MiniAdmin 日志查看脚本
# Description: 查看 MiniAdmin 服务日志

# 颜色定义
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 项目根目录
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}    MiniAdmin 服务日志${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 检查参数
if [ "$1" == "-f" ] || [ "$1" == "--follow" ]; then
    echo -e "${GREEN}实时跟踪日志（按 Ctrl+C 退出）...${NC}"
    echo ""
    docker compose logs -f
else
    echo -e "${YELLOW}显示最近的日志${NC}"
    echo -e "${YELLOW}使用 './bin/logs.sh -f' 实时跟踪日志${NC}"
    echo ""
    docker compose logs --tail=100
fi
