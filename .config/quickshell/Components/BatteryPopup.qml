import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import Quickshell.Wayland
import "../Services"

PanelWindow {
    id: root
    color: "transparent"
    property bool popupVisible: false
    visible: popupVisible

    implicitWidth: background.width
    implicitHeight: background.height

    readonly property color colBg: "#1a1b26"
    readonly property color colFg: "#a9b1d6"
    readonly property color colMuted: "#444b6a"
    readonly property color colCyan: "#0db9d7"
    readonly property color colBlue: "#7aa2f7"
    readonly property color colDarkBlue: "#2980b9"
    readonly property color colYellow: "#e0af68"
    readonly property color colWhite: "#ffffff"
    readonly property color colPurple: "#ad8ee6"
    readonly property color colRed: "#f7768e"
    readonly property color colGreen: "#9ece6a"

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    WlrLayershell.layer: WlrLayershell.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    MouseArea {
        anchors.fill: parent
        onClicked: root.popupVisible = false
    }

    Rectangle {
        id: background
        x: parent.width - width - 5
        y: 2
        width: content.implicitWidth + 30
        height: content.implicitHeight + powerRow.implicitHeight
        color: root.colBg
        radius: 12
        border.color: root.colFg
        border.width: 1
        layer.enabled: true
        MouseArea {
            anchors.fill: parent
            onClicked: mouse => mouse.accepted = true
        }
        ColumnLayout {
            id: content
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 10

            spacing: 8

            RowLayout {
                Text {
                    text: "Remaining:"

                    color: root.colFg
                }

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    id: timeRemaining
                    property var device: BatteryService.device
                    text: BatteryService.isCharging ? formatTime(device.timeToFull) : formatTime(device.timeToEmpty)
                    color: root.colFg
                }
            }
            RowLayout {

                Text {
                    text: "Battery Health:"

                    color: root.colWhite
                }

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    id: health
                    text: BatteryService.batteryHealth
                    color: root.colWhite
                }
            }

            RowLayout {

                Text {
                    text: "Battery Capacity:"

                    color: root.colWhite
                }

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    id: capacity
                    text: BatteryService.batteryCapacity.toFixed(1) + " Wh"
                    color: root.colWhite
                }
            }

            RowLayout {
                id: powerRow
                visible: PowerProfileService.currentProfile != -1
                Layout.fillWidth: true
                spacing: 6

                readonly property var powerProfiles: {
                    let list = ["Power Saver", "Balanced"];
                    if (PowerProfiles.hasPerformanceProfile)
                        list.push("Performance");
                    return list;
                }

                Repeater {
                    model: parent.powerProfiles
                    delegate: Rectangle {
                        id: powerModeRectangle
                        readonly property int itemIndex: index
                        Layout.fillWidth: true
                        width: text.implicitWidth + 6
                        height: text.implicitHeight + 6
                        color: PowerProfileService.currentProfile === index ? root.colPurple : root.colBg
                        border.color: root.colPurple
                        border.width: PowerProfileService.currentProfile !== index ? 2 : 0
                        radius: 6
                        Text {
                            id: text
                            text: modelData
                            color: root.colWhite
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                console.log("Clicked Power Profile: " + powerModeRectangle.itemIndex);
                                PowerProfiles.profile = powerModeRectangle.itemIndex;
                            }
                        }
                    }
                }
            }
        }
    }
    // // Helper function for time formatting
    function formatTime(seconds) {
        if (seconds <= 0)
            return "Calculating...";
        let mins = Math.floor(seconds / 60);
        let hrs = Math.floor(mins / 60);
        mins = mins % 60;
        return hrs > 0 ? hrs + "h " + mins + "m" : mins + "m";
    }
}
