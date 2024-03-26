#!/bin/bash
#fastp 軟體的位置
fastp='/pkg/biology/fastp/fastp_v0.20.0/fastp'

## option parser for linux bash shell
while getopts 'p:n:f:F:a:t:T:R:o:s:' argv
do
  case $argv in 
    p) projDir=$OPTARG ;;
    n) sampleName=$OPTARG ;;
    f) trim_front1="--trim_front1 $OPTARG" ;;
    F) trim_front2="--trim_front2 $OPTARG" ;;
    t) trim_tail1="--trim_tail1 $OPTARG" ;;
    T) trim_tail2="--trim_tail2 $OPTARG" ;;
    a) adapter_fasta="--adapter_fasta $OPTARG" ;;
    R) reads_to_process="--reads_to_process $OPTARG" ;;
    o) out=$OPTARG ;;
    s) Sequencing=$OPTARG ;;
  esac
done

if [ -z "$projDir" ]; then
  echo "Error: project folder not set"
  exit 1
fi

if [ -z "$sampleName" ]; then
  echo "Error: sample name not set"
  exit 1
fi

if [ -z "$adapter_fasta" ]; then
  adapter_fasta=''
fi

if [ -z "$trim_front1" ]; then
  trim_front1=''
fi

if [ -z "$trim_front2" ]; then
  trim_front2=''
fi

if [ -z "$trim_tail1" ]; then
  trim_tail1=''
fi

if [ -z "$trim_tail2" ]; then
  trim_tail2=''
fi

if [ -z "$reads_to_process" ]; then
  reads_to_process=''
fi

if [ -z "$out" ]; then
  out=''
else
  if [ "$Sequencing" == "PE" ]; then
    unpaired="--unpaired1 raw/$sampleName-$out_unpaired_R1.fastq.gz --unpaired2 raw/$sampleName-$out_unpaired_R2.fastq.gz"
    out="--out1 raw/$sampleName-$out_R1.fastq.gz --out2 raw/$sampleName-$out_R2.fastq.gz $unpaired"
  elif [ "$Sequencing" == "SE" ]; then
    unpaired="--unpaired1 raw/$sampleName-$out_unpaired_R1.fastq.gz"
    out="--out1 raw/$sampleName-$out_R1.fastq.gz $unpaired"
  else
    echo "Error: Reference genome '$Sequencing' is not supported."
    exit 1
  fi
fi

# project folder
cd "$projDir" 
# fastp instruction
if [ "$Sequencing" == "PE" ]; then
  # 如果是 PE (paired-end) 测序方式
  $fastp -i "raw/$sampleName"_R1.fastq.gz \  # 輸入的 R1 序列文件
    -I "raw/$sampleName"_R2.fastq.gz \        # 輸入的 R2 序列文件
    $out $trim_front1 $trim_front2 $trim_tail1 $trim_tail2 \  # 輸出文件以及修剪參數
    $adapter_fasta $reads_to_process \        # 适配器序列文件以及處理讀數的參數
    -j "QC/$sampleName.json" \                # 輸出的 JSON 格式的 QC 結果
    -h "QC/$sampleName.html"                  # 輸出的 HTML 格式的 QC 結果
elif [ "$Sequencing" == "SE" ]; then
  # 如果是 SE (single-end) 测序方式
  $fastp -i "raw/$sampleName"_R1.fastq.gz \  # 輸入的 R1 序列文件
    $out $trim_front1 $trim_tail1 \           # 輸出文件以及修剪參數
    $adapter_fasta $reads_to_process \        # 适配器序列文件以及處理讀數的參數
    -j "QC/$sampleName.json" \                # 輸出的 JSON 格式的 QC 結果
    -h "QC/$sampleName.html"                  # 輸出的 HTML 格式的 QC 結果
fi

if [ $? -eq 0 ]; then
  # 如果 fastp 執行成功
  echo -e "$(date)\t$sampleName\tfastp\tDone" >> "log/Summary.log"  # 將執行成功的訊息記錄到日誌中
else
  # 如果 fastp 執行失敗
  echo -e "$(date)\t$sampleName\tfastp\tStop" >> "log/Summary.log"  # 將執行失敗的訊息記錄到日誌中
  # 移動未處理的文件到臨時目錄中，以示後續處理
  mv "raw/$sampleName-$out_R1.fastq.gz" "temp/$sampleName-$out_R1.fastq.gz.err"
  mv "raw/$sampleName-$out_R2.fastq.gz" "temp/$sampleName-$out_R2.fastq.gz.err"
  # 如果是 PE 测序方式，還需要移動未匹配的 R1、R2 序列文件
  if [ "$Sequencing" == "PE" ]; then
    mv "raw/$sampleName-$out_unpaired_R1.fastq.gz" "temp/$sampleName-$out_unpaired_R1.fastq.gz.err"
    mv "raw/$sampleName-$out_unpaired_R2.fastq.gz" "temp/$sampleName-$out_unpaired_R2.fastq.gz.err"
  fi
  exit 1  # 終止腳本執行，返回非零的退出碼
fi

