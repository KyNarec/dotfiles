import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "root:/modules/common"
import Qt.labs.settings 1.1

Item {
    id: weatherWidget
    width: weatherRow.width
    height: parent.height

    property string weatherLocation: "Halifax, Nova Scotia, Canada"
    property var weatherData: ({
        currentTemp: "",
        feelsLike: "",
        currentEmoji: "❓"
    })
    property int cacheDurationMs: 15 * 60 * 1000 // 15 minutes
    Settings {
        id: weatherCache
        property string lastWeatherJson: ""
        property double lastWeatherTimestamp: 0
        property string lastLocation: ""
    }

    Timer {
        interval: 600000  // Update every 10 minutes
        running: true
        repeat: true
        onTriggered: loadWeather()
    }

    Component.onCompleted: {
        Qt.application.organizationName = "Quickshell";
        Qt.application.organizationDomain = "quickshell.org";
        Qt.application.name = "Quickshell";
        loadWeather();
    }

    RowLayout {
        id: weatherRow
        height: parent.height
        spacing: 8
        anchors {
            centerIn: parent
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: -11
        }

        Text {
            id: weatherIcon
            text: weatherData.currentEmoji || "❓"
            font.pixelSize: Appearance.font.pixelSize.larger
            color: Appearance.colors.colOnLayer0
            Layout.alignment: Qt.AlignVCenter
        }

        RowLayout {
            spacing: 4
            Layout.alignment: Qt.AlignVCenter

            Text {
                id: temperature
                text: weatherData.currentTemp || "?"
                font.pixelSize: Appearance.font.pixelSize.normal
                color: Appearance.colors.colOnLayer0
                Layout.alignment: Qt.AlignVCenter
            }

            Text {
                id: feelsLike
                text: weatherData.feelsLike ? "(" + weatherData.feelsLike + ")" : ""
                font.pixelSize: Appearance.font.pixelSize.normal
                color: Appearance.colors.colOnLayer0
                opacity: 0.8
                Layout.alignment: Qt.AlignVCenter
                visible: weatherData.feelsLike !== ""
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        
        ToolTip.visible: containsMouse
        ToolTip.text: weatherData.currentCondition || "Weather"
        ToolTip.delay: 500
    }

    function getWeatherEmoji(condition) {
        if (!condition) return "❓"
        condition = condition.toLowerCase()

        if (condition.includes("clear")) return "☀️"
        if (condition.includes("mainly clear")) return "🌤️"
        if (condition.includes("partly cloudy")) return "⛅"
        if (condition.includes("cloud") || condition.includes("overcast")) return "☁️"
        if (condition.includes("fog") || condition.includes("mist")) return "🌫️"
        if (condition.includes("drizzle")) return "🌦️"
        if (condition.includes("rain") || condition.includes("showers")) return "🌧️"
        if (condition.includes("freezing rain")) return "🌧️❄️"
        if (condition.includes("snow") || condition.includes("snow grains") || condition.includes("snow showers")) return "❄️"
        if (condition.includes("thunderstorm")) return "⛈️"
        if (condition.includes("wind")) return "🌬️"
        return "❓"
    }

    function mapWeatherCode(code) {
        switch(code) {
            case 0: return "Clear sky";
            case 1: return "Mainly clear";
            case 2: return "Partly cloudy";
            case 3: return "Overcast";
            case 45: return "Fog";
            case 48: return "Depositing rime fog";
            case 51: return "Light drizzle";
            case 53: return "Moderate drizzle";
            case 55: return "Dense drizzle";
            case 56: return "Light freezing drizzle";
            case 57: return "Dense freezing drizzle";
            case 61: return "Slight rain";
            case 63: return "Moderate rain";
            case 65: return "Heavy rain";
            case 66: return "Light freezing rain";
            case 67: return "Heavy freezing rain";
            case 71: return "Slight snow fall";
            case 73: return "Moderate snow fall";
            case 75: return "Heavy snow fall";
            case 77: return "Snow grains";
            case 80: return "Slight rain showers";
            case 81: return "Moderate rain showers";
            case 82: return "Violent rain showers";
            case 85: return "Slight snow showers";
            case 86: return "Heavy snow showers";
            case 95: return "Thunderstorm";
            case 96: return "Thunderstorm with slight hail";
            case 99: return "Thunderstorm with heavy hail";
            default: return "Unknown";
        }
    }

    function loadWeather() {
        var now = Date.now();
        var locationKey = weatherLocation.trim().toLowerCase();
        if (weatherCache.lastWeatherJson && weatherCache.lastLocation === locationKey && (now - weatherCache.lastWeatherTimestamp) < cacheDurationMs) {
            // Use cached data
            parseWeather(JSON.parse(weatherCache.lastWeatherJson));
            return;
        }
        var xhr = new XMLHttpRequest();
        var url = "https://wttr.in/" + encodeURIComponent(weatherLocation) + "?format=j1";
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    try {
                        var data = JSON.parse(xhr.responseText);
                        weatherCache.lastWeatherJson = xhr.responseText;
                        weatherCache.lastWeatherTimestamp = now;
                        weatherCache.lastLocation = locationKey;
                        parseWeather(data);
                    } catch (e) {
                        fallbackWeatherData("Parse error");
                    }
                } else {
                    fallbackWeatherData("Request error");
                }
            }
        };
        xhr.open("GET", url);
        xhr.setRequestHeader("User-Agent", "Mozilla/5.0 (compatible; quickshell-weather/1.0)");
        xhr.send();
    }

    function parseWeather(data) {
        // Parse wttr.in JSON for current conditions
        if (data.current_condition && data.current_condition[0]) {
            var current = data.current_condition[0];
            var tempC = current.temp_C;
            var feelsLikeC = current.FeelsLikeC;
            var condition = current.weatherDesc[0]?.value || "";
            weatherData = {
                currentTemp: tempC + "°C",
                feelsLike: feelsLikeC + "°C",
                currentEmoji: getWeatherEmoji(condition),
                currentCondition: condition
            };
        } else {
            fallbackWeatherData("No data");
        }
    }

    function fallbackWeatherData(message) {
        weatherData = {
            currentTemp: "?",
            feelsLike: "",
            currentEmoji: "❓",
            currentCondition: message
        };
    }
} 