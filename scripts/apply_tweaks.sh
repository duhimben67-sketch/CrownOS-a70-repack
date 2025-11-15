#!/bin/bash

WORKDIR="$1"

echo "=== CrownOS: Applying tweaks ==="

### -----------------------------
### 1. Remove Bloat Apps
### -----------------------------
echo "Removing unwanted apps..."

rm -rf "$WORKDIR/system/app/Browser"
rm -rf "$WORKDIR/system/app/Email"
rm -rf "$WORKDIR/system/app/Etc"
rm -rf "$WORKDIR/system/priv-app/Analytics"
rm -rf "$WORKDIR/system/priv-app/OTAUpdater"

echo "Bloat removal done."

### -----------------------------
### 2. Install Custom Bootanimation
### -----------------------------
echo "Installing bootanimation..."

mkdir -p "$WORKDIR/system/media"
cp modifications/media/bootanimation.zip "$WORKDIR/system/media/bootanimation.zip"

echo "Bootanimation added."

### -----------------------------
### 3. Install Wallpapers
### -----------------------------
echo "Installing CrownOS wallpapers..."

mkdir -p "$WORKDIR/system/product/media/wallpapers"
cp modifications/media/wallpapers/*.png "$WORKDIR/system/product/media/wallpapers/"

echo "Wallpapers added."

### -----------------------------
### 4. Performance Tweaks
### -----------------------------
echo "Applying performance tweaks..."

# Reduce animation scale
setprop persist.sys.animations 0.5

# LMK aggressive profile
echo "1536,2048,4096,5120,6144,7168" > "$WORKDIR/system/etc/minfree"

# Scheduler tweaks (example)
echo "bfq" > "$WORKDIR/system/etc/scheduler"

### -----------------------------
### 5. Remove LineageOS Branding
### -----------------------------
echo "Removing LineageOS branding..."

rm -rf "$WORKDIR/system/product/media/bootanimation.zip"
rm -rf "$WORKDIR/system/product/media/lineage_wallpaper.jpg"
rm -rf "$WORKDIR/system/product/media/lineage_wallpaper.png"
rm -rf "$WORKDIR/system/product/etc/init/init.lineage.rc"

echo "Branding removed."

### -----------------------------
### DONE
### -----------------------------
echo "=== CrownOS tweaks complete! ==="
