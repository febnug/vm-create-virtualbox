#!/bin/bash

# === Konfigurasi untuk FreeBSD ===
VM_NAME="freebsd-test"
VM_RAM=2048
VM_CPUS=2
VM_DISK_SIZE=20000      # dalam MB (20 GB)
VM_ISO="/home/user/Downloads/FreeBSD-14.3-RELEASE-amd64-dvd1.iso"  # Ganti path ini

# === Direktori penyimpanan disk ===
VM_DIR="$HOME/VirtualBox VMs/$VM_NAME"
VM_DISK="$VM_DIR/$VM_NAME.vdi"

# === 1. Buat VM ===
VBoxManage createvm --name "$VM_NAME" --register

# === 2. Atur RAM, CPU, dll ===
VBoxManage modifyvm "$VM_NAME" \
  --memory "$VM_RAM" \
  --cpus "$VM_CPUS" \
  --ostype FreeBSD_64 \
  --nic1 nat \
  --graphicscontroller vmsvga \
  --vrde off

# === 3. Buat hard disk ===
VBoxManage createmedium disk \
  --filename "$VM_DISK" \
  --size "$VM_DISK_SIZE" \
  --format VDI

# === 4. Buat storage controller ===
VBoxManage storagectl "$VM_NAME" \
  --name "SATA Controller" \
  --add sata \
  --controller IntelAhci

# === 5. Pasang hard disk ===
VBoxManage storageattach "$VM_NAME" \
  --storagectl "SATA Controller" \
  --port 0 \
  --device 0 \
  --type hdd \
  --medium "$VM_DISK"

# === 6. Pasang ISO sebagai DVD boot ===
VBoxManage storageattach "$VM_NAME" \
  --storagectl "SATA Controller" \
  --port 1 \
  --device 0 \
  --type dvddrive \
  --medium "$VM_ISO"

# === 7. Set boot priority ===
VBoxManage modifyvm "$VM_NAME" \
  --boot1 dvd --boot2 disk --boot3 none --boot4 none

# === 8. Jalankan VM ===
VBoxManage startvm "$VM_NAME" --type gui
