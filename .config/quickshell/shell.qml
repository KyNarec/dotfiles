//@ pragma UseQApplication
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io

ShellRoot {
    id: shell

    property int cpuUsage: 0
    property int memUsagePercent: 0
    property string memUsageTotal: "0.00"
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0

    Variants {
        id: barVariants
        model: Quickshell.screens
        delegate: Bar {
            cpuUsage: shell.cpuUsage
            memUsagePercent: shell.memUsagePercent
            memUsageTotal: shell.memUsageTotal
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            cpuProc.running = true;
            memProc.running = true;
        }
    }

    Process {
        id: cpuProc
        command: ["sh", "-c", "head -1 /proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                if (!data)
                    return;
                var parts = data.trim().split(/\s+/);
                var total = parts.slice(1, 8).reduce((a, b) => parseInt(a) + parseInt(b), 0);
                var idleTime = parseInt(parts[4]) + parseInt(parts[5]);

                if (shell.lastCpuTotal > 0) {
                    var totalDiff = total - shell.lastCpuTotal;
                    var idleDiff = idleTime - shell.lastCpuIdle;
                    if (totalDiff > 0) {
                        shell.cpuUsage = Math.round(100 * (totalDiff - idleDiff) / totalDiff);
                    }
                }
                shell.lastCpuTotal = total;
                shell.lastCpuIdle = idleTime;
            }
        }
    }

    Process {
        id: memProc
        command: ["sh", "-c", "free | grep Mem"]
        stdout: SplitParser {
            onRead: data => {
                if (!data)
                    return;
                var parts = data.trim().split(/\s+/);
                var total = parseInt(parts[1]) || 1;
                var used = parseInt(parts[2]) || 0;
                shell.memUsagePercent = Math.round(100 * used / total);
                shell.memUsageTotal = (used / (1024 * 1024)).toFixed(2);
            }
        }
    }
}
