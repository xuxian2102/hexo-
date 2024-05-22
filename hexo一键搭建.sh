#!/bin/bash
# 定义颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # 没有颜色

echo -e "${YELLOW}请使用 'sudo ./your_script.sh' 命令来运行此脚本以确保有足够的权限。${NC}"

# 检查是否以 root 权限运行
if [ "$(id -u)" != "0" ]; then
   echo -e "${RED}此脚本必须以 root 权限运行${NC}" 1>&2
   exit 1
fi

echo -e "${GREEN}开始搭建环境...${NC}"

echo "安装前置软件..."

# 检查 Git 是否已安装
if ! command -v git &>/dev/null; then
    echo -e "${YELLOW}Git 未安装，正在尝试安装...${NC}"
    sudo apt-get update && sudo apt-get install git -y
    if [ $? -ne 0 ]; then
        echo -e "${RED}Git 安装失败，请手动安装。${NC}"
        exit 1
    fi
    echo -e "${GREEN}Git 安装成功。${NC}"
else
    echo -e "${GREEN}已安装 Git，版本为: $(git --version)${NC}"
fi

# 安装 Curl
sudo apt-get install -y curl

# 安装 Node.js
if ! command -v node &>/dev/null; then
    echo -e "${YELLOW}Node.js 未安装，正在尝试安装...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_22.x -o nodesource_setup.sh
    sudo -E bash nodesource_setup.sh
    sudo apt-get install -y nodejs
    rm -f nodesource_setup.sh
    echo -e "${GREEN}Node.js 已安装，版本为: $(node -v)${NC}"
else
    echo -e "${GREEN}Node.js 已安装，版本为: $(node -v)${NC}"
fi

echo "正在检查 npm 版本并更新..."
current_npm_version=$(npm -v)
echo "当前 npm 版本: $current_npm_version"

echo "更新 npm 到最新版本..."
sudo npm install -g npm@latest

new_npm_version=$(npm -v)
echo "更新后的 npm 版本: $new_npm_version"

echo "创建新目录 ~/hexosite/"
mkdir -p ~/hexosite/
cd ~/hexosite/

echo "安装 Hexo..."
npm install -g hexo-cli

echo "初始化 Hexo 环境..."
hexo init ~/hexosite/

echo -e "${GREEN}Hexo 环境部署完毕，目录：~/hexosite/${NC}"
