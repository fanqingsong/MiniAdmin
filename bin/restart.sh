#!/bin/bash
# MiniAdmin 一键重启脚本
# Description: 重启 MiniAdmin 服务

set -e

# 颜色定义
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# 项目根目录
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}    MiniAdmin 服务重启${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

echo -e "${GREEN}[1/2] 停止服务...${NC}"
./bin/stop.sh

echo ""
echo -e "${GREEN}[2/2] 启动服务...${NC}"
./bin/start.sh
