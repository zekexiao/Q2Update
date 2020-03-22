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

read -p "是否继续下载(是(Y)/否(N)): " yn
if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
    echo "开始下载..."
    rm Qv2ray.AppImage
    curl --silent "https://api.github.com/repos/Qv2ray/Qv2ray/releases/latest" | 
        jq -r ".assets[] | select(.name | contains(\"AppImage\")) | .browser_download_url" |
        wget -q --show-progress -O Qv2ray.AppImage -i -
    chmod +x Qv2ray.AppImage
else
    exit 1
fi

echo "Local Qv2ray Version:"
./Qv2ray.AppImage -v

echo "Run ./Qv2ray.AppImage to boot Qv2ray"
