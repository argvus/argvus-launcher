pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCore
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import org.argvus.i18n 1.0

ShellRoot {
    id: root
    property bool opened: true
    property bool ready: false
    property bool submenu: false
    property bool resetSelection: true
    property int sequence: 0
    property string category: ""
    property var results: []
    property var preferences: ({
            sources: [],
            favorites: [],
            reduced_motion: false
        })
    property var themeObject: null
    property string status: ""
    property string locale: "en-US"
    readonly property string configHome: Quickshell.env("ARGVUS_CONFIG_HOME") || StandardPaths.writableLocation(StandardPaths.GenericConfigLocation)
    readonly property string systemRoot: Quickshell.env("ARGVUS_SYSTEM_CONFIG") || "/usr/share/argvus"
    readonly property color background: themeObject ? themeObject.background : palette.window
    readonly property color foreground: themeObject ? themeObject.foreground : palette.windowText
    readonly property color muted: themeObject ? themeObject.muted : palette.placeholderText
    readonly property color accent: themeObject ? themeObject.accent : palette.highlight
    readonly property color selected: themeObject ? themeObject.selected : palette.alternateBase
    readonly property int radius: themeObject ? themeObject.radius : 16
    readonly property bool home: search.text.trim() === "" && category === "" && !submenu
    SystemPalette {
        id: palette
    }

    function iconSource(name) {
        return name ? Quickshell.iconPath(name, true) : "";
    }
    function glyph(category) {
        const glyphs = {
            applications: "󰀻",
            windows: "󰖲",
            settings: "󰒓",
            actions: "󰕾",
            projects: "󰉋",
            ssh: "󰆍",
            files: "󰉋",
            help: "󰍉"
        };
        return glyphs[category] || glyphs.applications;
    }
    function tr(key) {
        return I18n.tr("launcher", "universal." + key);
    }
    function send(message) {
        if (ready)
            engine.write(JSON.stringify(message) + "\n");
    }
    function query() {
        sequence += 1;
        send({
            op: "query",
            sequence: sequence,
            query: search.text,
            category: category
        });
    }
    function close() {
        opened = false;
        submenu = false;
        search.text = "";
    }
    function show() {
        opened = true;
        status = "";
        send({
            op: "refresh"
        });
        synchronizeClients();
        query();
        search.forceActiveFocus();
    }
    function back() {
        if (submenu) {
            submenu = false;
            search.text = "";
            send({
                op: "back"
            });
            query();
        } else
            close();
    }
    function choose(index) {
        if (results[index])
            send({
                op: "activate",
                id: results[index].id
            });
    }
    function synchronizeClients() {
        if (!ready)
            return;
        let entries = [];
        for (const app of DesktopEntries.applications.values) {
            entries.push({
                id: "app:" + app.id,
                title: app.name,
                description: app.comment || app.genericName,
                icon: app.icon,
                category: "applications",
                keywords: app.keywords,
                action: {
                    kind: "application",
                    value: app.id
                }
            });
        }
        for (const window of Hyprland.toplevels.values) {
            const appClass = window.lastIpcObject.class || "";
            const desktop = DesktopEntries.heuristicLookup(appClass);
            entries.push({
                id: "window:" + window.address,
                title: window.title || appClass,
                description: appClass,
                icon: desktop ? desktop.icon : "application-x-executable",
                category: "windows",
                keywords: [appClass],
                action: {
                    kind: "window",
                    value: window.address
                }
            });
        }
        send({
            op: "clients",
            entries: entries
        });
    }
    function loadCatalog(name, contents) {
        try {
            const catalogs = Object.assign({}, I18n.catalogs);
            catalogs[name + "/launcher"] = JSON.parse(contents);
            I18n.catalogs = catalogs;
            I18n.locale = locale;
        } catch (error) {
            console.warn("launcher catalog:", error);
        }
    }
    function receive(message) {
        if (message.event === "ready") {
            ready = true;
            preferences = message.settings;
            const saved = preferences.selected_category || "";
            root.category = preferences.sources.includes(saved) ? saved : "";
            categories.currentIndex = Math.max(0, categories.model.indexOf(root.category));
            if (saved !== root.category)
                root.send({
                    op: "select_category",
                    category: ""
                });
            synchronizeClients();
            query();
        } else if (message.event === "results" && message.sequence === sequence) {
            const selectedId = results[view.currentIndex] ? results[view.currentIndex].id : "";
            // Keep categories contiguous, preserving relevance within each group.
            const groups = {}, order = [];
            for (const entry of message.entries) {
                if (!groups[entry.category]) {
                    groups[entry.category] = [];
                    order.push(entry.category);
                }
                groups[entry.category].push(entry);
            }
            let next = [];
            for (const group of order)
                next = next.concat(groups[group]);
            results = next;
            const previous = resetSelection ? -1 : results.findIndex(entry => entry.id === selectedId);
            resetSelection = false;
            view.currentIndex = previous >= 0 ? previous : 0;
        } else if (message.event === "submenu") {
            submenu = true;
            search.text = "";
            query();
        } else if (message.event === "close")
            close();
        else if (message.event === "error")
            status = message.message;
        else if (message.event === "activate") {
            const action = message.action;
            if (action.kind === "application") {
                const app = DesktopEntries.byId(action.value);
                if (app && !app.noDisplay) {
                    app.execute();
                    close();
                } else
                    status = tr("action_error");
            } else if (action.kind === "window") {
                const window = Hyprland.toplevels.values.find(window => window.address === action.value);
                if (window && window.wayland) {
                    window.wayland.activate();
                    close();
                } else {
                    status = tr("action_error");
                    synchronizeClients();
                }
            }
        }
    }
    IpcHandler {
        target: "launcher"
        function toggle(): void {
            if (root.opened)
                root.close();
            else
                root.show();
        }
        function openPanel(): void {
            root.show();
        }
        function state(): string {
            return JSON.stringify({
                opened: root.opened,
                ready: root.ready,
                count: root.results.length,
                status: root.status
            });
        }
        function hide(): void {
            root.close();
        }
    }
    IpcHandler {
        target: "theme"
        function reload(): void {
            themeFile.reload();
        }
    }
    FileView {
        id: themeFile
        path: root.configHome + "/argvus/data/generated/theme/current/launcher/Theme.qml"
        printErrors: false
        onTextChanged: {
            try {
                const next = Qt.createQmlObject(text(), root, "launcherTheme");
                const previous = root.themeObject;
                root.themeObject = next;
                if (previous)
                    previous.destroy();
            } catch (error) {
                console.warn("launcher theme:", error);
            }
        }
    }
    FileView {
        path: root.configHome + "/argvus/config/launcher.json"
        printErrors: false
        watchChanges: true
        onFileChanged: {
            reload();
            root.send({
                op: "refresh"
            });
        }
    }
    Process {
        command: ["argvus", "i18n", "locale"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                root.locale = text.trim() || "en-US";
                I18n.locale = root.locale;
            }
        }
    }
    FileView {
        path: root.systemRoot + "/i18n/en-US/launcher.json"
        onTextChanged: root.loadCatalog("en-US", text())
    }
    FileView {
        path: root.systemRoot + "/i18n/" + root.locale + "/launcher.json"
        onTextChanged: root.loadCatalog(root.locale, text())
    }
    Process {
        id: engine
        command: ["argvus", "launcher-engine", "serve"]
        stdinEnabled: true
        running: true
        stdout: SplitParser {
            onRead: data => {
                try {
                    root.receive(JSON.parse(data));
                } catch (error) {
                    console.warn("launcher protocol:", error);
                }
            }
        }
        onExited: {
            root.ready = false;
            root.status = root.tr("engine_error");
        }
    }
    Timer {
        interval: 1000
        running: root.opened && root.ready
        repeat: true
        onTriggered: root.synchronizeClients()
    }
    Timer {
        id: debounce
        interval: 55
        onTriggered: root.query()
    }

    PanelWindow {
        id: overlay
        visible: root.opened
        screen: Hyprland.focusedMonitor ? Quickshell.screens.find(screen => screen.name === Hyprland.focusedMonitor.name) || Quickshell.screens[0] : Quickshell.screens[0]
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        exclusionMode: ExclusionMode.Ignore
        exclusiveZone: 0
        color: "transparent"
        WlrLayershell.namespace: "argvus-launcher"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
        onVisibleChanged: if (visible)
            search.forceActiveFocus()
        MouseArea {
            anchors.fill: parent
            onClicked: root.close()
        }
        Rectangle {
            id: panel
            anchors.horizontalCenter: parent.horizontalCenter
            y: Math.max(24, (overlay.height - height) * 0.35)
            width: Math.min(760, overlay.width - 32)
            height: Math.min(690, overlay.height - 48, Math.max(260, 180 + Math.min(root.results.length, 7) * 75 + (root.home && favoriteRepeater.count > 0 ? 100 : 0)))
            Keys.onEscapePressed: root.back()
            radius: root.radius
            color: root.background
            border.color: root.accent
            border.width: 1
            opacity: root.opened ? 1 : 0
            Behavior on opacity {
                NumberAnimation {
                    duration: root.preferences.reduced_motion ? 0 : 100
                }
            }
            MouseArea {
                anchors.fill: parent
            }
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 22
                spacing: 12
                RowLayout {
                    Layout.fillWidth: true
                    TextField {
                        id: search
                        Layout.fillWidth: true
                        font.pixelSize: 23
                        color: root.foreground
                        placeholderTextColor: root.muted
                        placeholderText: root.submenu ? root.tr("choose_device") : root.tr("placeholder")
                        background: Rectangle {
                            color: "transparent"
                        }
                        onTextChanged: {
                            root.resetSelection = true;
                            root.sequence += 1;
                            root.status = "";
                            debounce.restart();
                        }
                        Keys.onPressed: event => {
                            if (event.key === Qt.Key_Down) {
                                view.currentIndex = Math.min(root.results.length - 1, view.currentIndex + 1);
                                event.accepted = true;
                            } else if (event.key === Qt.Key_Up) {
                                view.currentIndex = Math.max(0, view.currentIndex - 1);
                                event.accepted = true;
                            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                root.choose(view.currentIndex);
                                event.accepted = true;
                            } else if (event.key === Qt.Key_Escape) {
                                root.back();
                                event.accepted = true;
                            } else if (event.key === Qt.Key_F && (event.modifiers & Qt.ControlModifier)) {
                                if (root.results[view.currentIndex])
                                    root.send({
                                        op: "favorite",
                                        id: root.results[view.currentIndex].id
                                    });
                                event.accepted = true;
                            }
                        }
                    }
                    Button {
                        id: configureButton
                        text: "󰒓"
                        palette.buttonText: root.foreground
                        background: Rectangle {
                            color: configureButton.hovered ? root.selected : "transparent"
                            radius: root.radius
                            border.color: configureButton.activeFocus ? root.accent : "transparent"
                        }
                        font.family: "Symbols Nerd Font Mono"
                        font.pixelSize: 22
                        Accessible.name: root.tr("configure")
                        ToolTip.visible: hovered
                        ToolTip.text: root.tr("configure")
                        onClicked: root.send({
                            op: "configure"
                        })
                    }
                }
                ComboBox {
                    id: categories
                    Layout.fillWidth: true
                    visible: !root.submenu
                    model: [""].concat(root.preferences.sources)
                    textRole: ""
                    implicitHeight: Math.max(24, implicitContentHeight + topPadding + bottomPadding)
                    Layout.minimumHeight: implicitHeight
                    leftPadding: 8
                    rightPadding: 24
                    topPadding: 4
                    bottomPadding: 4
                    background: Rectangle {
                        color: root.selected
                        radius: root.radius > 0 ? 4 : 0
                        border.color: categories.activeFocus ? root.accent : root.muted
                    }
                    contentItem: Text {
                        text: categories.displayText
                        color: root.foreground
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                    indicator: Text {
                        text: "▾"
                        color: root.foreground
                        x: categories.width - width - 8
                        y: (categories.height - height) / 2
                    }
                    popup: Popup {
                        y: categories.height + 4
                        width: categories.width
                        padding: 4
                        background: Rectangle {
                            color: root.background
                            radius: root.radius > 0 ? 4 : 0
                            border.color: root.accent
                        }
                        contentItem: ListView {
                            implicitHeight: Math.min(contentHeight, 320)
                            clip: true
                            model: categories.popup.visible ? categories.delegateModel : null
                            currentIndex: categories.highlightedIndex
                            ScrollBar.vertical: ScrollBar {}
                        }
                    }
                    palette.window: root.background
                    palette.base: root.background
                    palette.button: root.selected
                    palette.buttonText: root.foreground
                    palette.text: root.foreground
                    palette.highlight: root.accent
                    palette.highlightedText: root.foreground
                    palette.mid: root.accent
                    palette.dark: root.background
                    palette.light: root.selected
                    displayText: root.category === "" ? root.tr("all") : root.tr("source_" + root.category)
                    delegate: ItemDelegate {
                        id: categoryDelegate
                        required property var modelData
                        background: Rectangle {
                            color: categoryDelegate.hovered || categoryDelegate.highlighted ? root.selected : root.background
                            radius: root.radius > 0 ? 4 : 0
                        }
                        palette.text: root.foreground
                        palette.highlightedText: root.foreground
                        width: categories.popup.availableWidth
                        implicitHeight: Math.max(28, implicitContentHeight + topPadding + bottomPadding)
                        leftPadding: 8
                        rightPadding: 8
                        topPadding: 4
                        bottomPadding: 4
                        text: modelData === "" ? root.tr("all") : root.tr("source_" + modelData)
                    }
                    onActivated: {
                        root.category = model[currentIndex];
                        root.send({
                            op: "select_category",
                            category: root.category
                        });
                        root.query();
                        search.forceActiveFocus();
                    }
                }
                Label {
                    visible: root.home && favoriteRepeater.count > 0
                    text: root.tr("favorites")
                    color: root.muted
                }
                Flow {
                    visible: root.home && favoriteRepeater.count > 0
                    Layout.fillWidth: true
                    spacing: 8
                    Repeater {
                        id: favoriteRepeater
                        model: root.home ? root.results.filter(entry => root.preferences.favorites.includes(entry.id)).slice(0, 8) : []
                        delegate: Button {
                            required property var modelData
                            width: Math.max(110, (panel.width - 76) / 4)
                            height: 70
                            text: modelData.title
                            icon.source: root.preferences.show_icons === false ? "" : root.iconSource(modelData.icon)
                            display: AbstractButton.TextUnderIcon
                            onClicked: root.send({
                                op: "activate",
                                id: modelData.id
                            })
                        }
                    }
                }
                ListView {
                    id: view
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: root.results
                    spacing: 3
                    currentIndex: 0
                    boundsBehavior: Flickable.StopAtBounds
                    ScrollBar.vertical: ScrollBar {}
                    delegate: Item {
                        id: resultRow
                        readonly property int groupHeight: index <= 0 || !root.results[index - 1] || root.results[index - 1].category !== resultRow.modelData.category ? 30 : 0
                        required property var modelData
                        required property int index
                        width: view.width
                        height: 58 + groupHeight
                        Label {
                            height: parent.groupHeight
                            visible: height > 0
                            text: root.tr("source_" + resultRow.modelData.category)
                            color: root.muted
                            font.pixelSize: 12
                            verticalAlignment: Text.AlignVCenter
                        }
                        Rectangle {
                            anchors.fill: parent
                            anchors.topMargin: parent.groupHeight
                            radius: 9
                            color: view.currentIndex === resultRow.index ? root.selected : "transparent"
                            border.width: activeFocus ? 1 : 0
                            border.color: root.accent
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 9
                                spacing: 13
                                Image {
                                    id: resultIcon
                                    source: root.iconSource(resultRow.modelData.icon)
                                    visible: root.preferences.show_icons !== false && source.toString() !== "" && status !== Image.Error
                                    sourceSize.width: 32
                                    sourceSize.height: 32
                                    Layout.preferredWidth: 32
                                    Layout.preferredHeight: 32
                                }
                                Label {
                                    visible: root.preferences.show_icons !== false && !resultIcon.visible
                                    text: root.glyph(resultRow.modelData.category)
                                    font.family: "Symbols Nerd Font Mono"
                                    font.pixelSize: 28
                                    color: root.accent
                                    Layout.preferredWidth: 32
                                }
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 2
                                    Label {
                                        Layout.fillWidth: true
                                        text: resultRow.modelData.title
                                        color: root.foreground
                                        font.pixelSize: 16
                                        elide: Text.ElideRight
                                    }
                                    Label {
                                        Layout.fillWidth: true
                                        text: resultRow.modelData.description
                                        color: root.muted
                                        font.pixelSize: 11
                                        elide: Text.ElideMiddle
                                    }
                                }
                                ToolButton {
                                    text: root.preferences.favorites.includes(resultRow.modelData.id) ? "★" : "☆"
                                    Accessible.name: root.tr("favorite")
                                    onClicked: root.send({
                                        op: "favorite",
                                        id: resultRow.modelData.id
                                    })
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                anchors.rightMargin: 50
                                hoverEnabled: true
                                onEntered: view.currentIndex = resultRow.index
                                onClicked: root.choose(resultRow.index)
                            }
                        }
                    }
                    Label {
                        anchors.centerIn: parent
                        visible: root.results.length === 0
                        text: root.ready ? root.tr("empty") : root.tr("loading")
                        color: root.muted
                    }
                }
                Label {
                    Layout.fillWidth: true
                    visible: root.status !== ""
                    text: root.status
                    color: root.foreground
                    wrapMode: Text.Wrap
                }
                Label {
                    text: root.tr("hints")
                    color: root.muted
                    font.pixelSize: 11
                }
            }
        }
    }
}
