#!/bin/bash
# MiniAdmin 一键启动脚本
# Description: 使用 Docker Compose 启动 MiniAdmin 服务

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
echo -e "${BLUE}    MiniAdmin 服务启动脚本${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 检查 Docker 是否安装
if ! command -v docker &> /dev/null; then
    echo -e "${RED}错误: 未检测到 Docker，请先安装 Docker${NC}"
    exit 1
fi

# 检查 Docker Compose 是否可用
if ! docker compose version &> /dev/null; then
    echo -e "${RED}错误: Docker Compose 不可用${NC}"
    exit 1
fi

echo -e "${GREEN}[1/4] 检查环境...${NC}"
docker --version
docker compose version
echo ""

echo -e "${GREEN}[2/4] 清理旧容器（如果存在）...${NC}"
docker compose down 2>/dev/null || true
echo ""

echo -e "${GREEN}[3/4] 构建 Docker 镜像...${NC}"
docker compose build --no-cache
echo ""

echo -e "${GREEN}[4/4] 启动服务...${NC}"
docker compose up -d
echo ""

# 等待服务启动
echo -e "${YELLOW}等待服务启动...${NC}"
sleep 5

# 检查服务状态
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}    服务状态${NC}"
echo -e "${BLUE}========================================${NC}"
docker compose ps
echo ""

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✓ MiniAdmin 启动成功！${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}前端访问地址:${NC} http://localhost"
echo -e "${GREEN}后端API文档:${NC} http://localhost:8000/docs"
echo -e "${GREEN}默认账号:${NC} miniadmin / 123456"
echo ""
echo -e "${YELLOW}使用 './bin/stop.sh' 停止服务${NC}"
echo -e "${YELLOW}使用 './bin/logs.sh' 查看日志${NC}"
echo -e "${YELLOW}使用 'docker compose ps' 查看服务状态${NC}"
echo ""
