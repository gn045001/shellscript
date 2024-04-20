#/bin/bash
#= version: 0.1, date: 20240420, Creater: jiasian.lin
#section 1:執行環境的資料夾之環境變數
HOMEDIR=/home/$USER
directory="DackerData"
hour=$(date +'%Y%m%d-%H')

echo "$(date) $HOMEDIR/$directory/raw/ComputerStart.json 複製資料至dockerstats/raw 要建立${hour}-ComputerStart.json." >> "$HOMEDIR/$directory/log/Summary.log" 
cp  $HOMEDIR/DackerData/raw/ComputerStart.json $HOMEDIR/dockerstats/raw/$hour-ComputerStart.json
echo "$(date) $HOMEDIR/$directory/raw/ComputerStart.json 複製資料至dockerstats/raw 建立完畢${hour}-ComputerStart.json." >> "$HOMEDIR/$directory/log/Summary.log" 

echo "$(date) $HOMEDIR/$directory/raw/ComputerStart.json 複製資料至diskrepoet/raw 要建立${hour}-ComputerStart.json." >> "$HOMEDIR/$directory/log/Summary.log" 
cp  $HOMEDIR/DackerData/raw/ComputerStart.json $HOMEDIR/diskrepoet/raw/$hour-ComputerStart.json
echo "$(date) $HOMEDIR/$directory/raw/ComputerStart.json 複製資料至diskrepoet/raw 建立完畢${hour}-ComputerStart.json." >> "$HOMEDIR/$directory/log/Summary.log" 

echo "$(date) $HOMEDIR/$directory/raw/ComputerStart.json 複製資料至report/raw 要建立${hour}-ComputerStart.json." >> "$HOMEDIR/$directory/log/Summary.log" 
cp  $HOMEDIR/DackerData/raw/ComputerStart.json $HOMEDIR/report/raw/$hour-ComputerStart.json
echo "$(date) $HOMEDIR/$directory/raw/ComputerStart.json 複製資料至report/raw 建立完畢${hour}-ComputerStart.json." >> "$HOMEDIR/$directory/log/Summary.log" 

echo "$(date) $HOMEDIR/$directory/raw/ComputerStart.json 複製資料至InputmemorydataMongoDB/raw 要建立${hour}-ComputerStart.json." >> "$HOMEDIR/$directory/log/Summary.log" 
cp  $HOMEDIR/DackerData/raw/ComputerStart.json $HOMEDIR/InputmemorydataMongoDB/raw/$hour-ComputerStart.json
echo "$(date) $HOMEDIR/$directory/raw/ComputerStart.json 複製資料至InputmemorydataMongoDB/raw 建立完畢${hour}-ComputerStart.json." >> "$HOMEDIR/$directory/log/Summary.log"

echo "$(date) $HOMEDIR/$directory/raw/ComputerStart.json 複製資料至InputCPUdataMongoDB/raw 要建立${hour}-ComputerStart.json." >> "$HOMEDIR/$directory/log/Summary.log" 
cp  $HOMEDIR/DackerData/raw/ComputerStart.json $HOMEDIR/InputCPUdataMongoDB/raw/$hour-ComputerStart.json
echo "$(date) $HOMEDIR/$directory/raw/ComputerStart.json 複製資料至InputCPUdataMongoDB/raw 建立完畢${hour}-ComputerStart.json." >> "$HOMEDIR/$directory/log/Summary.log"

#section 2: 刪除檔案
echo -e "$(date) $HOMEDIR/$directory/raw/ComputerStart.json 刪除資料" >> "$HOMEDIR/$directory/log/Summary.log" 
rm -rf  $HOMEDIR/DackerData/raw/ComputerStart.json
echo -e "$(date) $HOMEDIR/$directory/raw/ComputerStart.json 資料刪除完畢" >> "$HOMEDIR/$directory/log/Summary.log" 
