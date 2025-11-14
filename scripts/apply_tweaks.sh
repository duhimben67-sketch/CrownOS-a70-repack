#!/usr/bin/env bash
set -e
WORK="$1"
if [ -z "$WORK" ]; then
  echo "Usage: $0 <workdir>"
  exit 1
fi

echo "[CrownOS] Applying heavy customizations to $WORK"

# Backup build.prop
if [ -f "$WORK/system/build.prop" ]; then
  cp "$WORK/system/build.prop" "$WORK/system/build.prop.bak" || true
else
  mkdir -p "$WORK/system"
  touch "$WORK/system/build.prop"
fi

# Overwrite/add performance & smoothness props (aggressive but safe)
cat >> "$WORK/system/build.prop" <<'EOF'

# === CrownOS heavy performance tweaks ===
# animations
persist.sys.window_animation_scale=0.5
persist.sys.transition_animation_scale=0.5
persist.sys.animator_duration_scale=0.45

# zram
persist.crownos.zram.enabled=1
persist.crownos.zram.size_mb=1536

# vm tuning
vm.swappiness=60
vm.vfs_cache_pressure=30
vm.dirty_ratio=10
vm.dirty_background_ratio=5

# networking
net.ipv4.tcp_low_latency=1

# logs
ro.debuggable=0
persist.logd.size=256K

# CrownOS branding
ro.crownos.name=CrownOS
ro.crownos.version=1.0
EOF

echo "[CrownOS] build.prop updated"

# Add init.d script for zram (safe)
mkdir -p "$WORK/system/etc/init.d"
cat > "$WORK/system/etc/init.d/99crown_zram" <<'EOF'
#!/system/bin/sh
ZRAM_ENABLED=$(getprop persist.crownos.zram.enabled)
ZRAM_MB=$(getprop persist.crownos.zram.size_mb)
if [ "$ZRAM_ENABLED" = "1" ] && [ -n "$ZRAM_MB" ]; then
  modprobe zram || true
  echo $ZRAM_MB > /sys/block/zram0/disksize 2>/dev/null || true
  mkswap /dev/block/zram0 2>/dev/null || true
  swapon /dev/block/zram0 -p 32758 2>/dev/null || true
fi
EOF
chmod 755 "$WORK/system/etc/init.d/99crown_zram"
echo "[CrownOS] zram init.d added"

# Remove stock launchers & bloat (common examples)
rm -rf "$WORK/system/priv-app/Trebuchet" || true
rm -rf "$WORK/system/app/Trebuchet" || true
# Remove known Samsung bloat packages if present (safe tries)
rm -rf "$WORK/system/priv-app/DMClient*" || true
rm -rf "$WORK/system/app/SampleProvider*" || true
rm -rf "$WORK/system/priv-app/SecSettings*" || true

echo "[CrownOS] removed some stock apps (if present)"

# Add a minimal 'Crown Extras' placeholder app if provided in modifications (already copied earlier)
# Ensure APK perms
if [ -d "$WORK/system/app" ]; then
  find "$WORK/system/app" -type d -exec chmod 755 {} \;
  find "$WORK/system/app" -type f -name "*.apk" -exec chmod 644 {} \;
fi

# Set sane permissions
find "$WORK/system" -type d -exec chmod 755 {} \;
find "$WORK/system" -type f -exec chmod 644 {} \;

echo "[CrownOS] Permissions set. Tweaks applied."
