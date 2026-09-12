.pragma library


var _map = {
    playArrow: 0xe037, pause: 0xe034, skipPrevious: 0xe045, skipNext: 0xe044,
    musicNote: 0xe405, search: 0xe8b6, settings: 0xe8b8, wifi: 0xe63e,
    bluetooth: 0xe1a7, volumeUp: 0xe050, volumeOff: 0xe04f, volumeDown: 0xe04d,
    brightnessHigh: 0xe1ac, brightnessLow: 0xe1ad, darkMode: 0xe51c,
    lightMode: 0xe518, nightlight: 0xf03d, batteryFull: 0xe1a5,
    batteryAlert: 0xe19c, batteryCharging: 0xe1a3, batteryUnknown: 0xe1a6,
    battery0: 0xebdc, battery1: 0xf09c, battery2: 0xf09d, battery3: 0xf09e,
    battery4: 0xf09f, battery5: 0xf0a0, battery6: 0xf0a1, power: 0xe63c,
    event: 0xe878, calendarMonth: 0xebcc, memory: 0xe322, thermostat: 0xf076,
    graphicEq: 0xe1b8, networkCheck: 0xe640, arrowUp: 0xe5d8,
    arrowDown: 0xe5db, trendingUp: 0xe8e5, notifications: 0xe7f5,
    notificationsOff: 0xe7f6, mic: 0xe31d, micOff: 0xe02b, monitor: 0xef5b,
    update: 0xe923, close: 0xe5cd, check: 0xe5ca, chevronLeft: 0xe5cb,
    chevronRight: 0xe5cc, expandMore: 0xe5cf, gridView: 0xe9b0,
    dashboard: 0xe871, tune: 0xe429, rocket: 0xeba5, lock: 0xe899,
    bedtime: 0xf159, devices: 0xe326, stream: 0xe9e9, dataUsage: 0xeff2,
    timer: 0xe425, speed: 0xe9e4, monitorHeart: 0xeaa2, favorite: 0xe87e,
    alarm: 0xe855, star: 0xf09a, light: 0xf02a, playlistPlay: 0xe05f,
    settingsInput: 0xebfe, networkWifi: 0xe1ba, signalWifi4: 0xf065,
    cellularAlt: 0xe202, dns: 0xe875, storage: 0xe1db, folder: 0xe2c7,
    download: 0xf090, upload: 0xf09b
}

function code(name) {
    var cp = _map[name]
    return cp !== undefined ? String.fromCharCode(cp) : ""
}