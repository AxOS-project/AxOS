#!/usr/bin/env bash
#
# SPDX-License-Identifier: GPL-3.0-or-later

# DO NOT EXECUTE UNLESS YOU KNOW WHAT YOU ARE DOING !!!

set -e -u

sed -i -E '/^# *(en_US|en_GB|de_DE|fr_FR|es_ES|it_IT|pt_PT|pt_BR|zh_CN|zh_TW|ja_JP|ko_KR|ru_RU|nl_NL|sv_SE|da_DK|fi_FI|nb_NO|pl_PL)/ s/^# *//' /etc/locale.gen # Main languages
locale-gen

sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist

# nsswitch.conf settings
# * Avahi : add 'mdns_minimal'
# * Winbind : add 'wins'
sed -i '/^hosts:/ {
        s/\(resolve\)/mdns_minimal \[NOTFOUND=return\] \1/
        s/\(dns\)$/\1 wins/ }' /etc/nsswitch.conf

# Enable service when available
{ [[ -e /usr/lib/systemd/system/bluetooth.service            ]] && systemctl enable bluetooth.service;
  [[ -e /usr/lib/systemd/system/NetworkManager.service       ]] && systemctl enable NetworkManager.service;
  [[ -e /usr/lib/systemd/system/nmb.service                  ]] && systemctl enable nmb.service;
  [[ -e /usr/lib/systemd/system/cups.service                 ]] && systemctl enable cups.service;
  [[ -e /usr/lib/systemd/system/smb.service                  ]] && systemctl enable smb.service;
  [[ -e /usr/lib/systemd/system/winbind.service              ]] && systemctl enable winbind.service;
  [[ -e /usr/lib/systemd/system/ntpd.service 	             ]] && systemctl enable ntpd.service;
} > /dev/null 2>&1

# Enable sddm display-manager
# ln -s /usr/lib/systemd/system/sddm.service /etc/systemd/system/display-manager.service
systemctl enable sddm.service

# Add live user
# * groups member
# * user without password
# * sudo no password settings
useradd -m -G 'wheel' -s /bin/bash live
sed -i 's/^\(live:\)!:/\1:/' /etc/shadow
sed -i 's/^#\s\(%wheel\s.*NOPASSWD\)/\1/' /etc/sudoers

# Pacman keys
pacman-key --init
pacman-key --populate archlinux

# Set root password
echo "root:root" | chpasswd # Change root password to 'root'
