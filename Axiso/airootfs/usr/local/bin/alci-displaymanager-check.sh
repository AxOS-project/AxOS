#!/bin/sh
set -eu

for dm in /usr/bin/*-session; do
    case $dm in
        /usr/bin/*openbox-session|/usr/bin/*lxqt-session)
            # Skip these because they're usually run by other scripts.
            continue
            ;;
    esac
    if [ -x "$dm" ]; then
        echo "FOUND_DISPLAY_MANAGER" >&2
        exit 0
    fi
done

echo "NO_DISPLAY_MANAGER" >&2
exit 1

