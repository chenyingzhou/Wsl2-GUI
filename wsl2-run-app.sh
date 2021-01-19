#!/bin/bash

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
