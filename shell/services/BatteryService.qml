pragma Singleton
import QtQuick
import Quickshell.Services.UPower

Item {




    readonly property var device: UPower.displayDevice
    readonly property bool present: device !== null && device.isPresent
    readonly property int percentage: present ? Math.round(device.percentage) : 0
    readonly property bool onBattery: present && UPower.onBattery
    readonly property bool charging: present && device.state === UPowerDeviceState.Charging
    readonly property bool fullyCharged: present && device.state === UPowerDeviceState.FullyCharged
    readonly property double timeToEmpty: present ? device.timeToEmpty : -1
    readonly property double timeToFull: present ? device.timeToFull : -1
}