#!/bin/sh

# =============================================================================
# Auto Edu - Update Script (Dual Mode Support)
# =============================================================================
# Edited Version by: Matsumiko
#
# Quick Update:
# bash <(curl -fsSL https://raw.githubusercontent.com/Matsumiko/Auto-Edu-DualMode/main/update.sh)
# =============================================================================

set -e

INSTALL_DIR="/root/Auto-Edu"
SCRIPT_FILE="$INSTALL_DIR/auto_edu.py"
ENV_FILE="$INSTALL_DIR/auto_edu.env"
BACKUP_DIR="$INSTALL_DIR/backup"
REPO_RAW="https://raw.githubusercontent.com/Matsumiko/Auto-Edu-DualMode/main"

print_success() { echo "✓ $1"; }
print_error() { echo "✗ $1"; }
print_warning() { echo "⚠ $1"; }
print_info() { echo "ℹ $1"; }

clear
cat << 'EOF'
════════════════════════════════════════════
   AUTO EDU - UPDATE SCRIPT
   Dual Mode System Support
     Edited Version by: Matsumiko
════════════════════════════════════════════
EOF
echo ""

[ "$(id -u)" != "0" ] && { print_error "Run as root!"; exit 1; }

# Check if already installed
if [ ! -f "$SCRIPT_FILE" ]; then
    print_error "Auto Edu not found! Install first:"
    echo "bash <(curl -fsSL https://raw.githubusercontent.com/Matsumiko/Auto-Edu-DualMode/main/setup.sh)"
    exit 1
fi

echo "▶ STEP 1/5: Backup"
read -p "Backup script lama? (y/n) [y]: " backup_choice
backup_choice=${backup_choice:-y}

if [ "$backup_choice" = "y" ] || [ "$backup_choice" = "Y" ]; then
    mkdir -p "$BACKUP_DIR"
    BACKUP_FILE="$BACKUP_DIR/auto_edu_$(date +%Y%m%d_%H%M%S).py"
    cp "$SCRIPT_FILE" "$BACKUP_FILE"
    
    if [ -f "$ENV_FILE" ]; then
        BACKUP_ENV="$BACKUP_DIR/auto_edu_$(date +%Y%m%d_%H%M%S).env"
        cp "$ENV_FILE" "$BACKUP_ENV"
        print_success "Backup: $BACKUP_FILE & $BACKUP_ENV"
    else
        print_success "Backup: $BACKUP_FILE"
    fi
else
    print_warning "Skip backup (not recommended!)"
    BACKUP_FILE=""
fi
echo ""

echo "▶ STEP 2/5: Download Fixed Script"
if curl -fsSL "$REPO_RAW/auto_edu.py" -o "$SCRIPT_FILE" 2>/dev/null; then
    chmod +x "$SCRIPT_FILE"
    print_success "Downloaded dual mode version"
else
    print_error "Download failed!"
    
    if [ -n "$BACKUP_FILE" ] && [ -f "$BACKUP_FILE" ]; then
        print_info "Restoring backup..."
        cp "$BACKUP_FILE" "$SCRIPT_FILE"
        print_success "Backup restored"
    fi
    
    exit 1
fi
echo ""

echo "▶ STEP 3/5: Update Configuration"

# Check if MONITORING_MODE already exists
if grep -q "MONITORING_MODE" "$ENV_FILE" 2>/dev/null; then
    print_success "Config already has MONITORING_MODE"
    CURRENT_MODE=$(grep "^MONITORING_MODE=" "$ENV_FILE" | cut -d'=' -f2)
    print_info "Current mode: $CURRENT_MODE"
else
    print_info "Adding MONITORING_MODE to config..."
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "MODE SELECTION"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Pilih monitoring mode:"
    echo ""
    echo "1) 🟢 EFFICIENT (Recommended)"
    echo "   • Every 3 minutes"
    echo "   • Handle: 30GB/30+ minutes"
    echo ""
    echo "2) 🔴 AGGRESSIVE (Extreme)"
    echo "   • Every 1 minute"
    echo "   • Handle: 30GB/5-10 minutes"
    echo ""
    printf "Pilihan [1]: "; read mode_choice
    mode_choice=${mode_choice:-1}
    
    if [ "$mode_choice" = "2" ]; then
        MONITORING_MODE="AGGRESSIVE"
        print_warning "AGGRESSIVE mode selected"
    else
        MONITORING_MODE="EFFICIENT"
        print_success "EFFICIENT mode selected"
    fi
    
    # Add monitoring mode configuration
    if grep -q "^THRESHOLD_KUOTA_GB=" "$ENV_FILE"; then
        sed -i "/^THRESHOLD_KUOTA_GB=/a\\
\\
# ============================================================================\\
# MONITORING MODE CONFIGURATION\\
# ============================================================================\\
# Mode: EFFICIENT (default) atau AGGRESSIVE (extreme)\\
MONITORING_MODE=$MONITORING_MODE\\
\\
# EFFICIENT Mode Settings (auto-applied when mode=EFFICIENT)\\
JUMLAH_SMS_CEK=3\\
SMS_MAX_AGE_MINUTES=15\\
\\
# AGGRESSIVE Mode Settings (auto-applied when mode=AGGRESSIVE)\\
JUMLAH_SMS_CEK_AGGRESSIVE=5\\
SMS_MAX_AGE_AGGRESSIVE=5\\
\\
# ============================================================================" "$ENV_FILE"
        
        print_success "Added MONITORING_MODE=$MONITORING_MODE"
    fi
fi

# Remove old parameters if exist (cleanup)
if grep -q "^JUMLAH_SMS_CEK=" "$ENV_FILE" 2>/dev/null; then
    if ! grep -q "MONITORING_MODE" "$ENV_FILE"; then
        # Old config, need migration
        print_info "Migrating old config..."
    fi
fi

echo ""

echo "▶ STEP 4/5: Update Cron (Optional)"
read -p "Update cron interval? (y/n) [n]: " update_cron
update_cron=${update_cron:-n}

if [ "$update_cron" = "y" ] || [ "$update_cron" = "Y" ]; then
    # Get current mode
    if [ -z "$MONITORING_MODE" ]; then
        MONITORING_MODE=$(grep "^MONITORING_MODE=" "$ENV_FILE" 2>/dev/null | cut -d'=' -f2 || echo "EFFICIENT")
    fi
    
    if [ "$MONITORING_MODE" = "AGGRESSIVE" ]; then
        CRON_INTERVAL="*/1 * * * *"
        print_info "Setting AGGRESSIVE cron: Every 1 minute"
    else
        CRON_INTERVAL="*/3 * * * *"
        print_info "Setting EFFICIENT cron: Every 3 minutes"
    fi
    
    crontab -l 2>/dev/null | grep -v "auto_edu.py" | crontab - 2>/dev/null || true
    (crontab -l 2>/dev/null; echo "$CRON_INTERVAL AUTO_EDU_ENV=$ENV_FILE python3 $SCRIPT_FILE") | crontab -
    /etc/init.d/cron restart > /dev/null 2>&1 || true
    print_success "Cron updated: $CRON_INTERVAL"
else
    print_info "Cron not changed (manual update needed if mode changed)"
fi

echo ""

echo "▶ STEP 5/5: Test"
read -p "Run test? (y/n) [y]: " test
test=${test:-y}
if [ "$test" = "y" ] || [ "$test" = "Y" ]; then
    print_info "Testing dual mode script..."
    echo "══════════════════════"
    AUTO_EDU_ENV="$ENV_FILE" python3 "$SCRIPT_FILE" && print_success "Test OK!" || print_warning "Check errors"
    echo "══════════════════════"
else
    print_info "Skipped test"
fi
echo ""

echo "✓ UPDATE COMPLETE!"
echo ""
echo "What's New:"
echo "  ✅ Dual mode system (EFFICIENT / AGGRESSIVE)"
echo "  ✅ Improved logic for extreme usage"
echo "  ✅ Priority kuota check in AGGRESSIVE mode"
echo "  ✅ Adaptive parameters based on mode"
echo ""

# Show current config
CURRENT_MODE=$(grep "^MONITORING_MODE=" "$ENV_FILE" 2>/dev/null | cut -d'=' -f2 || echo "EFFICIENT")
if [ "$CURRENT_MODE" = "AGGRESSIVE" ]; then
    echo "🔴 Current Mode: AGGRESSIVE"
    echo "   • Cron: Every 1 minute (recommended)"
    echo "   • SMS: 5 messages scan"
    echo "   • Max Age: 5 minutes"
    echo "   • Best for: 30GB/5-10 minutes"
else
    echo "🟢 Current Mode: EFFICIENT"
    echo "   • Cron: Every 3 minutes (recommended)"
    echo "   • SMS: 3 messages scan"
    echo "   • Max Age: 15 minutes"
    echo "   • Best for: 30GB/30+ minutes"
fi
echo ""

if [ -n "$BACKUP_FILE" ]; then
    echo "📂 Backup: $BACKUP_DIR"
    echo "   $(basename $BACKUP_FILE)"
    [ -n "$BACKUP_ENV" ] && echo "   $(basename $BACKUP_ENV)"
    echo ""
fi

echo "📝 Log: tail -f /tmp/auto_edu.log"
echo ""
print_success "Auto Edu updated! 🚀"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Rollback (jika ada masalah):"
if [ -n "$BACKUP_FILE" ]; then
    echo "  cp $BACKUP_FILE $SCRIPT_FILE"
    [ -n "$BACKUP_ENV" ] && echo "  cp $BACKUP_ENV $ENV_FILE"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "Change Mode:"
echo "  vi $ENV_FILE"
echo "  # Change: MONITORING_MODE=EFFICIENT or AGGRESSIVE"
echo "  # Then update cron accordingly"
echo ""

echo "Verification:"
echo "  grep MONITORING_MODE $ENV_FILE"
echo "  crontab -l | grep auto_edu"
echo "  tail -f /tmp/auto_edu.log"
echo ""
echo "Edited Version by: Matsumiko"