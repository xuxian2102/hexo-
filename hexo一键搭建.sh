#!/bin/bash
echo "请使用 'sudo ./your_script.sh' 命令来运行此脚本以确保有足够的权限。"

# 检查是否以 root 权限运行
if [ "$(id -u)" != "0" ]; then
   echo "此脚本必须以 root 权限运行" 1>&2
   exit 1
fi

echo "开始搭建环境..."

echo "安装前置软件..."

# 检查 Git 是否已安装
if ! command -v git &>/dev/null; then
    echo "Git 未安装，正在尝试安装..."
    sudo apt-get update && sudo apt-get install git -y
    if [ $? -ne 0 ]; then
        echo "Git 安装失败，请手动安装。"
        exit 1
    fi
    echo "Git 安装成功。"
else
    echo "已安装 Git，版本为: $(git --version)"
fi

# 安装 Curl
sudo apt-get install -y curl

# 安装 Node.js
if ! command -v node &>/dev/null; then
    echo "Node.js 未安装，正在尝试安装..."
    curl -fsSL https://deb.nodesource.com/setup_22.x -o nodesource_setup.sh
    sudo -E bash nodesource_setup.sh
    sudo apt-get install -y nodejs
    rm -f nodesource_setup.sh
    echo "Node.js 已安装，版本为: $(node -v)"
else
    echo "Node.js 已安装，版本为: $(node -v)"

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

echo "Hexo 环境部署完毕，目录：~/hexosite/"

