#!/bin/bash

#= version: 0.1, date: 20240405, Creater: jiasian.lin
#= version: 0.2, date: 20240406, Creater: jiasian.lin
#= version: 0.3, date: 20240420, Creater: jiasian.lin
#section 1:description 程式變數
# 日期變數
day=$(date +'%Y%-m%%-d')
now=$(date +'%Y%m%d-%H%M')

#執行環境的資料夾之環境變數
current_dir=/home/$USER
directory="DackerData"

#執行的mongoDB的IP之變數
host=localhost
port=27017

# 上傳資料至mongoDB的帳號密碼之變數
used=admin
pass=gn045001

# line 的相關變數
#TOKEN="lbz6wRQ4qvbPQIPDQHTEiCMF2THiArWr8Utvjy0ZWG2"

# 硬碟空間告警設定變數
disk_space=1073741824
ThresholdMax=10000000
ThresholdMin=5000000

#section 2: 建立log資料夾給進行記錄執行環境狀況
if [ ! -d "./log/" ]; then
    mkdir "./log/"
    echo -e "$(date)建立紀錄環境" >> "./log/Summary.log"
fi


#確認硬碟空間應紀錄如有異常就告警

disk_space=$(df -k . | awk 'NR==2 { print $4 }')
disk_message="可用空間僅剩下$(($disk_space / 1024)) MB"
#將剩下空間藉由Line 傳遞到群組中
curl -X POST \
        -H "Authorization: Bearer $TOKEN" \
        -F "message=$disk_message" \
        https://notify-api.line.me/api/notify

echo -e "$(date) $(pwd)硬碟空間剩下$disk_space " >> "$current_dir/log/Summary.log"

#如硬碟空間不足需請使用者進行觀察與刪除
#當空間小於$ThresholdMin值無法進行執行需求

echo -e "$(date) $(pwd)硬碟空間剩下$disk_space" >> "$current_dir/log/Summary.log"
if [ $disk_space -lt $ThresholdMax ]; then
#當空間小於10000000kb並出現告警需注意
    $ThresholdMaxmessage="磁碟空間不足：可用空間僅剩下$(($disk_space / 1024)) MB"
    curl -X POST \
        -H "Authorization: Bearer $TOKEN" \
        -F "message=$ThresholdMaxmessage " \
        https://notify-api.line.me/api/notify
    echo -e "$(date) $(pwd)$ThresholdMaxmessage " >> "$current_dir/log/Summary.log"

elif [ $disk_space -lt $ThresholdMin ]; then
#當空間小於5000000kb並出現告警需注意
    ThresholdMinmessage="磁碟空間不足：很緊急請馬上刪除$(($disk_space / 1024)) MB，如空間有問題請刪除檔案或者新增硬碟空間."

    curl -X POST \
        -H "Authorization: Bearer $TOKEN" \
        -F "message=$ThresholdMinmessage " \
        https://notify-api.line.me/api/notify  
        
        # 磁碟空間不足，終止腳本
        echo -e "$(date) $(pwd)剩餘空間小於$ThresholdMinmessage 需求已停止" >> "$current_dir/log/Summary.log"
        exit 1     
fi
echo -e "$(date)確認硬碟空間狀態$disk_space" >> "$current_dir/log/Summary.log"
#當空間小於$ThresholdMin值無法進行執行需求
echo -e "$(date) $(pwd)硬碟空間剩下$disk_space" >> "$current_dir/log/Summary.log"
if [ ! -d "$current_dir/$directory" ]; then
    echo -e "$(date) 尚未建立$current_dir/$directory" 需建立執行專案空間 >> "$current_dir/log/Summary.log"
    mkdir -p "$current_dir/$directory"/{raw,processed,QC,script,report,log}
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

    echo -e "$(date)Directory $current_dir/$directory already exists. Skipping creation.">> "$current_dir/$directory/log/Summary.log"
    echo -e "$(date)Start Line Notify." >> "$current_dir/$directory/log/Summary.log" 
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
    echo -e "$(date) 取得硬碟相關資訊" >> "$current_dir/$directory/log/Summary.log"   
        #取得 硬碟剩餘空間
        df -h --output=source,size,used,avail,pcent,target | awk 'NR>1' | while read -r filesystem size used avail use_percent mounted_on; 
            do
                echo "{\"Filesystem\": \"$filesystem\", \"Size\": \"$size\", \"Used\": \"$used\", \"Available\": \"$avail\", \"Use%\": \"$use_percent\", \"Mounted on\": \"$mounted_on\" }" >> "$current_dir/$directory/raw/DiskSpace.json"
            done
 
    echo -e "$(date)  取德硬碟相關資訊以寫入Summarylog中" >> "$current_dir/$directory/log/Summary.log"

        #加入至DiskSpace mongodb 中
        echo -e "$(date) 加入至DiskSpace mongodb 中" >> "$current_dir/$directory/log/Summary.log"
        cd $current_dir/$directory

        tools/mongoimport --host "$host" --port $port --db admin --collection DiskSpace --file "$current_dir/$directory/raw/DiskSpace.json" --username $used --password $pass
        
        
#將Docker 資訊
#確認docker 運行情況，並在需要時對容器進行管理
        echo -e "$(date) 確認運行情況是否正常">>"$current_dir/$directory/log/Summary.log"
        docker ps --format '{"timestamp": "'"$(date +'%Y-%m-%d %H:%M:%S')"'" ,"Container ID":"{{.ID}}", "Image":"{{.Image}}", "Created":"{{.RunningFor}}", "Status":"{{.Status}}"}' > "$current_dir/$directory/raw/DockerState.json"
        echo -e "$(date) 執行狀況記錄至Summerlog中">>"$current_dir/$directory/log/Summary.log"

        echo -e "$(date)  建立Docker狀態資料中" >> "$current_dir/$directory/log/Summary.log"
        docker stats --no-stream --format '{"timestamp": "'"$(date +'%Y-%m-%d %H:%M:%S')"'" , "container_id": "{{.ID}}", "container_name": "{{.Name}}", "cpu_percentage": "{{.CPUPerc}}", "memory_usage": "{{.MemUsage}}", "memory_percentage": "{{.MemPerc}}", "network_io": "{{.NetIO}}", "block_io": "{{.BlockIO}}"}'>>  "$current_dir/$directory/raw/ComputerStart.json"
        echo -e "$(date) 建立Docker狀態已完成資料中" >> "$current_dir/$directory/log/Summary.log"


        #加入至DockerState  mongodb 中
        echo -e "$(date)  建立DockerState到資料庫" >> "$current_dir/$directory/log/Summary.log"
        tools/mongoimport --host "$host" --port $port --db admin --collection DockerState --file "$current_dir/$directory/raw/DockerState.json" --username $used --password $pass
        echo -e "$(date)   建立DockerState到資料庫完畢" >> "$current_dir/$directory/log/Summary.log"

        echo -e "$(date)  建立DiskSpace到資料庫" >> "$current_dir/$directory/log/Summary.log"     
        tools/mongoimport --host "$host" --port $port --db admin --collection DiskSpace --file "$current_dir/$directory/raw/DiskSpace.json" --username $used --password $pass
        echo -e "$(date)  建立DiskSpace到資料庫完畢 ." >> "$current_dir/$directory/log/Summary.log"


        echo -e "$(date)  建立ComputerStart到資料庫" >> "$current_dir/$directory/log/Summary.log"     
        tools/mongoimport --host "$host" --port $port --db admin --collection ComputerStart --file "$current_dir/$directory/raw/ComputerStart.json" --username $used --password $pass
        echo -e "$(date)  建立ComputerStart到資料庫完畢 ." >> "$current_dir/$directory/log/Summary.log" 
    
