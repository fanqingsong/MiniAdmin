## Mini Admin

Mini Admin,一个简洁轻快的后台管理框架.支持拥有多用户组的RBAC管理后台 🚀

应用场景：2-5人的管理团队，需要管理的资源数目10个或是更少，如果想有一个简单轻快直接的后台管理，下载下来就可以使用，
不要配置各种运行环境，不要搭建各种服务器端的主机配置，就是想拿来就用！ 那么你就试试咱的MiniAdmin。

### 更新

- 2023-03-04 更新一处权限数据组装错误
- 2025-02-25 添加 Docker Compose 支持，提供一键启停脚本
- 2025-02-25 数据库从 SQLite 迁移到 PostgreSQL

### 安装

#### 方式一：Docker 部署（推荐）

使用 Docker Compose 可以快速部署整个项目，无需手动配置环境。

**前置要求：**
- Docker
- Docker Compose

**一键启动：**

```bash
# 启动所有服务
./bin/start.sh
```

启动后访问：
- 前端地址：http://localhost
- 后端API文档：http://localhost:8000/docs
- 默认账号：`miniadmin` / `123456`

**管理命令：**

```bash
# 停止服务
./bin/stop.sh

# 重启服务
./bin/restart.sh

# 查看服务状态
./bin/status.sh

# 查看日志
./bin/logs.sh

# 实时跟踪日志
./bin/logs.sh -f

# 清理所有容器和数据（慎用！）
./bin/clean.sh
```

**数据库管理：**

```bash
# 连接到 PostgreSQL Shell
./bin/db-shell.sh

# 备份数据库
./bin/db-backup.sh

# 恢复数据库
./bin/db-restore.sh <backup-file>
```

**配置说明：**

数据库配置通过环境变量管理，可在 `.env` 文件中修改：

```bash
# .env 文件配置
DB_TYPE=postgresql          # 数据库类型
DB_HOST=postgres            # 数据库主机
DB_PORT=5432                # 数据库端口
DB_NAME=miniadmin           # 数据库名称
DB_USER=miniadmin           # 数据库用户
DB_PASSWORD=miniadmin123    # 数据库密码
```

#### 方式二：本地开发

Git克隆或是下载压缩包。

终端进入程序的根目录：

    pip install -r requirements.txt

然后：

    cd backend
    python main.py

![](img/01.png)

Uvicorn running on http://127.0.0.1:8000 (Press CTRL+C to quit)

初始的管理员：miniadmin 123456


效果图：

![](img/04.png)
![](img/03.png)
![](img/02.png)


### 项目结构

```
MiniAdmin/
├── backend/           # 后端目录 (FastAPI + Python)
│   ├── api_v1.py      # API 路由
│   ├── main.py        # 主程序入口
│   ├── database.py    # 数据库配置
│   ├── models.py      # 数据模型
│   ├── crud.py        # CRUD 操作
│   └── Dockerfile     # 后端 Docker 配置
├── frontend/          # 前端目录 (Vue 3 + Vite)
│   ├── src/           # 源代码
│   ├── Dockerfile     # 前端 Docker 配置
│   └── nginx.conf     # Nginx 配置
├── bin/               # 管理脚本目录
│   ├── start.sh       # 启动脚本
│   ├── stop.sh        # 停止脚本
│   ├── restart.sh     # 重启脚本
│   ├── status.sh      # 状态查看
│   ├── logs.sh        # 日志查看
│   ├── clean.sh       # 清理脚本
│   ├── db-shell.sh    # 数据库 Shell
│   ├── db-backup.sh   # 数据库备份
│   └── db-restore.sh  # 数据库恢复
├── .env               # 环境变量配置
├── .env.example       # 环境变量示例
└── docker-compose.yml # Docker Compose 配置
```

### 技术栈

**后端依赖：**

    casbin==1.17.4
    casbin_sqlalchemy_adapter==0.5.0
    fastapi==0.88.0
    jose==1.0.0
    loguru==0.6.0
    passlib==1.7.4
    pydantic==1.10.2
    pytest==7.1.2
    python_jose==3.3.0
    SQLAlchemy==1.4.39
    uvicorn==0.20.0
    bcrypt==4.0.1
    python-multipart==0.0.5
    psycopg2-binary==2.9.9

**前端依赖：**

    "ant-design-vue": "^3.2.15",
    "axios": "^1.2.0",
    "vue": "^3.2.45",
    "vue-router": "^4.1.6",
    "vite": "^3.2.4"

**运行环境：**

- Python 3.10+
- Node.js 18+
- PostgreSQL 15 (生产环境)
- Nginx (生产环境)

**数据持久化：**

项目使用 PostgreSQL 数据库存储数据，通过 Docker Volume 持久化：
- `postgres-data`: PostgreSQL 数据目录
- 数据备份文件存储在 `backups/` 目录


### 数据库ER图：
![](img/05.png)

后台的安全校验是基于Casbin(一个支持如ACL, RBAC, ABAC等访问模型)的授权库。
支持拥有多用户组的RBAC管理。具体可以登陆后台管理系统进行体验。
理论上来说，稍加修改代码可以支持更多的访问模型
https://docs.casbin.cn/zh/docs/supported-models


### 感谢！

https://docs.casbin.cn/zh/

https://fastapi.tiangolo.com/zh/

https://cn.vuejs.org/

https://www.antdv.com/docs/vue/introduce-cn

https://www.axios-http.cn/docs/intro



提出您的宝贵意见，程序刚刚跑起来问题难免，欢迎issue！