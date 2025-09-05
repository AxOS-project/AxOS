import qs.modules.common
import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton
pragma ComponentBehavior: Bound

/**
 * Weather service.
 */
Singleton {
    id: root
    property string loc
    property string temperature
    property string condition
    property string raw
    property string weatherCode
    property bool useCustomLocation: false

    Timer {
        id: weatherTimer
        interval: 3600000 // 1 hour
        running: true
        repeat: true
        onTriggered: updateWeather()
    }

    // Check if custom location file exists
    Process {
        id: checkLocationFile
        command: ["bash", "-c", "if [ -f /usr/share/sleex/services/Weather.txt ]; then cat /usr/share/sleex/services/Weather.txt; else echo 'FILE_NOT_FOUND'; fi"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.trim() !== "FILE_NOT_FOUND") {
                    // File exists, use the first line as location
                    var lines = text.split('\n');
                    if (lines.length > 0) {
                        root.loc = lines[0].trim();
                        root.useCustomLocation = true;
                        getWeather.running = true;
                    } else {
                        // File is empty, fall back to IP
                        getIp.running = true;
                    }
                } else {
                    // File doesn't exist, use IP-based location
                    getIp.running = true;
                }
            }
        }
    }

    Process {
        id: getIp
        command: ["curl", "ipinfo.io"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.loc = JSON.parse(text)["loc"]
                getWeather.running = true
            }
        }
    }

    Process {
        id: getWeather
        command: ["curl", `https://wttr.in/${root.loc}?format=j1`]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const json = JSON.parse(text).current_condition[0];
                    root.raw = text;
                    root.condition = json.weatherDesc[0].value;
                    root.temperature = json.temp_C + "°C";
                    root.weatherCode = json.weatherCode;
                } catch (e) {
                    console.error("Error parsing weather data:", e);
                    // If using custom location failed, try IP-based as fallback
                    if (root.useCustomLocation) {
                        root.useCustomLocation = false;
                        getIp.running = true;
                    }
                }
            }
        }
    }

    function updateWeather() {
        checkLocationFile.running = true;
    }

    Component.onCompleted: {
        // Initial weather update
        updateWeather();
    }
}
