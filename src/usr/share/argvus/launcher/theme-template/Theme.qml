import QtQuick
QtObject {
    readonly property color background: "{{ @bg | hex }}"
    readonly property color foreground: "{{ @fg | hex }}"
    readonly property color muted: "{{ @fg_dim | hex }}"
    readonly property color accent: "{{ @accent | hex }}"
    readonly property color selected: "{{ @bg | mix(@fg, 0.1) | hex }}"
    readonly property int radius: {{ layout.panel_radius }}
}
