#!/bin/bash
WORKDIR="/root/cfst"
cd "$WORKDIR" || exit

LOGFILE="$WORKDIR/run.log"
exec >>"$LOGFILE" 2>&1
echo "==================== $(date '+%F %T') ===================="

# Step 1: 下载最新 ip.txt
curl -L -o ip.txt https://hk.gh-proxy.com/https://raw.githubusercontent.com/jianghu88/cfipcaiji/refs/heads/main/ip.txt

# Step 2: 运行测速（速度>=5MB/s，保留前30条，测速地址自定义）
mkdir -p history
HIST_FILE="history/result_$(date +%F_%H-%M-%S).csv"
./cfst -f ip.txt -n 200 -t 4 -sl 5 -dn 1 -url https://speedtest.055500.xyz -o "$HIST_FILE"

# Step 3: 更新根目录最新文件
cp -f "$HIST_FILE" result.csv
echo "[INFO] 最新结果保存到 result.csv，并归档为 $HIST_FILE"

# Step 4: 提交到 GitHub
git pull origin main --allow-unrelated-histories
git add result.csv "$HIST_FILE"
git commit -m "Update result.csv $(date +%F_%T)"
git push origin main
