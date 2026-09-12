pragma Singleton
import QtQuick
import Quickshell.Services.Pipewire

Item {



    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource

    readonly property bool sinkReady: sink !== null && sink.ready
    readonly property bool sourceReady: source !== null && source.ready

    readonly property double volume: sinkReady ? sink.volume : 0.0
    readonly property bool muted: sinkReady ? sink.muted : false
    readonly property double micVolume: sourceReady ? source.volume : 0.0
    readonly property bool micMuted: sourceReady ? source.muted : false

    function setVolume(v) { if (sinkReady) sink.volume = Math.max(0, Math.min(1, v)) }
    function setMuted(m)  { if (sinkReady) sink.muted = m }
    function setMicMuted(m) { if (sourceReady) source.muted = m }
    function setMicVolume(v) { if (sourceReady) source.volume = Math.max(0, Math.min(1, v)) }

    function toggleMute()    { setMuted(!muted) }
    function toggleMicMute() { setMicMuted(!micMuted) }
}