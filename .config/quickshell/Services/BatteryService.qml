pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: root
    property bool suppressSound: true
    property bool previousPluggedState: false

    readonly property int scale: 1

    Timer {
        id: startupTimer
        interval: 500
        repeat: false
        running: true
        onTriggered: root.suppressSound = false
    }

    readonly property string preferredBatteryOverride: Quickshell.env("DMS_PREFERRED_BATTERY")

    // List of laptop batteries
    readonly property var batteries: UPower.devices.values.filter(dev => dev.isLaptopBattery)

    readonly property bool usePreferred: preferredBatteryOverride && preferredBatteryOverride.length > 0

    // Main battery (for backward compatibility)
    readonly property UPowerDevice device: {
        var preferredDev;
        if (usePreferred) {
            preferredDev = batteries.find(dev => dev.nativePath.toLowerCase().includes(preferredBatteryOverride.toLowerCase()));
        }
        return preferredDev || batteries[0] || null;
    }
    // Whether at least one battery is available
    readonly property bool batteryAvailable: batteries.length > 0
    // Aggregated charge level (percentage)
    readonly property real batteryLevel: {
        if (!batteryAvailable)
            return 0;
        if (batteryCapacity === 0) {
            if (usePreferred && device && device.ready)
                return Math.round(device.percentage * 100 * scale);
            const validBatteries = batteries.filter(b => b.ready && b.percentage >= 0);
            if (validBatteries.length === 0)
                return 0;
            const avgPercentage = validBatteries.reduce((sum, b) => sum + b.percentage, 0) / validBatteries.length;
            return Math.round(avgPercentage * 100 * scale);
        }
        return Math.round((batteryEnergy * 100) / batteryCapacity * scale);
    }
    readonly property bool isCharging: batteryAvailable && batteries.some(b => b.state === UPowerDeviceState.Charging)

    // Is the system plugged in (Is not running on battery)
    readonly property bool isPluggedIn: !UPower.onBattery
    readonly property bool isLowBattery: batteryAvailable && batteryLevel <= 20

    // Aggregated charge/discharge rate
    readonly property real changeRate: {
        if (!batteryAvailable)
            return 0;
        if (usePreferred && device && device.ready)
            return device.changeRate;
        return batteries.length > 0 ? batteries.reduce((sum, b) => sum + b.changeRate, 0) : 0;
    }

    // Aggregated battery health
    readonly property string batteryHealth: {
        if (!batteryAvailable)
            return "N/A";

        // If a preferred battery is selected and ready
        if (usePreferred && device && device.ready && device.healthSupported)
            return `${Math.round(device.healthPercentage)}%`;

        // Otherwise, calculate the average health of all laptop batteries
        const validBatteries = batteries.filter(b => b.healthSupported && b.healthPercentage > 0);
        if (validBatteries.length === 0)
            return "N/A";

        const avgHealth = validBatteries.reduce((sum, b) => sum + b.healthPercentage, 0) / validBatteries.length;
        return `${Math.round(avgHealth)}%`;
    }
    readonly property real batteryEnergy: {
        if (!batteryAvailable)
            return 0;
        if (usePreferred && device && device.ready)
            return device.energy;
        return batteries.length > 0 ? batteries.reduce((sum, b) => sum + b.energy, 0) : 0;
    }

    // Total battery capacity (Wh)
    readonly property real batteryCapacity: {
        if (!batteryAvailable)
            return 0;
        if (usePreferred && device && device.ready)
            return device.energyCapacity;
        return batteries.length > 0 ? batteries.reduce((sum, b) => sum + b.energyCapacity, 0) : 0;
    }
    readonly property string batteryStatus: {
        if (!batteryAvailable) {
            return "No Battery";
        }

        if (isCharging && !batteries.some(b => b.changeRate > 0))
            return "Plugged In";

        const states = batteries.map(b => b.state);
        if (states.every(s => s === states[0]))
            return translateBatteryState(states[0]);

        return isCharging ? "Charging" : (isPluggedIn ? "Plugged In" : "Discharging");
    }

    function translateBatteryState(state) {
        switch (state) {
        case UPowerDeviceState.Charging:
            return "Charging";
        case UPowerDeviceState.Discharging:
            return "Discharging";
        case UPowerDeviceState.Empty:
            return "Empty";
        case UPowerDeviceState.FullyCharged:
            return "Fully Charged";
        case UPowerDeviceState.PendingCharge:
            return "Pending Charge";
        case UPowerDeviceState.PendingDischarge:
            return "Pending Discharge";
        default:
            return "Unknown";
        }
    }

    readonly property bool suggestPowerSaver: false

    // https://enci.github.io/fluent-icons-cheatsheet/
    readonly property string batteryIcon: {
      if (!isCharging) {
        if (batteryLevel > 95) return "\ue143";
        if (batteryLevel > 90) return "\uf1cd";
        if (batteryLevel > 80) return "\uf1cb";
        if (batteryLevel > 70) return "\uf1c9";
        if (batteryLevel > 60) return "\uf1c7";
        if (batteryLevel > 50) return "\uf1c5";
        if (batteryLevel > 40) return "\uf1c3";
        if (batteryLevel > 30) return "\uf1c1";
        if (batteryLevel > 20) return "\uf1bf";
        if (batteryLevel > 5) return "\uf1bd";
        return "\uf1bb" // 0 battery
  
}
     else if(isCharging) {
        if (batteryLevel > 98) return "\u{f0aad}";
        if (batteryLevel > 90) return "\u{f0ab5}";
        if (batteryLevel > 80) return "\u{f0ab4}";
        if (batteryLevel > 70) return "\u{f0ab3}";
        if (batteryLevel > 60) return "\u{f0ab2}";
        if (batteryLevel > 50) return "\u{f0ab1}";
        if (batteryLevel > 40) return "\u{f0ab0}";
        if (batteryLevel > 30) return "\u{f0aaf}";
        if (batteryLevel > 20) return "\u{f0aae}";
        if (batteryLevel > 5) return "\u{f0aac}";
        return "\u{f0aab}" // 0 charge
    }
    return "\ue147" // battery warning
  }
}
