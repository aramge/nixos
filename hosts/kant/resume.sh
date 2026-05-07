#!/usr/bin/env bash
# Resume ab LVM-Formatierung (Partitionen + LVM-Volumes existieren bereits)
set -euo pipefail
export PATH=/run/current-system/sw/bin:$PATH

echo "=== e2fsprogs installieren ==="
nix-env -iA nixos.e2fsprogs

DISK=/dev/sda
VG=vg-kant
POOL=home

echo "=== ext4 + swap formatieren ==="
mkfs.ext4 -L nixos "/dev/$VG/nixos"
mkswap -L swap "/dev/$VG/swap"

echo "=== ZFS Pool einrichten ==="
zpool create -f \
  -o ashift=12 \
  -O compression=lz4 \
  -O atime=off \
  -O xattr=sa \
  -O mountpoint=none \
  "$POOL" "${DISK}3"
zfs create -o mountpoint=legacy "$POOL/ramge"

echo "=== Mounten unter /mnt ==="
mount "/dev/$VG/nixos" /mnt
mkdir -p /mnt/boot /mnt/home
mount "${DISK}1" /mnt/boot
mount -t zfs "$POOL/ramge" /mnt/home
swapon "/dev/$VG/swap"

echo "=== Repo nach /mnt/etc/nixos kopieren ==="
mkdir -p /mnt/etc
cp -r /tmp/nixos /mnt/etc/nixos

echo "=== NixOS installieren ==="
nixos-install --flake /mnt/etc/nixos#kant --no-root-passwd

echo ""
echo "=== Fertig! ==="
echo "Initialpasswort: ramge  (später ändern mit: passwd)"
echo "Dann: reboot"
