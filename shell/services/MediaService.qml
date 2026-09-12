pragma Singleton
import QtQuick
import Quickshell.Services.Mpris

Item {



    readonly property var players: Mpris.players


    readonly property var active: {
        if (!Mpris.players) return null
        var vals = Mpris.players.values
        if (!vals || vals.length === 0) return null
        for (var i = 0; i < vals.length; i++) {
            if (vals[i] && vals[i].isPlaying) return vals[i]
        }
        return vals[vals.length - 1]
    }

    readonly property bool hasPlayer: active !== null
    readonly property bool isPlaying: hasPlayer && active.isPlaying
    readonly property string title: hasPlayer ? active.trackTitle : ""
    readonly property string artist: hasPlayer ? active.trackArtist : ""
    readonly property string album: hasPlayer ? active.trackAlbum : ""
    readonly property string artUrl: hasPlayer ? active.trackArtUrl : ""
    readonly property double position: hasPlayer && active.positionSupported ? active.position : -1
    readonly property double length: hasPlayer && active.lengthSupported ? active.length : -1

    function togglePlay()  { if (hasPlayer && active.canTogglePlaying)  active.togglePlaying() }
    function play()        { if (hasPlayer && active.canPlay)          active.play() }
    function pause()       { if (hasPlayer && active.canPause)         active.pause() }
    function next()        { if (hasPlayer && active.canGoNext)        active.next() }
    function previous()    { if (hasPlayer && active.canGoPrevious)    active.previous() }
    function seek(sec)     { if (hasPlayer && active.canSeek)          active.seek(sec) }
    function setPosition(sec) { if (hasPlayer && active.canSeek)       active.position = sec }

    function formatTime(sec) {
        if (sec < 0 || !isFinite(sec)) return "--:--"
        var s = Math.floor(sec)
        var m = Math.floor(s / 60)
        var rest = s % 60
        return m + ":" + (rest < 10 ? "0" + rest : rest)
    }
}