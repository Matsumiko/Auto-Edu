#!/bin/sh

# =============================================================================
# Auto Edu - One-Liner Installer for OpenWrt (DUAL MODE)
# =============================================================================
# Edited Version by: Matsumiko
#
# Quick Install:
# bash <(curl -fsSL https://raw.githubusercontent.com/Matsumiko/Auto-Edu-DualMode/main/setup.sh)
# =============================================================================

set -e

INSTALL_DIR="/root/Auto-Edu"
SCRIPT_FILE="$INSTALL_DIR/auto_edu.py"
ENV_FILE="$INSTALL_DIR/auto_edu.env"
LOG_FILE="/tmp/auto_edu.log"
REPO_RAW="https://raw.githubusercontent.com/Matsumiko/Auto-Edu-DualMode/main"

print_success() { echo "✓ $1"; }
print_error() { echo "✗ $1"; }
print_warning() { echo "⚠ $1"; }
print_info() { echo "ℹ $1"; }

clear
cat << 'EOF'
════════════════════════════════════════════
   AUTO EDU - ONE-LINER INSTALLER
     Edited Version by: Matsumiko
   
   ✨ Dual Mode System
   🟢 EFFICIENT | 🔴 AGGRESSIVE
════════════════════════════════════════════
EOF
echo ""

[ "$(id -u)" != "0" ] && { print_error "Run as root!"; exit 1; }

# STEP 1: Install dependencies
echo "▶ STEP 1/8: Installing Dependencies"
opkg update > /dev/null 2>&1 && print_success "Updated" || print_warning "Skip update"
for pkg in python3 curl; do
    opkg list-installed 2>/dev/null | grep -q "^$pkg " && print_success "$pkg OK" || {
        print_info "Installing $pkg..."
        opkg install $pkg > /dev/null 2>&1 && print_success "$pkg installed" || { print_error "Failed $pkg"; exit 1; }
    }
done
command -v adb > /dev/null 2>&1 && print_success "ADB: $(command -v adb)" || print_warning "ADB not found"
echo ""

# STEP 2: Create directory
echo "▶ STEP 2/8: Creating Directory"
if [ -d "$INSTALL_DIR" ]; then
    print_warning "$INSTALL_DIR exists"
    read -p "Backup and recreate? (y/n) [n]: " recreate
    if [ "$recreate" = "y" ]; then
        mv "$INSTALL_DIR" "${INSTALL_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$INSTALL_DIR"
        print_success "Recreated with backup"
    fi
else
    mkdir -p "$INSTALL_DIR"
    print_success "Created: $INSTALL_DIR"
fi
echo ""

# STEP 3: Download script
echo "▶ STEP 3/8: Downloading Script"
if curl -fsSL "$REPO_RAW/auto_edu.py" -o "$SCRIPT_FILE" 2>/dev/null; then
    chmod +x "$SCRIPT_FILE"
    print_success "Downloaded: $SCRIPT_FILE"
else
    print_error "Download failed! Check connection"
    exit 1
fi
echo ""

# STEP 4: Configure
echo "▶ STEP 4/8: Configuration"
if [ -f "$ENV_FILE" ]; then
    read -p "Config exists. Use old? (y/n) [y]: " use_old
    use_old=${use_old:-y}
    [ "$use_old" = "y" ] && { print_success "Using existing config"; echo ""; } && SKIP_CONFIG=1
fi

if [ "$SKIP_CONFIG" != "1" ]; then
    echo "PANDUAN:"
    echo "📱 Bot Token: @BotFather → /newbot"
    echo "🆔 Chat ID: @userinfobot → Copy ID"
    echo ""
    
    while true; do
        printf "Bot Token: "; read BOT_TOKEN
        [ -n "$BOT_TOKEN" ] && break || print_error "Required!"
    done
    
    while true; do
        printf "Chat ID: "; read CHAT_ID
        [ -n "$CHAT_ID" ] && break || print_error "Required!"
    done
    
    printf "USSD Unreg [*808*5*2*1*1#]: "; read KODE_UNREG
    KODE_UNREG=${KODE_UNREG:-"*808*5*2*1*1#"}
    
    printf "USSD Beli [*808*4*1*1*1*1#]: "; read KODE_BELI
    KODE_BELI=${KODE_BELI:-"*808*4*1*1*1*1#"}
    
    printf "Threshold GB [3]: "; read THRESHOLD
    THRESHOLD=${THRESHOLD:-3}
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "MONITORING MODE SELECTION"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Pilih mode monitoring sesuai pemakaian Anda:"
    echo ""
    echo "1) 🟢 EFFICIENT Mode (Recommended)"
    echo "   • Cron: Every 3 minutes"
    echo "   • SMS Check: 3 messages"
    echo "   • Max SMS Age: 15 minutes"
    echo "   • CPU Usage: Low (~1%)"
    echo "   • Best for: Normal to heavy usage"
    echo "   • Can handle: 30GB/30+ minutes"
    echo ""
    echo "2) 🔴 AGGRESSIVE Mode (Extreme)"
    echo "   • Cron: Every 1 minute"
    echo "   • SMS Check: 5 messages"
    echo "   • Max SMS Age: 5 minutes"
    echo "   • CPU Usage: Medium (~3%)"
    echo "   • Best for: Extreme heavy usage"
    echo "   • Can handle: 30GB/5-10 minutes"
    echo ""
    printf "Pilih mode [1]: "; read mode_choice
    mode_choice=${mode_choice:-1}
    
    if [ "$mode_choice" = "2" ]; then
        MONITORING_MODE="AGGRESSIVE"
        CRON_INTERVAL="*/1 * * * *"
        SMS_CHECK=5
        SMS_MAX_AGE=5
        print_warning "AGGRESSIVE mode selected"
        print_info "Note: Higher CPU usage (~3%)"
    else
        MONITORING_MODE="EFFICIENT"
        CRON_INTERVAL="*/3 * * * *"
        SMS_CHECK=3
        SMS_MAX_AGE=15
        print_success "EFFICIENT mode selected (recommended)"
    fi
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "NOTIFICATION SETTINGS"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_info "Rekomendasi: pilih 'n' untuk kedua notifikasi (hindari spam)"
    echo ""
    
    printf "Kirim notif saat script start? (y/n) [n]: "; read NOTIF_STARTUP_INPUT
    NOTIF_STARTUP_INPUT=${NOTIF_STARTUP_INPUT:-n}
    if [ "$NOTIF_STARTUP_INPUT" = "y" ] || [ "$NOTIF_STARTUP_INPUT" = "Y" ]; then
        NOTIF_STARTUP="true"
        print_warning "Notif startup: AKTIF (bisa spam!)"
    else
        NOTIF_STARTUP="false"
        print_success "Notif startup: NONAKTIF"
    fi
    
    printf "Kirim notif saat kuota aman? (y/n) [n]: "; read NOTIF_AMAN_INPUT
    NOTIF_AMAN_INPUT=${NOTIF_AMAN_INPUT:-n}
    if [ "$NOTIF_AMAN_INPUT" = "y" ] || [ "$NOTIF_AMAN_INPUT" = "Y" ]; then
        NOTIF_KUOTA_AMAN="true"
        print_warning "Notif kuota aman: AKTIF (bisa spam!)"
    else
        NOTIF_KUOTA_AMAN="false"
        print_success "Notif kuota aman: NONAKTIF"
    fi
    echo ""
    
    cat > "$ENV_FILE" << EOF
# Auto Edu Config - $(date)
# Edited Version by: Matsumiko

# Telegram Configuration
BOT_TOKEN=$BOT_TOKEN
CHAT_ID=$CHAT_ID

# USSD Codes
KODE_UNREG=$KODE_UNREG
KODE_BELI=$KODE_BELI

# Quota Settings
THRESHOLD_KUOTA_GB=$THRESHOLD

# ============================================================================
# MONITORING MODE CONFIGURATION
# ============================================================================
# Mode: EFFICIENT (default) atau AGGRESSIVE (extreme)
MONITORING_MODE=$MONITORING_MODE

# EFFICIENT Mode Settings (auto-applied when mode=EFFICIENT)
JUMLAH_SMS_CEK=3
SMS_MAX_AGE_MINUTES=15

# AGGRESSIVE Mode Settings (auto-applied when mode=AGGRESSIVE)
JUMLAH_SMS_CEK_AGGRESSIVE=5
SMS_MAX_AGE_AGGRESSIVE=5

# ============================================================================

# Timing Settings (seconds)
JEDA_USSD=10
TIMEOUT_ADB=15

# Notification Settings
NOTIF_KUOTA_AMAN=$NOTIF_KUOTA_AMAN
NOTIF_STARTUP=$NOTIF_STARTUP
NOTIF_DETAIL=true

# Logging
LOG_FILE=$LOG_FILE
MAX_LOG_SIZE=102400
EOF
    chmod 600 "$ENV_FILE"
    print_success "Config saved"
    echo ""
    print_info "Mode dipilih: $MONITORING_MODE"
    if [ "$MONITORING_MODE" = "AGGRESSIVE" ]; then
        echo "  • Cron: Every 1 minute"
        echo "  • SMS Check: 5 messages"
        echo "  • Max Age: 5 minutes"
    else
        echo "  • Cron: Every 3 minutes"
        echo "  • SMS Check: 3 messages"
        echo "  • Max Age: 15 minutes"
    fi
    echo ""
    print_info "Notif yang TETAP dikirim:"
    echo "  • ⚠️  Kuota hampir habis"
    echo "  • 🔄 Proses renewal"
    echo "  • ✅/❌ Hasil renewal"
    echo "  • ❌ Error konfigurasi/koneksi"
fi
echo ""

# STEP 5: Test
echo "▶ STEP 5/8: Testing"
read -p "Run test? (y/n) [y]: " test
test=${test:-y}
if [ "$test" = "y" ]; then
    print_info "Testing..."
    echo "══════════════════════"
    AUTO_EDU_ENV="$ENV_FILE" python3 "$SCRIPT_FILE" && print_success "Test OK!" || print_warning "Check errors"
    echo "══════════════════════"
fi
echo ""

# STEP 6: Cron
echo "▶ STEP 6/8: Setup Cron"

if [ -z "$CRON_INTERVAL" ]; then
    echo "1) Every 3 min (EFFICIENT - recommended)"
    echo "2) Every 5 min"
    echo "3) Every 1 min (AGGRESSIVE)"
    echo "4) Every 15 min"
    echo "5) Skip"
    printf "Choice [1]: "; read cron_choice
    cron_choice=${cron_choice:-1}
    
    case $cron_choice in
        1) CRON_INTERVAL="*/3 * * * *" ;;
        2) CRON_INTERVAL="*/5 * * * *" ;;
        3) CRON_INTERVAL="*/1 * * * *" ;;
        4) CRON_INTERVAL="*/15 * * * *" ;;
        *) CRON_INTERVAL="" ;;
    esac
fi

if [ -n "$CRON_INTERVAL" ]; then
    crontab -l 2>/dev/null | grep -v "auto_edu.py" | crontab - 2>/dev/null || true
    (crontab -l 2>/dev/null; echo "$CRON_INTERVAL AUTO_EDU_ENV=$ENV_FILE python3 $SCRIPT_FILE") | crontab -
    /etc/init.d/cron restart > /dev/null 2>&1 || true
    print_success "Cron: $CRON_INTERVAL"
fi
echo ""

# STEP 7: Summary
echo "▶ STEP 7/8: Done!"
echo ""
echo "✓ INSTALLATION COMPLETE!"
echo ""
echo "📂 Directory: $INSTALL_DIR"
echo "   ├── auto_edu.py"
echo "   └── auto_edu.env"
echo ""

if [ -n "$MONITORING_MODE" ]; then
    if [ "$MONITORING_MODE" = "AGGRESSIVE" ]; then
        echo "🔴 Mode: AGGRESSIVE (Extreme Heavy Usage)"
        echo "   • Cron: Every 1 minute"
        echo "   • SMS: 5 messages scan"
        echo "   • Age: 5 minutes max"
        echo "   • CPU: ~3% usage"
        echo "   • Handle: 30GB/5-10 minutes"
    else
        echo "🟢 Mode: EFFICIENT (Recommended)"
        echo "   • Cron: Every 3 minutes"
        echo "   • SMS: 3 messages scan"
        echo "   • Age: 15 minutes max"
        echo "   • CPU: ~1% usage"
        echo "   • Handle: 30GB/30+ minutes"
    fi
    echo ""
fi

echo "📝 Log: $LOG_FILE"
[ -n "$CRON_INTERVAL" ] && echo "⏰ Cron: $CRON_INTERVAL"
echo ""
echo "Commands:"
echo "  Test: python3 $SCRIPT_FILE"
echo "  Logs: tail -f $LOG_FILE"
echo "  Edit: vi $ENV_FILE"
echo ""

if [ "$MONITORING_MODE" = "EFFICIENT" ]; then
    echo "💡 Tips:"
    echo "  • Mode EFFICIENT cocok untuk 95% pengguna"
    echo "  • Ganti ke AGGRESSIVE jika pemakaian > 30GB/10 menit"
    echo "  • Edit $ENV_FILE → ubah MONITORING_MODE=AGGRESSIVE"
    echo ""
fi

print_success "Auto Edu running! 🚀"
echo ""
echo "Edited Version by: Matsumiko"