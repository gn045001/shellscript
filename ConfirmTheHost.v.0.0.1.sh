#!/bin/bash
#section 1:description 程式變數
#= version: 0.1, date: 20240331, Creater: jiasian.lin
# This is the first section of the script. Set variables
#由於個資法我把以下*號
username="*********"
remote_host="********"
password="*******"
$current_dir=$(pwd)
$directory="serverfile"
TOKEN="*********"




#設定相關資料夾 & 確認主機網路狀態
mkdir -p "$current_dir/$directory_log"
echo -e "$(date) mkdir -p $current_dir/$directory_log" >> "$current_dir/$directory_log/Summary.log" 

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


# section 2:description Establish environment
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
##section 3:description 確認主機是否正常
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

