## Summary
By default, the weather widget displays the weather of the closest city based on your IP address.  
This PR modifies `Weather.qml` (located in `/usr/share/sleex/services`) to allow users to specify a custom location.

## Changes
- **Updated `Weather.qml`:**
  - Reads the first line of `/usr/share/sleex/services/Weather.txt` for a custom location.
  - If a valid location is found, the widget will display weather for that location.
  - If the file doesn’t exist or the location is invalid, it falls back to the default (closest city by IP).

- **Added `Install.sh`:**
  - Backup the original `Weather.qml`
  - Download and apply the modified `Weather.qml`
  - Create `/usr/share/sleex/services/Weather.txt`

- **Added `Uninstall.sh`:**
  - Delete  `Weather.txt` 
  - Delete the modified `Weather.qml` 
  - Restore the original `Weather.qml`

## Files:

[Install.sh](https://github.com/user-attachments/files/22156712/Install.sh)
[Uninstall.sh](https://github.com/user-attachments/files/22156713/Uninstall.sh)
[Weather.qml](https://github.com/Abscissa24/Utilities/blob/main/Assets/Weather.qml)

## Usage
Set a custom location by writing it to `Weather.txt`:

```bash
sudo sh -c 'echo "YOUR LOCATION" > /usr/share/sleex/services/Weather.txt'

# Then reload Hyprland & Quickshell (Use button on the dashboard)

# NOTE:
# For areas with one word (London - etc):
# sudo sh -c 'echo "London" > /usr/share/sleex/services/Weather.txt'

# For areas with more than one word (New York, Los Angeles, Hong Kong - etc)
# Separate with hyphens!

# Examples:
# sudo sh -c 'echo "New-York" > /usr/share/sleex/services/Weather.txt'
# sudo sh -c 'echo "Los-Angeles" > /usr/share/sleex/services/Weather.txt'
# sudo sh -c 'echo "Hong-Kong" > /usr/share/sleex/services/Weather.txt'
