#/bin/bash
#= version: 0.1, date: 20240420, Creater: jiasian.lin
#建立環境
for i in InputCPUdataMongoDB InputmemorydataMongoDB report diskreport dockerstats; 
do
    mkdir -p $i/{raw,processed,log,report,nodejs}
done