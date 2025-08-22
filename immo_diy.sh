#!/bin/bash
svn_export() {
	# 参数1是分支名, 参数2是子目录, 参数3是目标目录, 参数4仓库地址
 	echo -e "clone $4/$2 to $3"
	TMP_DIR="$(mktemp -d)" || exit 1
 	ORI_DIR="$PWD"
	[ -d "$3" ] || mkdir -p "$3"
	TGT_DIR="$(cd "$3"; pwd)"
	git clone --depth 1 -b "$1" "$4" "$TMP_DIR" >/dev/null 2>&1 && \
	cd "$TMP_DIR/$2" && rm -rf .git >/dev/null 2>&1 && \
	cp -af . "$TGT_DIR/" && cd "$ORI_DIR"
	rm -rf "$TMP_DIR"
}

#rm -rf package/libs/mbedtls

# 依赖和冲突：保留必要的 feeds/包源，注释掉不再需要的源/重复项以减少网络和仓库干扰
rm -rf ./feeds/packages/lang/golang
# 注：原脚本里先删除 openclash，再通过 svn_export 导入，这里保留 svn_export 导入，删除重复的 rm 操作以免误删
# rm -rf ./feeds/luci/applications/luci-app-openclash

# 如果你不再使用 luci-app-filebrowser，可注释掉相关删除/clone；当前 .config 中保留了 luci-app-alist，而非 luci-app-filebrowser
# rm -rf ./feeds/luci/applications/luci-app-filebrowser
#rm -rf ./feeds/packages/utils/filebrowser

# 保留 passwall 相关的导入（脚本后面会 svn_export 导入 passwall），但先移除已有的 feeds 中旧版以避免冲突
rm -rf ./feeds/luci/applications/luci-app-passwall
rm -rf ./feeds/packages/net/v2ray-geodata
# 保留 mosdns 源，脚本后面会 svn_export 导入 mosdns，先移除 feeds 中的旧目录以避免冲突
rm -rf ./feeds/packages/net/mosdns
rm -rf ./feeds/packages/net/speedtest-cli
rm -rf ./feeds/luci/applications/luci-app-unblockneteasemusic
# aria2 由后面 clone 提供，先移除 feeds 中旧目录
rm -rf ./feeds/packages/net/aria2
# 如果你不需要替换 argon 主题的旧源可保留或替换，脚本后续会 clone 新的 argon
rm -rf ./feeds/luci/themes/luci-theme-argon

# 下面是添加/恢复需要的第三方包源（保留为你最终保留的插件）
git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon feeds/luci/themes/luci-theme-argon
git clone --depth 1 https://github.com/danchexiaoyang/luci-app-kodexplorer package/luci-app-kodexplorer
git clone --depth 1 https://github.com/sbwml/feeds_packages_net_aria2 feeds/packages/net/aria2
git clone --depth 1 https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang
git clone --depth 1 https://github.com/zyqfork/luci-app-pushbot package/luci-app-pushbot
git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
git clone --depth 1 https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
git clone --depth 1 https://github.com/fw876/helloworld package/helloworld
git clone --depth 1 https://github.com/chenmozhijin/luci-app-adguardhome package/luci-app-adguardhome
git clone --depth 1 https://github.com/sbwml/luci-app-openlist package/luci-app-openlist

# 如果你不需要 openwrt-passwall-packages 的旧源，可改用 svn_export 导入新版（脚本后面会导入）
# git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall-packages

# 原脚本里有自建的 luci-app-filebrowser，这里判断是否需要：如果你不使用它，可注释此行
git clone --depth 1 https://github.com/OldCoding/luci-app-filebrowser package/luci-app-filebrowser

git clone --depth 1 https://github.com/sirpdboy/netspeedtest package/netspeedtest
# 以下两个可选插件，如果不需要可以注释掉
# git clone --depth 1 https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic package/luci-app-unblockneteasemusic
# git clone --depth 1 https://github.com/hudra0/luci-app-qosmate package/luci-app-qosmate
# git clone --depth 1 https://github.com/hudra0/qosmate package/qosmate

git clone --depth 1 https://github.com/kenzok78/luci-app-design-config package/luci-app-design-config

# 导入 wrtbwmon（保留）
svn_export "main" "wrtbwmon" "package/wrtbwmon" "https://github.com/gitbruc/openwrt-wrtbwmon"
svn_export "main" "luci-app-wrtbwmon" "package/luci-app-wrtbwmon" "https://github.com/gitbruc/openwrt-wrtbwmon"

# 导入 passwall2 与 passwall（保留）
svn_export "main" "luci-app-passwall2" "package/luci-app-passwall2" "https://github.com/xiaorouji/openwrt-passwall2"
svn_export "main" "luci-app-passwall" "package/luci-app-passwall" "https://github.com/xiaorouji/openwrt-passwall"

# 导入 OpenClash（保留）
svn_export "main" "luci-app-openclash" "package/luci-app-openclash" "https://github.com/vernesong/OpenClash"

# amlogic 面板（保留）
svn_export "main" "luci-app-amlogic" "package/luci-app-amlogic" "https://github.com/ophub/luci-app-amlogic"

# mosdns 及其依赖（保留）
svn_export "v5" "luci-app-mosdns" "package/luci-app-mosdns" "https://github.com/sbwml/luci-app-mosdns"
svn_export "v5" "mosdns" "package/mosdns" "https://github.com/sbwml/luci-app-mosdns"
svn_export "v5" "v2dat" "package/v2dat" "https://github.com/sbwml/luci-app-mosdns"

# lucky（可选，config.txt 中原来为 luci-app-lucky=n，但 workflow 之前可能有使用，视需要保留）
# 如果你不需要 lucky，可注释下一行
svn_export "main" "lucky" "package/lucky" "https://github.com/gdy666/luci-app-lucky"
# 如果不需要 luci-app-lucky，可注释下一行
svn_export "main" "luci-app-lucky" "package/luci-app-lucky" "https://github.com/gdy666/luci-app-lucky"

# design 主题（保留）
svn_export "openwrt-23.05" "themes/luci-theme-design" "package/luci-theme-design" "https://github.com/coolsnowwolf/luci"

svn_export "main" "easytier" "package/easytier" "https://github.com/EasyTier/luci-app-easytier"
svn_export "main" "luci-app-easytier" "package/luci-app-easytier" "https://github.com/EasyTier/luci-app-easytier"

# 删除 design 主题中的默认 uci 文件以避免覆盖（保留）
rm -rf package/luci-theme-design/root/etc/uci-defaults/30_luci-theme-design

# turboacc 补丁（如果需要可以取消注释）
#curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash -x add_turboacc.sh

# adguardhome 版本调整（如需）
#VER=$(grep PKG_VERSION package/luci-app-adguardhome/Makefile | sed 's/-/\./g')
#sed -i "s/PKG_VERSION:=.*/$VER/g" package/luci-app-adguardhome/Makefile

# 调整菜单位置
sed -i "s|services|nas|g" feeds/luci/applications/luci-app-qbittorrent/root/usr/share/luci/menu.d/luci-app-qbittorrent.json
sed -i "s|services|network|g" feeds/luci/applications/luci-app-nlbwmon/root/usr/share/luci/menu.d/luci-app-nlbwmon.json

# 微信推送&全能推送（保留）
sed -i "s|qidian|bilibili|g" package/luci-app-pushbot/root/usr/bin/pushbot/pushbot

# DNS劫持（保持已有修改）
sed -i '/dns_redirect/d' package/network/services/dnsmasq/files/dhcp.conf

# 个性化设置（保留）
sed -i "s/(\(luciversion || ''\))/(\1) + (' \/ Wing build $(TZ=UTC-8 date "+%Y.%m.%d")')/g" $(find ./feeds/luci/modules/luci-mod-status/ -type f -name "10_system.js")
sed -i "s|breakings|OldCoding|g" package/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|OpenWrt|openwrt_packit_arm|g" package/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|ARMv8|ARMv8-im|g" package/luci-app-amlogic/root/etc/config/amlogic

# 删除可能的重复或不需要的包翻译目录
rm -rf package/luci-app-netspeedtest/po/zh_Hans

cd package

# NTP服务器：将系统默认 NTP 改为 openwrt pool（保留）
sed -i "s|\'time1\.apple\.com\'|\'0\.openwrt\.pool\.ntp\.org\'|g" base-files/files/bin/config_generate
sed -i "s|\'time1\.google\.com\'|\'1\.openwrt\.pool\.ntp\.org\'|g" base-files/files/bin/config_generate
sed -i "s|\'time\.cloudflare\.com\'|\'2\.openwrt\.pool\.ntp\.org\'|g" base-files/files/bin/config_generate
sed -i "s|\'pool\.ntp\.org\'|\'3\.openwrt\.pool\.ntp\.org\'|g" base-files/files/bin/config_generate

# 汉化（保留）
curl -sfL -o ./convert_translation.sh https://github.com/kenzok8/small-package/raw/main/.github/diy/convert_translation.sh
chmod +x ./convert_translation.sh && bash ./convert_translation.sh

# OpenClash：准备 core/GeoIP/GeoSite 文件（保留）
cd ./luci-app-openclash/root/etc/openclash
CORE_MATE=https://github.com/vernesong/OpenClash/raw/refs/heads/core/dev/meta/clash-linux-arm64.tar.gz
curl -sfL -o ./Country.mmdb https://github.com/alecthw/mmdb_china_ip_list/raw/release/Country.mmdb
curl -sfL -o ./GeoSite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geosite.dat
curl -sfL -o ./GeoIP.dat https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geoip.dat
mkdir -p ./core && cd ./core
curl -sfL -o ./meta.tar.gz "$CORE_MATE" && tar -zxf ./meta.tar.gz && mv ./clash ./clash_meta
chmod +x ./clash* ; rm -rf ./*.gz

# 返回工程根目录以便后续操作
cd ../../../..

# ========== 修改默认 LAN IP 为 192.168.50.200 ==========
# 说明：OpenWrt 的默认 IP 通常在 package/base-files/files/bin/config_generate 中设置。
# 我们做两级替换：如果文件存在则替换行；如果不存在则尝试在 openwrt 源中搜索可能的位置并替换。
DEFAULT_IP="192.168.50.200"
CFG_FILE="package/base-files/files/bin/config_generate"

if [ -f "$CFG_FILE" ]; then
    echo "修改默认 LAN IP 为 $DEFAULT_IP (修改 $CFG_FILE)"
    # 常见的匹配形式例如: uci set network.lan.ipaddr='192.168.1.1'
    sed -i "s/network.lan.ipaddr='[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+'/'$DEFAULT_IP'/g" "$CFG_FILE"
    # 兼容另一种写法：o\tsed form or double quotes
    sed -i "s/network.lan.ipaddr=\"[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\"/network.lan.ipaddr=\"$DEFAULT_IP\"/g" "$CFG_FILE"
    # 如果上面替换未生效（文件中可能采用别的书写），追加确保默认值：
    if ! grep -q "$DEFAULT_IP" "$CFG_FILE"; then
        echo "未找到现有的默认 LAN IP 设置，尝试追加 uci 设置以覆盖默认值"
        # 在文件末尾追加设置（以防万一）
        echo "uci set network.lan.ipaddr='$DEFAULT_IP'" >> "$CFG_FILE"
        echo "uci commit network" >> "$CFG_FILE"
    fi
else
    echo "警告：未找到 $CFG_FILE，尝试在源代码中搜索并替换默认 IP"
    # 在源码中搜索常见文件并替换
    FOUND_FILES=$(grep -RIl "network.lan.ipaddr" || true)
    if [ -n "$FOUND_FILES" ]; then
        echo "在以下文件中替换默认 IP:"
        echo "$FOUND_FILES"
        for f in $FOUND_FILES; do
            sed -i "s/network.lan.ipaddr='[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+'/'$DEFAULT_IP'/g" "$f" || true
            sed -i "s/network.lan.ipaddr=\"[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\"/network.lan.ipaddr=\"$DEFAULT_IP\"/g" "$f" || true
        done
    else
        echo "未找到任何含有 network.lan.ipaddr 的文件，请手动检查并修改默认 IP。"
    fi
fi

echo "DIY 脚本执行完成。"
