#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

cd "$(
    cd "$(dirname "$0")" || exit
    pwd
)" || exit

#fonts color
Green="\033[32m"
Red="\033[31m"
# Yellow="\033[33m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
Font="\033[0m"

#notification information
# Info="${Green}[信息]${Font}"
OK="${Green}[OK]${Font}"
Error="${Red}[错误]${Font}"

command_exists() {
	command -v "$@" >/dev/null 2>&1
}

# 解锁奈飞
unlock_netflix() {
if command_exists docker; then

  read -rp "请输入DNS解锁的IP ：" dnsIp

  if [ -n "$dnsIp" ] ;then
    unlockNetflix=../conf/smartdns/unlock_netflix.conf

    if [[ ! -f $unlockNetflix ]]; then
      touch $unlockNetflix
    fi

    echo "server $dnsIp -exclude-default-group -group netflix" > $unlockNetflix

    echo "nameserver /netflix.com/netflix" >> $unlockNetflix
    echo "nameserver /netflix.net/netflix" >> $unlockNetflix
    echo "nameserver /nflximg.net/netflix" >> $unlockNetflix
    echo "nameserver /nflximg.com/netflix" >> $unlockNetflix
    echo "nameserver /nflxvideo.net/netflix" >> $unlockNetflix
    echo "nameserver /nflxso.net/netflix" >> $unlockNetflix
    echo "nameserver /nflxext.com/netflix" >> $unlockNetflix

    if [ $? -eq 0 ]; then
      echo -e "${OK} ${GreenBG} $unlockNetflix 已配置 ${Font}"
      restart_docker_smartdns
    fi
  else
    echo -e "${Error} ${RedBG} DNS解锁的IP输入有误${Font}"
  fi

else
    echo -e "${Error} ${RedBG} docker 未安装${Font}"
fi
}

restart_docker_smartdns() {
if command_exists docker; then
  docker rm -f smartdns
  echo -e "${OK} ${GreenBG} 已强制删除 docker smartdns ${Font}"

  docker-compose up -d smartdns

  if [ $? -eq 0 ]; then
    echo -e "${OK} ${GreenBG} docker-compose 启动 smartdns ${Font}"
  else
    echo -e "${Error} ${RedBG} docker-compose 启动 smartdns 失败${Font}"
  fi

else
    echo -e "${Error} ${RedBG} docker 未安装${Font}"
fi
}

set_resolv_conf() {
  echo
  chattr -i /etc/resolv.conf
  echo "nameserver 127.0.0.1" > /etc/resolv.conf
  chattr +i /etc/resolv.conf
  echo -e "${OK} ${GreenBG} /etc/resolv.conf 已配置为 127.0.0.1 ${Font}"
  echo
}

menu() {
    echo
    echo
    echo
    echo -e "${Green}0.${Font} 退出"
    echo -e "${Green}1.${Font} 重启 docker smartdns 容器"
    echo -e "${Green}2.${Font} 设置 /etc/resolv.conf 为 127.0.0.1 并加锁"
    echo -e "${Green}3.${Font} DNS解锁 奈飞 \n"

    read -rp "请输入数字：" menu_num
    case $menu_num in
    0)
        exit 0
        ;;
    1)
        restart_docker_smartdns
        menu
        ;;
    2)
        set_resolv_conf
        menu
        ;;
    3)
        unlock_netflix
        menu
        ;;
    *)
        echo -e "${RedBG}请输入正确的数字${Font}"
        ;;
    esac
}

menu
