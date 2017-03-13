#!/bin/bash

#created by YY&YY@2017-03-08.

FILE_CFG="./advertisement_cfg.ini"

#判断配置文件是否存在
if [ -f $FILE_CFG ]; then
	echo "广告灯配置文件 $FILE_CFG exists!"
else
	echo "广告灯配置文件 $FILE_CFG not exists!"
	exit 0;
fi
# __readINI [配置文件路径+名称] [节点名] [键值]
function __readINI() 
{
	INIFILE=$1; SECTION=$2; ITEM=$3
	_readIni=`awk -F '=' '/\['$SECTION'\]/{a=1}a==1&&$1~/'$ITEM'/{print $2;exit}' $INIFILE`
	echo ${_readIni}
}

#bengin time
benginHour=( $( __readINI ${FILE_CFG} BEGIN_TIME BeginHour ) ) 
benginMin=( $( __readINI ${FILE_CFG} BEGIN_TIME BeginMin ) ) 
benginSec=( $( __readINI ${FILE_CFG} BEGIN_TIME BeginSec ) ) 
#echo ${benginHour}
#echo ${benginMin}
#echo ${benginSec}

#end time 
endHour=( $( __readINI ${FILE_CFG} END_TIME EndHour ) ) 
endMin=( $( __readINI ${FILE_CFG} END_TIME EndMin ) ) 
endSec=( $( __readINI ${FILE_CFG} END_TIME EndSec ) ) 
#echo ${endHour}
#echo ${endMin}
#echo ${endSec}

benginTime="${benginHour}:${benginMin}:${benginSec}"
echo "打开广告灯的起始时间	${benginTime}"
endTime="${endHour}:${endMin}:${endSec}"
echo "打开广告灯的结束时间	${endTime}"

benginTimeSeconds=$[$((10#$benginHour))*3600+$((10#$benginMin))*60+$((10#$benginSec))]
#benginTimeSeconds=$[$[benginHour]*3600+$[benginMin]*60+$[benginSec]]
echo "打开广告灯的起始时间秒数	${benginTimeSeconds}"
endTimeSeconds=$[$((10#$endHour))*3600+$((10#$endMin))*60+$((10#$endSec))]
#endTimeSeconds=$[$[endHour]*3600+$[endMin]*60+$[endSec]]
echo "打开广告灯的结束时间秒数	${endTimeSeconds}"

while [ "1" = "1" ]
do
	realTimeHour=`date +'%H'`
	realTimeMin=`date +'%M'`
	realTimeSec=`date +'%S'`

	realTimeSeconds=$[$((10#$realTimeHour))*3600+$((10#$realTimeMin))*60+$((10#$realTimeSec))]

	#echo "当前时间	${realTimeHour}:${realTimeMin}:${realTimeSec}"
	#echo "当前时间秒数	${realTimeSeconds}"

	#if [ $[realTimeSeconds] -ge $[benginTimeSeconds]] || [ $[realTimeSeconds] -le $[endTimeSeconds]]; then
	if [ $[realTimeSeconds] -ge $[benginTimeSeconds] ] || [ $[realTimeSeconds] -le $[endTimeSeconds] ]; then
		/forlinx/bin/gpio-test out 7 0		
		#echo "打开广告灯"
	else
		/forlinx/bin/gpio-test out 7 1
		#echo "关闭广告灯"
	fi

	#echo "wahaha"
	sleep 1
done
#end of file.
