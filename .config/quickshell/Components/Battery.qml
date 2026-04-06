import QtQuick
import QtQuick.Layouts
import "../Services"

Rectangle {
    id: rec
    width: row.implicitWidth + 20
    height: parent.height
    color: "transparent"

    property bool batteryVisisble: false
    visible: batteryVisisble

    anchors.verticalCenter: parent.verticalCenter
    readonly property color colPurple: "#ad8ee6"
    readonly property color colRed: "#f7768e"
    readonly property color colGreen: "#9ece6a"

    readonly property string fontFamily: "JetBrainsMono Nerd Font Propo"
    readonly property int fontSize: 16

    FontLoader {
        id: fluentFont
        source: "../assets/fonts/FluentSystemIcons-Regular.ttf"
    }
    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 6

        Text {
            id: icon
            text: BatteryService.batteryIcon

            font.family: fluentFont.name
            font.pixelSize: 22
            color: BatteryService.isCharging ? rec.colGreen : rec.colPurple
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
        }
        Text {
            id: batteryPercentage
            text: BatteryService.batteryLevel + "%"
            font.pixelSize: rec.fontSize
            font.family: rec.fontFamily
            font.bold: true
            color: BatteryService.isCharging ? rec.colGreen : rec.colPurple
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
        }
    }

    Rectangle {
        width: icon.width + batteryPercentage.width + 20
        height: 3
        color: BatteryService.isCharging ? rec.colGreen : rec.colPurple
        Behavior on color {
            ColorAnimation {
                duration: 200
            }
        }
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            batteryPopup.popupVisible = !batteryPopup.popupVisible;
        }
    }

    BatteryPopup {
        id: batteryPopup
        popupVisible: false
    }
}
