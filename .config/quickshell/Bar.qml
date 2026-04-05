import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.SystemTray

PanelWindow {
    id: root
    property var modelData: null
    property var targetScreen: modelData
    screen: targetScreen
    // Theme
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

    readonly property string fontFamily: "JetBrainsMono Nerd Font Propo"
    readonly property int fontSize: 16

    // System data
    property int cpuUsage: 0
    property int memUsagePercent: 0
    property string memUsageTotal: "0.00"

    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 30
    color: root.colBg

    readonly property int mem_MODE_PERCENT: 0
    readonly property int mem_MODE_TOTAL: 1

    property int currentMemMode: mem_MODE_TOTAL

    property var trayItems: SystemTray.items
    RowLayout {
        anchors.fill: parent
        spacing: 15

        // Workspaces
        RowLayout {
            id: workspaceRow
            Layout.preferredHeight: parent.height

            Repeater {
                model: 9

                Rectangle {
                    width: 25
                    Layout.preferredHeight: parent.height
                    color: "transparent"

                    property var workspace: Hyprland.workspaces.values.find(ws => ws.id === index + 1) ?? null
                    property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                    property bool hasWindows: workspace !== null
                    property bool isUrgent: workspace ? workspace.urgent : false

                    opacity: workspaceMouse.containsMouse ? 1.0 : 0.9

                    Text {
                        text: index + 1
                        color: isUrgent ? root.colRed : parent.isActive ? root.colCyan : (parent.hasWindows ? root.colCyan : root.colWhite)
                        font.pixelSize: root.fontSize
                        font.family: root.fontFamily
                        font.bold: true
                        anchors.centerIn: parent
                    }

                    Rectangle {
                        width: 25
                        height: 3
                        color: parent.isActive ? root.colPurple : root.colBg
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                    }
                    MouseArea {
                        id: workspaceMouse
                        hoverEnabled: true
                        anchors.fill: parent
                        width: 20
                        onClicked: Hyprland.dispatch("workspace " + (index + 1))
                        cursorShape: Qt.PointingHandCursor
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 150
                        }
                    }
                }
            }
        }

        Rectangle {
            width: 2
            height: 16
            color: root.colMuted
        }

        Text {
            text: {
                var window = Hyprland.activeToplevel;
                var focusedWs = Hyprland.focusedWorkspace;

                if (window && focusedWs && window.workspace.id === focusedWs.id) {
                    return window.title.substring(0, 40);
                }
                return "";
            }
            color: root.colFg

            font {
                family: root.fontFamily
                pixelSize: root.fontSize
                bold: true
            }
            Layout.maximumWidth: 400
            elide: Text.ElideRight
        }

        Rectangle {
            width: 2
            height: 16
            color: root.colMuted
            visible: {
                var window = Hyprland.activeToplevel;
                var focusedWs = Hyprland.focusedWorkspace;
                if (window && focusedWs && window.workspace.id === focusedWs.id) {
                    return true;
                }
                return false;
            }
        }

        Item {
            Layout.fillWidth: true
        }

        Rectangle {
            width: 2
            height: 16
            color: root.colMuted
        }

        // Network
        Rectangle {
            id: networkRec

            Layout.preferredWidth: networkText.width + 30
            Layout.preferredHeight: parent.height
            color: "transparent"
            property string netStatus: "checking..."
            property string netColor: root.colYellow
            Process {
                id: netProc
                command: ["nmcli", "-t", "-f", "STATE", "g"]
                stdout: SplitParser {
                    onRead: data => {
                        if (!data) {
                            return;
                        }
                        var state = data.toString().trim();
                        if (state === "connected") {
                            networkRec.netStatus = "Online";
                            networkRec.netColor = root.colBlue;
                        } else if (state === "connecting") {
                            networkRec.netStatus = "Connecting...";
                            networkRec.netColor = root.colYellow;
                        } else {
                            networkRec.netStatus = "Offline";
                            networkRec.netColor = root.colRed;
                        }
                    }
                }
            }

            Timer {
                interval: 2000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: {
                    netProc.running = true;
                }
            }

            Text {
                id: networkText
                text: networkRec.netStatus
                color: networkRec.netColor
                font {
                    family: root.fontFamily
                    pixelSize: root.fontSize
                    bold: true
                }
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
            Rectangle {
                width: networkText.width + 20
                height: 3
                color: networkRec.netColor
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
            }
        }

        Rectangle {
            width: 2
            height: 16
            color: root.colMuted
        }

        // CPU
        Rectangle {
            Layout.preferredWidth: cpuText.width + 30
            Layout.preferredHeight: parent.height
            color: "transparent"

            Text {
                id: cpuText
                text: "CPU: " + root.cpuUsage + "%"
                color: root.colGreen
                font.pixelSize: root.fontSize
                font.family: root.fontFamily
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                // Layout.rightMargin: 8
            }

            Rectangle {
                width: cpuText.width + 20
                height: 3
                color: root.colGreen
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
            }
        }

        Rectangle {
            width: 2
            height: 16
            color: root.colMuted
        }

        // Memory
        Rectangle {

            Layout.preferredWidth: memText.width + 30
            Layout.preferredHeight: parent.height
            color: "transparent"

            // property string memText: "Mem: " + root.memUsagePercent + "%"

            Text {
                id: memText
                text: root.currentMemMode === root.mem_MODE_PERCENT ? "Mem: " + root.memUsagePercent + "%" : "Mem: " + root.memUsageTotal + " GB"
                color: root.colPurple
                font {
                    family: root.fontFamily
                    pixelSize: root.fontSize
                    bold: true
                }
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                // Layout.rightMargin: 8
            }

            Rectangle {
                width: memText.width + 20
                height: 3
                color: root.colPurple
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    // Simple toggle logic
                    if (root.currentMemMode === root.mem_MODE_PERCENT) {
                        root.currentMemMode = root.mem_MODE_TOTAL;
                    } else {
                        root.currentMemMode = root.mem_MODE_PERCENT;
                    }
                }
            }
        }

        Rectangle {
            width: 2
            height: 16
            color: root.colMuted
        }

        // Clock
        Rectangle {
            width: 60
            Layout.preferredHeight: parent.height
            color: "transparent"
            Text {
                id: clock
                color: root.colCyan
                font {
                    family: root.fontFamily
                    pixelSize: root.fontSize
                    bold: true
                }
                text: Qt.formatDateTime(new Date(), "HH:mm")
                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: clock.text = Qt.formatDateTime(new Date(), "HH:mm")
                }

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
            Rectangle {
                width: 60
                height: 3
                color: root.colCyan
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
            }
        }

        Rectangle {
            width: 2
            height: 16
            color: root.colMuted
        }

        Rectangle {
            id: trayContainer
            property int actualCount: 0

            // 2. Use a Connections object to watch the model
            Connections {
                target: SystemTray.items
                // These signals fire whenever the model changes
                function onRowsInserted() {
                    // trayContainer.actualCount = SystemTray.items.rowCount();
                    console.log("onRowsInserted()");
                }
                function onRowsRemoved() {
                    // trayContainer.actualCount = SystemTray.items.rowCount();
                    console.log("onRowsRemoved()");
                }
                function onModelReset() {
                    // trayContainer.actualCount = SystemTray.items.rowCount();
                    console.log("onModelReset()");
                }
            }

            Component.onCompleted: actualCount = SystemTray.items.rowCount()

            Layout.preferredWidth: trayRepeater.count > 0 ? (trayRepeater.count * 28) + 12 : 0
            width: Layout.preferredWidth
            visible: trayRepeater.count > 0
            height: parent.height
            color: root.colDarkBlue
            Row {
                id: trayRow
                anchors.centerIn: parent
                spacing: 12

                Repeater {
                    id: trayRepeater
                    model: SystemTray.items

                    delegate: Item {
                        id: trayDelegate
                        width: 18
                        height: 18
                        Image {
                            id: trayIcon

                            source: modelData.icon

                            anchors.fill: parent
                            fillMode: Image.PreserveAspectFit
                        }

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked: mouse => {
                                if (mouse.button === Qt.RightButton) {
                                    console.log("Right Click");
                                    var sceneCoords = mapToItem(null, mouse.x, 0);

                                    var finalY = root.height;

                                    console.log("Menu spawning at X:", sceneCoords.x, "Y:", finalY);

                                    modelData.display(root, sceneCoords.x, finalY);
                                } else {
                                    console.log("Left Click");
                                    modelData.activate();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
