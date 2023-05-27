#!/bin/bash

# 将Windows和WSL2的ip写入各自hosts
winhost=`cat /etc/resolv.conf | grep nameserver | awk '{print $2}'`
wslhost=`hostname -I | awk '{print $1}'`
cat /mnt/c/Windows/System32/drivers/etc/hosts |sed -e 's/\r//g' > /hosts_temp
sed -i '/winhost$/d' /hosts_temp
sed -i '/wslhost$/d' /hosts_temp
echo "${winhost} winhost" >> /hosts_temp
echo "${wslhost} wslhost" >> /hosts_temp
mv /hosts_temp /etc/hosts
# 下一条有可能会失败，需要自行解决C:\Windows\System32\drivers\etc\hosts的权限问题
#cp /etc/hosts /mnt/c/Windows/System32/drivers/etc/hosts >/dev/null 2>&1

export GTK_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export QT_IM_MODULE=fcitx
export GDK_SCALE=1
export GDK_DPI_SCALE=1.25
# 启动输入法
nohup fcitx-autostart >/dev/null 2>&1 &

# 启动Windows的端口转发
proxy_status=`ps -ef|grep 'wsl2-tcpproxy.exe'|grep -v grep|wc -l`
if [ $proxy_status -le 0 ]; then
  nohup /mnt/c/Wsl2-GUI/wsl2-tcpproxy.exe >/wsl2-tcpproxy.log 2>&1 &
fi

# 根据输入参数执行命令
$*
