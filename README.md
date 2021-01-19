# 基于WSL2的图形界面

---
本项目适用于在Windows中使用其Linux子系统(WSL)的图形界面应用，如IDE，如此可避免在Windows中搭建开发环境。通过本项目启动Linux子系统的应用，会自动启动Windows版本的Nginx开启端口转发功能，以便通过局域网访问子系统的端口。Linux子系统的应用启动前，会自动开启Linux的输入法并启动一些服务。本项目使用的子系统为`Ubuntu 20.04`，其他子系统可能需要对项目进行少量修改。

### 如何使用
- 自行安装WSL2
- 安装输入法
  ```shell
  apt update
  apt install -y fcitx fcitx-sunpinyin
  ```
- 克隆本项目到本地
  ```shell
  cd /mnt/c # 或者仅包含英文的其他路径(不能有空格)
  git config --global core.autocrlf false
  git clone https://github.com/chenyingzhou/Wsl2-GUI.git
  ```
  > 设置core.autocrlf为false的目的是为了避免换行符自动转换，Windows的脚本换行符必须是CRLF，Linux则必须是LF，否则功能会不正常。
- 配置输入法
  - 在Windows中打开上一步克隆的路径双击Applications，我是直接克隆到C盘根目录，所以路径是`C:\Wsl2-GUI\Applications`
  - 找到该目录的`FcitxConfigGtk3`，这是一个快捷方式
  - 如果克隆路径不是C盘根目录，则`右键FcitxConfigGtk3->属性->根据实际情况修改"目标(T)"和起始位置(S)`
  - 双击FcitxConfigGtk3，进入子系统的输入法配置页
  - 在`Input Method`标签页添加`Sunpinyin`
  - 点击`Global Config`标签页，前2行全部改为`LShift`作为中英切换键，和Windows相同，但没有影响，因为两边输入法不互通
  - 点击`AddOn`标签页，点击列表`Simplified Chenese To ...(简繁切换)`，点击下面`Confidure`，关闭切换快捷键(因为和IDE全家桶冲突)，关闭方式是点击后按ESC键
  - 大功告成

### 主要文件说明
- wsl2-run-app.vbs
  - 在Windows中执行的脚本
  - 换行符必须是CRLF，所以推荐用Windows的记事本打开
  - 各处都有注释，看注释就好了
  - 该脚本可以在`任务计划程序`中添加到登录启动以便开机时启动WSL2，具体操作可以搜索，开机启动不是必须的
- wsl2-run-app.sh
  - 在子系统中执行的脚本
  - 换行符必须是LF，所以推荐用子系统的vim命令打开
  - 主要用于启动输入法后(若未启动)再执行指定命令
  - 脚本中顺便启动的其他服务(示例中是ssh和docker)可根据需要添加或移除
- Nginx/conf/nginx.conf
  - 端口转发是为了通过局域网访问子系统的端口
  - 用于端口转发的Nginx配置
  - 换行符(可能)必须是CRLF，所以推荐用Windows的记事本打开
  - 要转发的端口配置在该文件的stream模块
  - 可以转发到127.0.0.1，因为Windows和子系统的localhostForwarding是默认开启的
