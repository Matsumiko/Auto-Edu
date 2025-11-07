# 🤖 Auto-Edu

<div align="center">

[![Python](https://img.shields.io/badge/Python-3.6+-blue.svg)](https://www.python.org/)
[![OpenWrt](https://img.shields.io/badge/OpenWrt-Compatible-green.svg)](https://openwrt.org/)
[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](https://github.com/Matsumiko/Auto-Edu/releases)
[![Dual Mode](https://img.shields.io/badge/mode-dual-success.svg)](https://github.com/Matsumiko/Auto-Edu#-dual-mode-system)
[![Maintained](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/Matsumiko/Auto-Edu/graphs/commit-activity)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

**Sistem Otomatis Monitoring dan Perpanjangan Kuota dengan Dual Mode**

*Tidak perlu khawatir kehabisan kuota lagi - bahkan untuk pemakaian ekstrem!*

[Fitur](#-fitur) • [Instalasi](#-instalasi) • [Dual Mode](#-dual-mode-system) • [Konfigurasi](#-konfigurasi) • [Troubleshooting](#-troubleshooting)

</div>

---

## 📖 Tentang

Auto-Edu adalah sistem otomatis yang memonitor kuota paket Edu melalui SMS dan secara otomatis melakukan perpanjangan ketika kuota hampir habis. **Versi 2.0** memperkenalkan **Dual Mode System** untuk mendukung berbagai tingkat pemakaian dari normal hingga ekstrem.

### ⚡ What's New (v2.0.0)

<details>
<summary><b>🎉 NEW: Dual Mode System</b></summary>

**Dua mode monitoring untuk semua kebutuhan:**

### 🟢 EFFICIENT Mode (Default)
- ✅ **Cron**: Every 3 minutes
- ✅ **SMS Check**: 3 messages
- ✅ **Max Age**: 15 minutes
- ✅ **CPU Usage**: ~1% (very low)
- ✅ **Best for**: Normal to heavy usage (30GB/30+ minutes)
- ✅ **Logic**: Standard check (konfirmasi → kuota)

### 🔴 AGGRESSIVE Mode (Extreme)
- 🔥 **Cron**: Every 1 minute
- 🔥 **SMS Check**: 5 messages
- 🔥 **Max Age**: 5 minutes
- 🔥 **CPU Usage**: ~3% (medium)
- 🔥 **Best for**: Extreme heavy usage (30GB/5-10 minutes)
- 🔥 **Logic**: Improved check (kuota → konfirmasi)

**Pilih mode saat instalasi atau switch kapan saja!**

</details>

<details>
<summary><b>🛡️ All Previous Features Included</b></summary>

- ✅ **Anti double renewal** - SMS time-based filtering
- ✅ **Heavy usage protection** - Renewal timestamp tracking
- ✅ **Activation detection** - Auto-skip konfirmasi SMS
- ✅ **Triple verification** - 3-layer SMS filtering
- ✅ **Configurable notifications** - Prevent spam
- ✅ **Interactive setup** - Easy configuration wizard

📖 **Detail:** [FIX_DOUBLE_RENEWAL.md](FIX_DOUBLE_RENEWAL.md)

</details>

### 🙏 
Script ini adalah improved version dengan penambahan:
- **Dual Mode System** - Support normal hingga extreme usage
- Arsitektur Object-Oriented
- Error handling & retry mechanism
- Logging system
- Konfigurasi via .env file
- Setup script interaktif dengan mode selection
- Anti double-renewal & heavy usage protection

---

## ✨ Kenapa Auto-Edu?

- 🔄 **Set it and forget it** - Monitoring & renewal sepenuhnya otomatis
- 🎚️ **Dual mode** - Cocok untuk semua tingkat pemakaian (normal → extreme)
- 💬 **Notifikasi cerdas** - Alert Telegram tanpa spam
- 🛡️ **Production-ready** - Reliability 99%+ dengan retry mechanism
- 🔥 **Extreme usage ready** - Handle pemakaian 30GB/5-10 menit (aggressive mode)
- 📊 **Full visibility** - Logging lengkap untuk debugging
- ⚙️ **Highly configurable** - 15+ parameter untuk customize
- 🔒 **Secure config** - Kredensial disimpan di .env file terpisah

---

## 🎯 Fitur

### UX Excellence
✅ **Dual mode monitoring** - EFFICIENT (normal) & AGGRESSIVE (extreme)  
✅ Notifikasi **Telegram** dengan HTML & emoji  
✅ **Smart notification** - Hindari spam dengan setting granular  
✅ **Logging system** komprehensif untuk debugging  
✅ **Real-time progress tracking** dengan update status  
✅ **Error handling** robust dengan retry otomatis  
✅ **Validasi konfigurasi** otomatis sebelum running  
✅ **Timeout protection** untuk semua operasi ADB  
✅ **Log rotation** otomatis untuk hemat storage  

### Technical Excellence
✅ **Adaptive parameters** - Auto-adjust based on mode  
✅ **Object-oriented design** dengan class terpisah  
✅ **3x retry mechanism** untuk Telegram API  
✅ **Smart SMS parsing** dengan ekstraksi timestamp  
✅ **Triple verification** - 3 kriteria check untuk setiap SMS  
✅ **Renewal timestamp tracking** - Proteksi pemakaian berat  
✅ **Priority logic switching** - Different logic per mode  
✅ **Graceful fallback** - Tetap jalan walau file hilang  

---

## 🎚️ Dual Mode System

### Mode Comparison

| Feature | 🟢 EFFICIENT | 🔴 AGGRESSIVE |
|---------|--------------|---------------|
| **Cron Interval** | Every 3 minutes | Every 1 minute |
| **SMS Checked** | 3 messages | 5 messages |
| **Max SMS Age** | 15 minutes | 5 minutes |
| **Check Logic** | Standard | Improved (priority) |
| **CPU Usage** | ~1% | ~3% |
| **Handle Speed** | 30GB/30+ min | 30GB/5-10 min |
| **Detection Time** | 0-3 min | 0-1 min |
| **Best For** | 95% users | 5% extreme users |
| **Recommended** | ✅ Yes | For extreme only |

### When to Use Each Mode?

#### 🟢 Use EFFICIENT Mode When:
- Normal browsing & streaming (5-10 devices)
- Download files dengan speed normal (100-500 Mbps)
- Pemakaian predictable (30GB dalam 30-60 menit)
- Ingin hemat CPU & battery
- **Your tested scenario: 30GB/30-40 min ✅**

#### 🔴 Use AGGRESSIVE Mode When:
- Download servers atau streaming farms
- High-speed sustained downloads (1+ Gbps)
- Pemakaian sangat berat (30GB dalam 5-15 menit)
- Multiple torrents atau batch downloads
- Butuh deteksi sangat cepat (< 1 menit)

### How to Switch Mode?

**During Installation:**
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Matsumiko/Auto-Edu-DualMode/main/setup.sh)
# Pilih mode saat ditanya
```

**After Installation:**
```bash
# Edit config
vi /root/Auto-Edu/auto_edu.env

# Change this line:
MONITORING_MODE=EFFICIENT  # or AGGRESSIVE

# Update cron (important!)
crontab -e

# For EFFICIENT:
*/3 * * * * AUTO_EDU_ENV=/root/Auto-Edu/auto_edu.env python3 /root/Auto-Edu/auto_edu.py

# For AGGRESSIVE:
*/1 * * * * AUTO_EDU_ENV=/root/Auto-Edu/auto_edu.env python3 /root/Auto-Edu/auto_edu.py
```

---

## 📋 Requirements

### Hardware
- Router OpenWrt dengan port USB
- Device Android dengan USB debugging enabled
- Kabel USB OTG/standar

### Software
```bash
opkg update
opkg install python3 curl adb
```

### Setup Telegram
- Telegram Bot Token (dari [@BotFather](https://t.me/BotFather))
- Telegram Chat ID (dari [@userinfobot](https://t.me/userinfobot))

---

## 🚀 Instalasi

### ⚡ Quick Start - One Command Install (Recommended!)

Install dengan **1 perintah**:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Matsumiko/Auto-Edu-DualMode/main/setup.sh)
```

**That's it!** Installer akan:
1. ✅ Install dependencies (python3, curl)
2. ✅ Buat direktori `/root/Auto-Edu/`
3. ✅ Download script terbaru
4. ✅ **Interactive setup dengan mode selection**
5. ✅ Generate file `.env` dengan parameter adaptive
6. ✅ Test script
7. ✅ Setup cron job sesuai mode

### 📂 Struktur File Setelah Install

```
/root/Auto-Edu/              # Direktori utama
├── auto_edu.py              # Script utama (dual mode)
└── auto_edu.env             # File konfigurasi
```

### 🔄 Update dari Versi Lama

Sudah pakai versi sebelumnya? Update ke v2.0:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Matsumiko/Auto-Edu-DualMode/main/update.sh)
```

Update script akan:
- ✅ Backup script lama
- ✅ Download versi baru dengan dual mode
- ✅ Migrate config dengan mode selection
- ✅ Update cron (opsional)

---

## ⚙️ Konfigurasi

Semua konfigurasi disimpan di `/root/Auto-Edu/auto_edu.env`

**Edit konfigurasi:**
```bash
vi /root/Auto-Edu/auto_edu.env
```

### Pengaturan Wajib

```bash
# Kredensial Telegram
BOT_TOKEN=1234567890:ABCdefGHIjklMNOpqrsTUVwxyz  # Dari @BotFather
CHAT_ID=123456789                                # Dari @userinfobot

# Kode USSD (sesuaikan provider)
KODE_UNREG=*808*5*2*1*1#  # Kode unreg
KODE_BELI=*808*4*1*1*1*1#  # Kode beli
```

### Pengaturan Mode (NEW!)

```bash
# Pilih mode monitoring
MONITORING_MODE=EFFICIENT  # atau AGGRESSIVE

# EFFICIENT Mode Settings (auto-applied)
JUMLAH_SMS_CEK=3
SMS_MAX_AGE_MINUTES=15

# AGGRESSIVE Mode Settings (auto-applied)
JUMLAH_SMS_CEK_AGGRESSIVE=5
SMS_MAX_AGE_AGGRESSIVE=5
```

### Pengaturan Opsional

```bash
# Threshold kuota (GB)
THRESHOLD_KUOTA_GB=3

# Timing (detik)
JEDA_USSD=10
TIMEOUT_ADB=15

# Notifikasi
NOTIF_KUOTA_AMAN=false      # Recommend: false
NOTIF_STARTUP=false         # Recommend: false
NOTIF_DETAIL=true

# Logging
LOG_FILE=/tmp/auto_edu.log
MAX_LOG_SIZE=102400
```

### 📱 Jenis Notifikasi

| Notifikasi | Setting | Default | Penjelasan |
|-----------|---------|---------|------------|
| 🚀 Script Started | `NOTIF_STARTUP` | `false` | Dikirim setiap script jalan |
| ✅ Kuota Aman | `NOTIF_KUOTA_AMAN` | `false` | Dikirim saat kuota masih cukup |
| ⚠️ Kuota Habis | *Always ON* | - | **Selalu dikirim** saat kuota < threshold |
| 🔄 Proses Renewal | *Always ON* | - | **Selalu dikirim** saat renewal |
| ✅/❌ Hasil Renewal | *Always ON* | - | **Selalu dikirim** setelah renewal |
| ❌ Error/Warning | *Always ON* | - | **Selalu dikirim** saat ada masalah |

---

## 🎮 Penggunaan

### Eksekusi Manual

Test script secara manual:
```bash
python3 /root/Auto-Edu/auto_edu.py
```

### Monitoring Otomatis (Cron)

Installer sudah setup cron otomatis. Untuk edit manual:

```bash
# Edit crontab
crontab -e
```

**Cron untuk EFFICIENT Mode:**
```bash
*/3 * * * * AUTO_EDU_ENV=/root/Auto-Edu/auto_edu.env python3 /root/Auto-Edu/auto_edu.py
```

**Cron untuk AGGRESSIVE Mode:**
```bash
*/1 * * * * AUTO_EDU_ENV=/root/Auto-Edu/auto_edu.env python3 /root/Auto-Edu/auto_edu.py
```

### Monitoring & Debugging

```bash
# Lihat log real-time
tail -f /tmp/auto_edu.log

# Cek mode yang aktif
grep MONITORING_MODE /root/Auto-Edu/auto_edu.env

# Cek renewal timestamp (heavy usage protection)
cat /tmp/auto_edu_last_renewal

# Lihat cron jobs aktif
crontab -l

# Edit konfigurasi
vi /root/Auto-Edu/auto_edu.env

# Restart script (test ulang)
python3 /root/Auto-Edu/auto_edu.py
```

---

## 📱 Notifikasi Telegram

### Notifikasi Startup (Opsional - Mode Indicator)

#### EFFICIENT Mode:
```
🚀 Script Started

Auto Edu monitoring dimulai
Mode: 🟢 EFFICIENT
Threshold: 3GB
SMS Check: 3 messages
Max Age: 15 menit

⏱ 07/11/2025 14:30:00
```

#### AGGRESSIVE Mode:
```
🚀 Script Started

Auto Edu monitoring dimulai
Mode: 🔴 AGGRESSIVE
Threshold: 3GB
SMS Check: 5 messages
Max Age: 5 menit

⏱ 07/11/2025 14:30:00
```

### Notifikasi Renewal (Always Sent)

```
⚠️ Kuota Hampir Habis!

Kuota Edu Anda kurang dari 3GB.
Memulai proses renewal otomatis...

SMS Terakhir:
Sisa kuota EduConference 30GB Anda kurang dari 3GB...

⏱ 07/11/2025 14:30:00
```

```
🎉 Renewal ✅ Berhasil

✅ USSD '*808*5*2*1*1#' terkirim
✅ USSD '*808*4*1*1*1*1#' terkirim

📱 SMS Terbaru:

SMS #1
📤 PROVIDER
🕐 07/11/2025 14:32
💬 Paket EduConference 30GB berhasil diaktifkan...

⏱ 07/11/2025 14:35:00
```

---

## 🔍 Troubleshooting

<details>
<summary><b>Script tidak jalan</b></summary>

**Cek instalasi:**
```bash
which python3
which adb
adb devices
```

**Cek permissions:**
```bash
ls -l /root/Auto-Edu/auto_edu.py
chmod +x /root/Auto-Edu/auto_edu.py
chmod 600 /root/Auto-Edu/auto_edu.env
```

</details>

<details>
<summary><b>Mode tidak berubah</b></summary>

**Pastikan:**
1. Edit `/root/Auto-Edu/auto_edu.env`
2. Ubah `MONITORING_MODE=AGGRESSIVE` (atau EFFICIENT)
3. **Update cron** sesuai mode!
   ```bash
   crontab -e
   # Ubah interval: */1 untuk AGGRESSIVE, */3 untuk EFFICIENT
   ```
4. Test manual:
   ```bash
   python3 /root/Auto-Edu/auto_edu.py
   ```

</details>

<details>
<summary><b>Kuota habis sangat cepat (< 5 menit) tapi tidak renewal</b></summary>

**Solusi:**
1. Switch ke AGGRESSIVE mode:
   ```bash
   vi /root/Auto-Edu/auto_edu.env
   # Set: MONITORING_MODE=AGGRESSIVE
   ```

2. Update cron ke 1 menit:
   ```bash
   crontab -e
   # Change to: */1 * * * * ...
   ```

3. Test:
   ```bash
   python3 /root/Auto-Edu/auto_edu.py
   tail -f /tmp/auto_edu.log
   ```

Expected log:
```
[INFO] Mode: AGGRESSIVE - Priority kuota check
[WARN] ⚠️ KUOTA RENDAH TERDETEKSI!
```

</details>

<details>
<summary><b>CPU usage tinggi</b></summary>

**Jika pakai AGGRESSIVE mode dan CPU tinggi:**

1. **Check apakah benar-benar perlu AGGRESSIVE**
   - Apakah pemakaian benar-benar > 30GB/10 menit?
   - Jika tidak, switch ke EFFICIENT

2. **Optimize interval:**
   ```bash
   # Coba 2 menit (middle ground)
   */2 * * * * ...
   ```

3. **Check processes:**
   ```bash
   top | grep python
   ps aux | grep auto_edu
   ```

Catatan: CPU usage normal:
- EFFICIENT: ~1%
- AGGRESSIVE: ~3%

</details>

<details>
<summary><b>Untuk troubleshooting lainnya</b></summary>

Lihat dokumentasi lengkap di [FIX_DOUBLE_RENEWAL.md](FIX_DOUBLE_RENEWAL.md)

</details>

---

## 📊 Exit Codes

| Code | Keterangan |
|------|-----------|
| `0` | Sukses - kuota aman atau renewal berhasil |
| `1` | Error - masalah config, ADB error, dll |
| `130` | Interrupted - dihentikan user (Ctrl+C) |

---

## 🎯 Best Practices

### Pemilihan Mode yang Tepat

| Skenario | Mode | Cron | Alasan |
|----------|------|------|--------|
| Rumah tangga (5-10 devices) | EFFICIENT | 3 min | Hemat CPU, cukup responsif |
| Office kecil (10-20 users) | EFFICIENT | 3 min | Balance performance & resource |
| Download server | AGGRESSIVE | 1 min | Butuh deteksi sangat cepat |
| Streaming farm | AGGRESSIVE | 1 min | Pemakaian sangat tinggi |
| Testing/Development | EFFICIENT | 5 min | Hemat resource saat testing |

### Tips Keamanan

1. **Lindungi kredensial:**
   ```bash
   chmod 600 /root/Auto-Edu/auto_edu.env
   ```

2. **Backup konfigurasi:**
   ```bash
   cp /root/Auto-Edu/auto_edu.env /root/Auto-Edu/auto_edu.env.backup
   ```

3. **Gunakan chat ID private** (bukan group chat)

4. **Jangan commit credentials ke Git**

### Tips Optimasi

- **Start dengan EFFICIENT** - Upgrade ke AGGRESSIVE hanya jika benar-benar perlu
- **Monitor CPU usage** - Pastikan tidak overload
- **Disable notif spam** - Set `NOTIF_STARTUP=false` dan `NOTIF_KUOTA_AMAN=false`
- **Setup log rotation** untuk deployment jangka panjang
- **Review logs** berkala untuk optimize parameter

---

## 🆚 Perbandingan dengan Versi Sebelumnya

| Fitur | v1.x | v2.0 (Auto-Edu) |
|-------|------|-----------------|
| **Monitoring Mode** | Single | **Dual (Efficient/Aggressive)** |
| **SMS Check** | 3 fixed | **3-5 adaptive** |
| **Max SMS Age** | 15 min | **5-15 min adaptive** |
| **Check Logic** | Standard | **Dual (standard + improved)** |
| **CPU Usage** | ~1% | **1-3% (mode-based)** |
| **Handle Speed** | 30GB/30 min | **30GB/5-30 min** |
| **Cron Flexibility** | Fixed | **Adaptive (1-3 min)** |
| **Extreme Support** | Limited | **Full support** |
| **Mode Switching** | ❌ | ✅ **On-the-fly** |
| **Success Rate** | ~99% | **~99%+ (both modes)** |

---

## 🗑️ Uninstall

### Stop Sementara
```bash
# Remove cron job
crontab -l | grep -v "auto_edu.py" | crontab -
```

### Uninstall Complete
```bash
# One-liner dengan backup
bash <(curl -fsSL https://raw.githubusercontent.com/Matsumiko/Auto-Edu-DualMode/main/uninstall.sh)

# Atau manual
rm -rf /root/Auto-Edu/
rm -f /tmp/auto_edu.log /tmp/auto_edu_last_renewal
crontab -l | grep -v "auto_edu.py" | crontab -
```

---

## 🤝 Contributing

Kontribusi sangat welcome! 

1. 🍴 Fork repository ini
2. 🔧 Buat feature branch (`git checkout -b feature/AmazingFeature`)
3. ✅ Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. 📤 Push ke branch (`git push origin feature/AmazingFeature`)
5. 🎉 Buat Pull Request

### Ideas untuk Kontribusi

- [ ] Web UI untuk monitoring
- [ ] Support multi-device
- [ ] Support provider lain
- [ ] Mode auto-switching based on usage
- [ ] Statistics dashboard
- [ ] Mobile app integration

---

## 📞 Support

- 📖 **Dokumentasi**: Baca [README](README.md) dan [FIX_DOUBLE_RENEWAL](FIX_DOUBLE_RENEWAL.md)
- 🐛 **Bug Reports**: [Buka issue](https://github.com/Matsumiko/Auto-Edu/issues)
- 💡 **Feature Requests**: [Start discussion](https://github.com/Matsumiko/Auto-Edu/discussions)
- ⭐ **Suka project ini?** Kasih star!

---

## 🙏 Acknowledgments

- **Original Script**: [@zifahx](https://pastebin.com/ZbXMvX4D)
- **OpenWrt Community**: Untuk platform yang luar biasa
- **Contributors**: Semua yang telah berkontribusi

---

## 📈 Project Stats

![GitHub stars](https://img.shields.io/github/stars/Matsumiko/Auto-Edu?style=social)
![GitHub forks](https://img.shields.io/github/forks/Matsumiko/Auto-Edu?style=social)
![GitHub issues](https://img.shields.io/github/issues/Matsumiko/Auto-Edu)
![GitHub last commit](https://img.shields.io/github/last-commit/Matsumiko/Auto-Edu)

---

<div align="center">

**Dibuat dengan ❤️ untuk komunitas**

**Edited Version By Matsumiko**

*Jika ini membantu Anda, tolong berikan ⭐ star!*

[⬆ Kembali ke atas](#-auto-edu)

</div>