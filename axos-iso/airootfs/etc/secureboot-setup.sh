#!/usr/bin/env bash
set -euo pipefail

# == CONFIG ==
KEYDIR="/etc/secureboot/keys"
SHIM_DIR="/boot/EFI/BOOT"
KERNEL="/boot/vmlinuz-linux"
SIGNED_KERNEL="/boot/vmlinuz-linux.signed"
GRUB_EFI="/boot/EFI/BOOT/grubx64.efi"
SHIM_EFI="/boot/EFI/BOOT/BOOTX64.EFI"

# == DEPENDENCIES ==
# Ensure shim-signed and grub are installed
command -v sbsign >/dev/null || { echo "sbsign not found!"; exit 1; }

# == CREATE KEYS ==
echo "[*] Generating Secure Boot keys..."
mkdir -p "$KEYDIR"
cd "$KEYDIR"

openssl req -new -x509 -newkey rsa:2048 -keyout MOK.key -out MOK.crt -days 3650 -nodes -subj "/CN=AxOS Secure Boot/"
openssl x509 -in MOK.crt -outform DER -out MOK.cer
cert-to-efi-sig-list MOK.crt MOK.esl
sign-efi-sig-list -k MOK.key -c MOK.crt MOK MOK.esl MOK.auth

echo "[+] Keys generated in $KEYDIR"

# == SIGN GRUB AND KERNEL ==
echo "[*] Signing GRUB EFI binary..."
sbsign --key MOK.key --cert MOK.crt "$GRUB_EFI" --output "$GRUB_EFI"

echo "[*] Signing kernel..."
sbsign --key MOK.key --cert MOK.crt "$KERNEL" --output "$SIGNED_KERNEL"

# Update your GRUB config to boot the signed kernel
echo "[*] Patching GRUB config..."
sed -i "s|/boot/vmlinuz-linux|$SIGNED_KERNEL|" /boot/grub/grub.cfg || echo "Warning: grub.cfg not patched. Handle manually."

# == COPY SHIM ==
echo "[*] Copying shim..."
cp /usr/share/shim-signed/shimx64.efi "$SHIM_EFI"

echo "[!] Boot will now go: shimx64.efi -> signed grubx64.efi -> signed kernel"

# == USB EXPORT ==
mkdir -p /etc/secureboot/usb-keys
cp MOK.cer /etc/secureboot/usb-keys/

echo "[✔] Secure Boot setup done with shim support. Enroll MOK.cer from USB using MokManager or KeyTool.efi."
