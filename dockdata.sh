#!/bin/bash
#section 1:description 程式變數
#= version: 0.1, date: 20240405, Creater: jiasian.lin
#= version: 0.2, date: 20240406, Creater: jiasian.lin
# This is the first section of the script. Set variables

day=$(date +'%Y%-m%%-d')
now=$(date +'%Y%m%d-%H%M')

current_dir=$(pwd)
directory="DackerData"
host=XXXXXX
port=27017

TOKEN="lbz6wRQ4qvbPQIPDQHTEiCMF2THiArWr8Utvjy0ZWG2"
disk_space=1073741824
ThresholdMax=10000000
ThresholdMin=5000000


if [ ! -d "./log/" ]; then
    mkdir "./log/"
    echo -e "$(date)建立紀錄環境" >> "./log/Summary.log"
fi

disk_space=$(df -k . | awk 'NR==2 { print $4 }')

disk_message="可用空間僅剩下$(($disk_space / 1024)) MB"
curl -X POST \
        -H "Authorization: Bearer $TOKEN" \
        -F "message=$disk_message" \
        https://notify-api.line.me/api/notify

echo -e "$(date) $(pwd)硬碟空間剩下$disk_space " >> "$current_dir/log/Summary.log"

if [ $disk_space -lt $ThresholdMax ]; then

    $ThresholdMaxmessage="磁碟空間不足：可用空間僅剩下$(($disk_space / 1024)) MB"
    curl -X POST \
        -H "Authorization: Bearer $TOKEN" \
        -F "message=$ThresholdMaxmessage " \
        https://notify-api.line.me/api/notify
    echo -e "$(date) $(pwd)$message$disk_space " >> "$current_dir/log/Summary.log"

elif [ $disk_space -lt $ThresholdMin ]; then

    ThresholdMinmessage="磁碟空間不足：很緊急請馬上刪除$(($disk_space / 1024)) MB"

    curl -X POST \
        -H "Authorization: Bearer $TOKEN" \
        -F "message=$ThresholdMinmessage " \
        https://notify-api.line.me/api/notify  
        
        # 磁碟空間不足，終止腳本
        exit 1  
   
    echo -e "$(date) $(pwd)$message$disk_space " >> "$current_dir/log/Summary.log"
fi


if [ ! -d "$current_dir/$directory" ]; then
    mkdir -p "$current_dir/$directory"/{raw,processed,QC,analyzed,report,temp,log}
    touch "$current_dir/$directory"/log/Summary.log

    ln -s $current_dir/mongoDBtool/mongodb-database-tools-rhel90-x86_64-100.9.4/bin $current_dir/$directory/tools

    echo -e "$(date)Directory $current_dir/$directory Create a Folder." >> "$current_dir/$directory/log/Summary.log" 
        echo -e "$(date)Start Line Notify." >> "$current_dir/$directory/log/Summary.log" 
        
        MESSAGE="建立資料夾正常"

        curl -X POST \
        -H "Authorization: Bearer $TOKEN" \
        -F "message=$test " \
        https://notify-api.line.me/api/notify

        curl -X POST \
        -H "Authorization: Bearer $TOKEN" \
        -F "message=$MESSAGE " \
        https://notify-api.line.me/api/notify
        # 將執行成功的訊息記錄到日誌中
        echo -e  "$(date) $MESSAGE Line Notify End." >> "$current_dir/$directory/log/Summary.log" 
        echo -e "$(date) Directory $current_dir/$directory Create a Folder." >> "$current_dir/$directory/log/Summary.log"  
else

    echo -e "Directory $current_dir/$directory already exists. Skipping creation.">> "$current_dir/$directory/log/Summary.log" 
        MESSAGE="資料夾已存在"
        curl -X POST \
        -H "Authorization: Bearer $TOKEN" \
        -F "message=$test " \
        https://notify-api.line.me/api/notify

        curl -X POST \
        -H "Authorization: Bearer $TOKEN" \
        -F "message=$MESSAGE " \
        https://notify-api.line.me/api/notify
        # 將執行成功的訊息記錄到日誌中
        echo -e "$(date) $MESSAGE Directory $current_dir/$directory already exists. Skipping creation." >> "$current_dir/$directory/log/Summary.log"        
    

fi        

        #取得 硬碟剩餘空間
        df -h --output=source,size,used,avail,pcent,target | awk 'NR>1' | while read -r filesystem size used avail use_percent mounted_on; do
            echo "{ \"Filesystem\": \"$filesystem\", \"Size\": \"$size\", \"Used\": \"$used\", \"Available\": \"$avail\", \"Use%\": \"$use_percent\", \"Mounted on\": \"$mounted_on\" }" >> $current_dir/$directory/raw/"$now-DiskSpace.json"
        done   

        cd $current_dir/$directory
        #加入至DiskSpace mongodb 中
        tools/mongoimport --host "$host" --port $port --db admin --collection DiskSpace --file raw/"$now-DiskSpace.json" --username gn045001 --password gn045001
        #將Docker 相關資訊加入
        docker ps --format '{"Container ID":"{{.ID}}", "Image":"{{.Image}}", "Created":"{{.RunningFor}}", "Status":"{{.Status}}"}' > $current_dir/$directory/raw/"$now-DockerState.json"
        
        #加入至DockerState  mongodb 中
        tools/mongoimport --host "$host" --port $port --db admin --collection DockerState --file raw/"$now-DockerState.json" --username gn045001 --password gn045001
        mv "$now-DockerOutPut.json" raw/"$now-DockerOutPut.json"
 echo -e "$(date) Start confirming the Server ." >> "$current_dir/$directory/log/Summary.log" 
