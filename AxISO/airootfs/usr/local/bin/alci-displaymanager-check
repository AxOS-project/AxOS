#!/bin/bash
#set -e

package=sddm
if pacman -Qs $package > /dev/null ; then
    ln -sf /usr/lib/systemd/system/sddm.service /etc/systemd/system/display-manager.service
fi
package=gdm
if pacman -Qs $package > /dev/null ; then
    ln -sf /usr/lib/systemd/system/gdm.service /etc/systemd/system/display-manager.service
fi
package=lxdm
if pacman -Qs $package > /dev/null ; then
    ln -sf /usr/lib/systemd/system/lxdm.service /etc/systemd/system/display-manager.service
fi
package=lightdm
if pacman -Qs $package > /dev/null ; then
  ln -sf /usr/lib/systemd/system/lightdm.service /etc/systemd/system/display-manager.service
fi