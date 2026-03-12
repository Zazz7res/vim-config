#!/bin/bash
# =============================================================
# Fcitx5 + Rime + 雾凇拼音 完整一键安装脚本
# 适用环境: Ubuntu 25.04 / Wayland / GNOME
# 使用方式: 在 ~/for_Config/ 目录下执行 bash install.sh
#
# 功能：
#   1. 卸载所有旧版 fcitx/fcitx4/fcitx5，彻底清空
#   2. 安装最新 fcitx5 + fcitx5-rime
#   3. 安装雾凇拼音（rime-ice，clone 最新版）
#   4. 禁用 Shift 切换（两层：Rime内部 + fcitx5层）
#   5. 仅保留 Ctrl+Space 切换中英文
#   6. 配置开机自启 + Wayland 浏览器中文输入修复
#   7. 配置环境变量
# =============================================================

set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
step() { echo ""; echo -e "${GREEN}======================================${NC}"; echo -e "${GREEN} $1${NC}"; echo -e "${GREEN}======================================${NC}"; }

echo ""
echo "  Fcitx5 + Rime + 雾凇拼音 一键安装"
echo "  适用: Ubuntu 25.04 / Wayland / GNOME"
echo ""

# =============================================================
# 第一步：卸载所有旧版 fcitx
# =============================================================
step "1/8  卸载旧版 fcitx"

sudo apt remove --purge -y \
    fcitx \
    fcitx-bin \
    fcitx-config-common \
    fcitx-config-gtk \
    fcitx-frontend-gtk2 \
    fcitx-frontend-gtk3 \
    fcitx-module-cloudpinyin \
    fcitx-pinyin \
    fcitx-ui-classic \
    fcitx5 \
    fcitx5-chinese-addons \
    fcitx5-config-qt \
    fcitx5-frontend-gtk3 \
    fcitx5-frontend-gtk4 \
    fcitx5-frontend-qt5 \
    fcitx5-rime \
    2>/dev/null || true

sudo apt autoremove -y 2>/dev/null || true

# 备份用户词库（如果存在）
if [ -d "$HOME/.local/share/fcitx5/rime/rime_ice.userdb" ]; then
    warn "检测到雾凇用户词库，备份到 /tmp/rime_ice.userdb.bak"
    cp -r "$HOME/.local/share/fcitx5/rime/rime_ice.userdb" /tmp/rime_ice.userdb.bak
fi

# 清除所有用户级配置
rm -rf ~/.config/fcitx5
rm -rf ~/.config/fcitx
rm -rf ~/.local/share/fcitx5
rm -f ~/.config/autostart/org.fcitx.Fcitx5.desktop
rm -f ~/.config/autostart/fcitx5-restart.desktop
rm -f ~/.config/autostart/fcitx.desktop

log "旧版 fcitx 卸载完成"

# =============================================================
# 第二步：安装 fcitx5 + fcitx5-rime
# =============================================================
step "2/8  安装 fcitx5 + fcitx5-rime"

sudo apt update -q
sudo apt install -y \
    fcitx5 \
    fcitx5-chinese-addons \
    fcitx5-frontend-gtk3 \
    fcitx5-frontend-gtk4 \
    fcitx5-frontend-qt5 \
    fcitx5-config-qt \
    fcitx5-rime \
    librime-bin \
    librime-plugin-lua \
    librime-plugin-charcode \
    librime-plugin-octagram

log "安装完成"

# =============================================================
# 第三步：配置 fcitx5（禁用 Shift，仅 Ctrl+Space）
# =============================================================
step "3/8  配置 fcitx5（fcitx5层禁用 Shift，仅 Ctrl+Space）"

mkdir -p ~/.config/fcitx5

cat > ~/.config/fcitx5/config << 'EOF'
[Hotkey]
EnumerateWithTriggerKeys=False
AltTriggerKeys=
EnumerateForwardKeys=
EnumerateBackwardKeys=
EnumerateSkipFirst=False
EnumerateGroupForwardKeys=
EnumerateGroupBackwardKeys=
ActivateKeys=
DeactivateKeys=
PrevCandidate=
NextCandidate=
TogglePreedit=
ModifierOnlyKeyTimeout=0

[Hotkey/TriggerKeys]
0=Control+space

[Hotkey/PrevPage]
0=minus

[Hotkey/NextPage]
0=equal

[Behavior]
ActiveByDefault=True
resetStateWhenFocusIn=No
ShareInputState=No
PreeditEnabledByDefault=True
ShowInputMethodInformation=True
showInputMethodInformationWhenFocusIn=False
CompactInputMethodInformation=True
ShowFirstInputMethodInformation=True
DefaultPageSize=5
OverrideXkbOption=False
CustomXkbOption=
EnabledAddons=
PreloadInputMethod=True
AllowInputMethodForPassword=False
ShowPreeditForPassword=False
AutoSavePeriod=30

[Behavior/DisabledAddons]
0=quickphrase
EOF

# rime 为默认输入法
cat > ~/.config/fcitx5/profile << 'EOF'
[Groups/0]
Name=默认
Default Layout=us
DefaultIM=rime

[Groups/0/Items/0]
Name=rime
Layout=

[Groups/0/Items/1]
Name=keyboard-us
Layout=

[GroupOrder]
0=默认
EOF

log "fcitx5 配置完成（Shift 已在 fcitx5 层禁用）"

# =============================================================
# 第四步：安装雾凇拼音
# =============================================================
step "4/8  安装雾凇拼音 rime-ice"

RIME_DIR="$HOME/.local/share/fcitx5/rime"
mkdir -p "$RIME_DIR"

git clone --depth 1 https://github.com/iDvel/rime-ice.git "$RIME_DIR"

# 还原用户词库（如果有备份）
if [ -d /tmp/rime_ice.userdb.bak ]; then
    cp -r /tmp/rime_ice.userdb.bak "$RIME_DIR/rime_ice.userdb"
    rm -rf /tmp/rime_ice.userdb.bak
    log "用户词库已还原"
fi

log "雾凇拼音克隆完成"

# =============================================================
# 第五步：Rime 内部禁用 Shift（第一层）+ 还原自定义配置
# =============================================================
step "5/8  配置 Rime（Rime内部层禁用 Shift）"

# 禁用 Shift 在 Rime 内部切换英文模式
cat > "$RIME_DIR/rime_ice.custom.yaml" << 'EOF'
patch:
  ascii_composer/good_old_caps_lock: true
  ascii_composer/switch_key/Shift_L: noop
  ascii_composer/switch_key/Shift_R: noop
  ascii_composer/switch_key/Control_L: noop
  ascii_composer/switch_key/Control_R: noop
  ascii_composer/switch_key/Caps_Lock: clear
EOF

# 还原自定义短语
if [ -f "$SCRIPT_DIR/Rime/custom/custom_phrase.txt" ]; then
    cp "$SCRIPT_DIR/Rime/custom/custom_phrase.txt" "$RIME_DIR/custom_phrase.txt"
    log "自定义短语已还原"
fi

# 还原其他 .custom.yaml 补丁
if ls "$SCRIPT_DIR/Rime/custom/"*.custom.yaml &>/dev/null 2>&1; then
    cp "$SCRIPT_DIR/Rime/custom/"*.custom.yaml "$RIME_DIR/"
    log "自定义补丁文件已还原"
fi

log "Rime 配置完成（Shift 已在 Rime 层禁用）"

# =============================================================
# 第六步：开机自启 + Wayland 浏览器修复
# =============================================================
step "6/8  配置开机自启 + Wayland 浏览器中文输入修复"

mkdir -p ~/.local/bin
cat > ~/.local/bin/fcitx5-restart-delay.sh << 'EOF'
#!/bin/bash
# 等待桌面和浏览器完全加载后重连 fcitx5
# 解决 Wayland 下浏览器启动时 fcitx5 连接时序问题
sleep 5
fcitx5 -r
EOF
chmod +x ~/.local/bin/fcitx5-restart-delay.sh

mkdir -p ~/.config/autostart
cat > ~/.config/autostart/fcitx5-restart.desktop << EOF
[Desktop Entry]
Type=Application
Name=Fcitx5 Restart for Wayland Browser Fix
Exec=$HOME/.local/bin/fcitx5-restart-delay.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Comment=Restart fcitx5 to fix Wayland browser input method connection
EOF

log "开机自启配置完成"

# =============================================================
# 第七步：配置环境变量
# =============================================================
step "7/8  配置环境变量"

# 系统级：清理旧变量
if grep -q "GTK_IM_MODULE" /etc/environment 2>/dev/null; then
    warn "清理 /etc/environment 中的旧 X11 变量..."
    sudo cp /etc/environment /etc/environment.bak
    sudo tee /etc/environment > /dev/null << 'EOF'
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
XMODIFIERS=@im=fcitx
EOF
    log "/etc/environment 已清理"
fi

# 用户级：Wayland 推荐方式
mkdir -p ~/.config/environment.d
cat > ~/.config/environment.d/fcitx5.conf << 'EOF'
XMODIFIERS=@im=fcitx
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
SDL_IM_MODULE=fcitx
INPUT_METHOD=fcitx
EOF

log "环境变量配置完成"

# =============================================================
# 第八步：启动 fcitx5，触发 Rime 词库编译
# =============================================================
step "8/8  启动 fcitx5，编译 Rime 词库"

pkill fcitx5 2>/dev/null || true
sleep 2
fcitx5 &

echo -n "    等待词库编译"
for i in $(seq 1 60); do
    sleep 1
    echo -n "."
    if [ -f "$RIME_DIR/build/rime_ice.table.bin" ]; then
        echo ""
        log "词库编译完成！"
        break
    fi
done

if [ ! -f "$RIME_DIR/build/rime_ice.table.bin" ]; then
    echo ""
    warn "词库仍在编译中，首次使用时自动完成（正常现象）"
fi

# =============================================================
# 完成
# =============================================================
echo ""
echo -e "${GREEN}======================================"
echo " 全部完成！请重启系统生效。"
echo ""
echo " 快捷键："
echo "   Ctrl+Space     切换中文 / 英文"
echo "   Shift          无效果（已禁用）"
echo "   Caps Lock      清除英文锁定"
echo ""
echo " 雾凇功能："
echo "   rq             当前日期"
echo "   nl             农历"
echo "   R100           大写数字：壹佰"
echo "   cC1+1          计算：2"
echo "   [ ]            以词定字"
echo ""
echo " 浏览器中文输入："
echo "   开机后约 5 秒自动修复，无需手动操作"
echo -e "======================================${NC}"
