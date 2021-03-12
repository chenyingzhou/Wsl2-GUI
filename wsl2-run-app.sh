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
cp /etc/hosts /mnt/c/Windows/System32/drivers/etc/hosts >/dev/null 2>&1

export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
export GTK_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export QT_IM_MODULE=fcitx

# 启动输入法
fcitx_status=`ps -ef|grep 'fcitx'|grep -v grep|wc -l`
if [ $fcitx_status -le 0 ]; then
  fcitx >/dev/null 2>&1
fi

# 启动其他各种服务，可适当添加或移除
ssh_status=`ps -ef|grep 'sshd'|grep -v grep|wc -l`
if [ $fcitx_status -le 0 ]; then
  service ssh start >/dev/null 2>&1
fi
docker_status=`ps -ef|grep 'dockerd'|grep -v grep|wc -l`
if [ $fcitx_status -le 0 ]; then
  service docker start >/dev/null 2>&1
fi

# 根据输入参数执行命令
$*
