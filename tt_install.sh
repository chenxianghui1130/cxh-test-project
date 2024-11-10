#!/bin/bash
#LAST_VERSION=$(curl --silent "http://bearware.dk/teamtalk/tt5update.php" | grep -Po '<teamtalk version="\K.*?(?=")')
LAST_VERSION=5.6.1
echo -e "请输入 TeamTalk 版本号"
read -e -p "版本: (默认: $LAST_VERSION)" ver
VER=${ver:-$LAST_VERSION}
echo "请选择编译版本。"
echo "1. centos7-x86_64"
echo "2. debian9-x86_64"
echo "3. ubuntu18-x86_64"
echo "4. raspbian10-armhf"
read -p "编译版本:" OS_NUM
if [ $OS_NUM = "1" ] ; then
OS="centos7-x86_64"
elif [ $OS_NUM = "2" ] ; then
OS="debian9-x86_64"
elif [ $OS_NUM = "3" ] ; then
OS="ubuntu18-x86_64"
elif [ $OS_NUM = "4" ] ; then
OS="raspbian10-armhf"
else
echo "输入错误！" && exit 0
fi
if [ ! -e ./teamtalk-v$VER-$OS.tgz ]
then
wget -c http://bearware.dk/teamtalk/v$VER/teamtalk-v$VER-$OS.tgz
fi
if [ -e ./teamtalk-v$VER-$OS.tgz ]
then
tar -xzf teamtalk-v$VER-$OS.tgz
else
echo "文件不存在，请重试！" && exit 0
fi
useradd -s /sbin/nologin teamtalk &> /dev/null
mkdir -p /home/teamtalk/share &> /dev/null && chown -R teamtalk.teamtalk /home/teamtalk
mv ./teamtalk-v$VER-$OS/server/tt5srv /usr/bin && chown teamtalk.teamtalk /usr/bin/tt5srv
mv ./teamtalk-v$VER-$OS/server/systemd/tt5server.service /lib/systemd/system
systemctl enable tt5server
rm -rf teamtalk-v$VER-$OS
rm teamtalk-v$VER-$OS.tgz
mkdir /etc/teamtalk &> /dev/null && chown -R teamtalk.teamtalk /etc/teamtalk
mkdir /var/log/teamtalk &> /dev/null && chown -R teamtalk.teamtalk /var/log/teamtalk
if [ ! -e /etc/teamtalk/tt5srv.xml ]
then
/usr/bin/tt5srv -c /etc/teamtalk/tt5srv.xml -wizard
chown teamtalk.teamtalk /etc/teamtalk/tt5srv.xml
else
chown teamtalk.teamtalk /etc/teamtalk/tt5srv.xml
fi
systemctl start tt5server

