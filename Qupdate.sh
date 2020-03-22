#!/bin/bash

workdir=$(pwd)
echo "正在获取信息..."
echo "最新版本: "
curl --silent "https://api.github.com/repos/Qv2ray/Qv2ray/releases/latest" | 
    grep '"tag_name":'

echo "本地版本: "
if [ ! -f "Qv2ray.AppImage" ];then
echo "无本地版本"
else
./Qv2ray.AppImage -v | grep '\[Qv2ray\]'
fi

mkdir backup 2>/dev/null

read -p "是否继续下载Qv2ray (是(Y)/否(N)): " yn
if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
    echo "-------------- Qv2ray ----------------"
    if [ -f "${workdir}/Qv2ray.AppImage" ];then
    echo "备份并删除旧文件..."
    rm backup/Qv2ray.AppImage > /dev/null
    mv Qv2ray.AppImage backup/Qv2ray.AppImage > /dev/null
    fi 

    echo "下载中..."
    curl --silent "https://api.github.com/repos/Qv2ray/Qv2ray/releases/latest" | 
        jq -r ".assets[] | select(.name | contains(\"AppImage\")) | .browser_download_url" |
        wget -q --show-progress -O Qv2ray.AppImage -i -
    chmod +x Qv2ray.AppImage
    echo "Local Qv2ray Version:"
    ./Qv2ray.AppImage -v | grep '\[Qv2ray\]'
fi

read -p "是否需要下载v2ray core (Linux-64bit only)？(是(Y)/否(N))" vyn
if [ "$vyn" == "Y" ] || [ "$vyn" == "y" ]; then
    echo "-------------- v2ray-core ----------------"
    if [ -d "${workdir}/v2ray-core/" ];then
       echo "备份并删除旧文件..."
       rm backup/v2ray-core -rf > /dev/null
       mv v2ray-core backup/v2ray-core > /dev/null
    fi 

    echo "下载中..."
    curl --silent "https://api.github.com/repos/v2ray/v2ray-core/releases/latest" | 
        jq -r ".assets[] | select(.name | contains(\"v2ray-linux-64.zip\")) | .browser_download_url" |
        wget -q --show-progress -O /tmp/v2ray-linux-64.zip -i -
    echo "正在解压 v2ray-core"
    unzip /tmp/v2ray-linux-64.zip -d v2ray-core -o > /dev/null 2>&1
    echo "v2ray-core 路径: " && echo ${workdir}/v2ray-core
fi

echo "-------------- Finish  ----------------"
echo "Run ./Qv2ray.AppImage to boot Qv2ray"

read -p "直接打开？(是(Y)/否(N))" oyn
if [ "$oyn" == "Y" ] || [ "$oyn" == "y" ]; then
    ./Qv2ray.AppImage
else 
    exit 0
fi
