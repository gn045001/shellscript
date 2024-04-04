#!/bin/bash
#section 1:description 程式變數
#= version: 0.0.1, date: 20240331, Creater: jiasian.lin
# This is the first section of the script. Set variables
#由於個資法我把以下*號
current_dir=$(pwd)
directory="serverfile"
TOKEN="lbz6wRQ4qvbPQIPDQHTEiCMF2THiArWr8Utvjy0ZWG2"
#硬碟容量告警戒線
#ThresholdMaxmessage=須注意空間請刪除不要的log
#ThresholdMinmessage=停止需求產生的log
ThresholdMax=1000000
ThresholdMin=500000

#設定相關資料夾 & 確認主機網路狀態
# section 2:description Establish 確認環境
mkdir -p log
df -h --output=source,size,used,avail,pcent,target | awk 'NR>1' | while read -r filesystem size used avail use_percent mounted_on; do
    echo "{ \"Filesystem\": \"$filesystem\", \"Size\": \"$size\", \"Used\": \"$used\", \"Available\": \"$avail\", \"Use%\": \"$use_percent\", \"Mounted on\": \"$mounted_on\" }," >> DiskSpace.js
done


disk_space=$(df -k . | awk 'NR==2 { print $4 }')

message="可用空間僅剩下$(($disk_space / 1024)) MB"
curl -X POST \
        -H "Authorization: Bearer $TOKEN" \
        -F "message=$message" \
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
        exit 1  # 磁碟空間不足，終止腳本
    echo -e "$(date) $(pwd)$message$disk_space " >> "$current_dir/log/Summary.log"
fi


echo -e "$(date) Check available space $disk_space " >> "$current_dir/$directory/log/Summary.log"

echo -e "$(date) 建立資料夾 $current_dir/$directory_log " >> "$current_dir/$directory/log/Summary.log"

#Start checking host status
echo -e "$(date) Start checking host status" >> "$current_dir/$directory_log/Summary.log" 
ip addr > "$current_dir/$directory_log"/ip.log
test=$(cat $directory_log/ip.log)
#ping localhost
ping -c 4 192.XXX.XXX.106 >"$current_dir/$directory_log"/LocalhostIp.log
#gatway ip
ping -c 4 192.XXX.XXX.1 >"$current_dir/$directory_log"/GatwayIp.log
#google ip
ping -c 4 8.8.8.8 >"$current_dir/$directory_log"/GoogleIp.log

echo -e "$(date) Host status check completed" >> "$current_dir/$directory_log/Summary.log" 


# section 3:description Establish environment
echo -e "$(date) Establish environment  -p $current_dir/$directory_log" >> "$current_dir/$directory_log/Summary.log" 

echo -e "目前的工作目錄是: $current_dir/$directory"



if [ ! -d "$current_dir/$directory" ]; then
    mkdir -p "$current_dir/$directory"/{raw,processed,QC,analyzed,report,temp,log}
    touch "$current_dir/$directory"/log/Summary.log
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
        echo -e  "$(date) Line Notify End." >> "$current_dir/$directory/log/Summary.log" 
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
        echo -e "$(date) Directory $current_dir/$directory already exists. Skipping creation." >> "$current_dir/$directory/log/Summary.log"  

fi

    echo -e "$(date) Start confirming the Server ." >> "$current_dir/$directory/log/Summary.log" 
##section 4:description 確認主機是否正常
for ip in 106 107 108 109; 
do
    echo -e "ping 192.XXX.XXX.$ip" >> "$current_dir/$directory/log/Summary.log" 
    if ping -c 4 "192.XXX.XXX.$ip" &> /dev/null; then
        echo "192.XXX.XXX.$ip is reachable"
        MESSAGE="192.XXX.XXX.$ip  是好的"

        curl -X POST \
        -H "Authorization: Bearer $TOKEN" \
        -F "message=$MESSAGE" \
        https://notify-api.line.me/api/notify
        echo -e "$(date) Line Notify $MESSAGE MESSAGE" >> "$current_dir/$directory/log/Summary.log"  
    else
        echo -e "192.XXX.XXX.$ip is not reachable" >> "$current_dir/$directory/log/Summary.log" 

        MESSAGE="192.XXX.XXX.$ip  有問題須注意"

        curl -X POST \
        -H "Authorization: Bearer $TOKEN" \
        -F "message=$MESSAGE" \
        https://notify-api.line.me/api/notify
        echo -e "$(date) Line Notify $MESSAGE MESSAGE " >> "$current_dir/$directory/log/Summary.log"  
    fi
done
    echo -e "$(date) Confirm server end " >> "$current_dir/$directory/log/Summary.log" 
    echo -e "$(date) Confirm server end " >> "$current_dir/$directory_log/log/Summary.log" 
