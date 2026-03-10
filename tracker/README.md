# 时间追踪系统配置

## 新设备恢复步骤

1. 复制脚本
cp scripts/*.sh ~/dev/tracker/scripts/
chmod +x ~/dev/tracker/scripts/*.sh

2. 复制 systemd service
cp systemd/activitywatch.service ~/.config/systemd/user/
sed -i "s|/home/mini-harry|$HOME|g" ~/.config/systemd/user/activitywatch.service
systemctl --user enable activitywatch.service

3. 把 bashrc-tracker.sh 内容追加到 ~/.bashrc
cat bashrc-tracker.sh >> ~/.bashrc
source ~/.bashrc

4. 配置 crontab
crontab -e
# 添加：0 9-21 * * * ~/dev/tracker/scripts/remind.sh
