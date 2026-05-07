#!/usr/bin/env bash
# NixOS Installation Script für kant (172.20.0.252)
# sda: 512M EFI | ~116G LVM (nixos ext4 + 16G swap) | ~116G ZFS (home)
#
# Vorbereitung (von der lokalen Maschine):
#   scp -r ~/sync/gh/nixos nixos@172.20.0.252:/tmp/nixos
#   ssh nixos@172.20.0.252 sudo bash /tmp/nixos/hosts/kant/install.sh
#
set -euo pipefail
export PATH=/run/current-system/sw/bin:$PATH

echo "=== e2fsprogs installieren (für mkfs.ext4) ==="
nix-env -iA nixos.e2fsprogs

DISK=/dev/sda
VG=vg-kant
POOL=home

echo "=== Aufräumen: alte Strukturen auf $DISK ==="
swapoff -a 2>/dev/null || true
for pool in $(zpool list -H -o name 2>/dev/null); do
  zpool status "$pool" 2>/dev/null | grep -q "$DISK" && zpool destroy -f "$pool" 2>/dev/null || true
done
for vg in $(vgs --noheadings -o vg_name 2>/dev/null | tr -d ' '); do
  pvs --noheadings -o pv_name,vg_name 2>/dev/null | grep -q "$DISK.*$vg" && {
    vgchange -an "$vg" 2>/dev/null || true
    vgremove -f "$vg" 2>/dev/null || true
  }
done
for pv in $(pvs --noheadings -o pv_name 2>/dev/null | tr -d ' '); do
  echo "$pv" | grep -q "$DISK" && pvremove -f "$pv" 2>/dev/null || true
done
umount -l "${DISK}"* 2>/dev/null || true
wipefs -af "$DISK" 2>/dev/null || true

echo "=== Partitionierung ==="
parted "$DISK" -- mklabel gpt
parted "$DISK" -- mkpart EFI fat32 1MiB 513MiB
parted "$DISK" -- set 1 esp on
parted "$DISK" -- mkpart primary 513MiB 50%
parted "$DISK" -- name 2 nixos-lvm
parted "$DISK" -- mkpart primary 50% 100%
parted "$DISK" -- name 3 home-zfs
partprobe "$DISK"
sleep 2

echo "=== EFI formatieren ==="
mkfs.fat -F 32 -n EFI "${DISK}1"

echo "=== LVM einrichten ==="
pvcreate "${DISK}2"
vgcreate "$VG" "${DISK}2"
lvcreate -L 16G -n swap "$VG"
lvcreate -l 100%FREE -n nixos "$VG"
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

echo "=== ZFS Pool exportieren (wichtig vor reboot!) ==="
cd /mnt/etc/nixos && git add hosts/kant/
nixos-install --flake /mnt/etc/nixos#kant --no-root-passwd

echo "=== ZFS Pool sauber exportieren ==="
umount /mnt/home
zpool export home

echo ""
echo "=== Fertig! ==="
echo "Initialpasswort: ramge  (später ändern mit: passwd)"
echo "Dann: reboot"
