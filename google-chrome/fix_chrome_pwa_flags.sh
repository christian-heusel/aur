#!/bin/bash
# fix_chrome_pwa_flags.sh
# Patches all Chrome PWA .desktop files to include GPU stability flags.
# Creates timestamped backups of every file before modifying.
#
# Root cause: Chrome PWA launchers call /opt/google/chrome/google-chrome directly,
# bypassing the /usr/bin/google-chrome-stable wrapper that reads chrome-flags.conf.
#
# Fix: Inject GPU stability flags directly into each Exec= line.
# Uses Vulkan backend (RADV) — requires vulkan-radeon to be installed.
# Install: sudo pacman -S vulkan-radeon

set -e

DESKTOP_DIR="$HOME/.local/share/applications"
BACKUP_DIR="$HOME/antigravity_gpu_debug/pwa_backups_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

GPU_FLAGS='--enable-features=Vulkan,UseSkiaRenderer --use-angle=vulkan --ozone-platform=wayland --enable-gpu-rasterization --ignore-gpu-blocklist'

PATCHED=0
SKIPPED=0

echo "=== Chrome PWA Desktop File Patcher ==="
echo "GPU flags: $GPU_FLAGS"
echo "Backup directory: $BACKUP_DIR"
echo ""

for desktop_file in "$DESKTOP_DIR"/chrome-*.desktop; do
    [ -f "$desktop_file" ] || continue
    filename=$(basename "$desktop_file")

    if ! grep -q "Exec=/opt/google/chrome/google-chrome" "$desktop_file"; then
        echo "[SKIP] $filename — does not call google-chrome directly"
        SKIPPED=$((SKIPPED + 1))
        continue
    fi

    cp "$desktop_file" "$BACKUP_DIR/$filename.bak"

    # Strip any previously injected flags (--use-gl=egl or --use-angle=vulkan etc.)
    # then inject the correct flags fresh
    sed -i \
        -e 's|--use-gl=egl ||g' \
        -e 's|--use-angle=vulkan ||g' \
        -e 's|--enable-features=Vulkan,UseSkiaRenderer ||g' \
        -e 's|--ozone-platform=wayland ||g' \
        -e 's|--enable-gpu-rasterization ||g' \
        -e 's|--ignore-gpu-blocklist ||g' \
        -e 's|--disable-gpu-sandbox ||g' \
        "$desktop_file"

    # Inject fresh flags
    sed -i "s|Exec=/opt/google/chrome/google-chrome |Exec=/opt/google/chrome/google-chrome $GPU_FLAGS |g" "$desktop_file"

    app_name=$(grep "^Name=" "$desktop_file" | head -1 | cut -d= -f2-)
    echo "[PATCHED] $filename  (App: $app_name)"
    PATCHED=$((PATCHED + 1))
done

echo ""
echo "=== Summary ==="
echo "Files patched : $PATCHED"
echo "Files skipped : $SKIPPED"
echo "Backups at    : $BACKUP_DIR"
echo ""
update-desktop-database "$DESKTOP_DIR" 2>/dev/null && echo "Desktop database updated." || true
echo "Done. Restart any open Chrome PWAs for changes to take effect."
