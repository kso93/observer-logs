#!/data/data/com.termux/files/usr/bin/bash

timestamp=$(date '+%Y-%m-%d %H:%M:%S')
logfile="$HOME/remote_detect_log.txt"

echo "[$timestamp] ตรวจสอบการเชื่อมต่อ..." >> "$logfile"

# ตรวจจับ Hotspot / AP ปลอม
echo ">> Wi-Fi scan:" >> "$logfile"
termux-wifi-scaninfo | grep -i 'SSID\|capabilities' >> "$logfile"

# ตรวจสอบอุปกรณ์ Bluetooth ที่เชื่อม
echo ">> Bluetooth devices:" >> "$logfile"
termux-bluetooth | grep 'name\|mac' >> "$logfile"

# ตรวจสอบ netstat
echo ">> Active network ports:" >> "$logfile"
netstat -tnp | grep ESTABLISHED >> "$logfile"

# ตรวจจับ DNS Hijack
echo ">> DNS Test:" >> "$logfile"
curl -s --max-time 5 https://cloudflare-dns.com/dns-query -o /dev/null && echo "DNS OK" || echo "DNS FAIL" >> "$logfile"

# แจ้งเตือนทันทีบนหน้าจอ
termux-toast -g middle -b red -c white "พบการตรวจสอบระบบ! (เช็ค log)"

# ส่งอีเมล (เปิดใช้งานภายหลังได้)
# curl -s -X POST https://api.yourdomain/send_alert -d
cat ~/remote_detect_log.txt | tail -n 50 | msmtp ksov93@gmail.com
