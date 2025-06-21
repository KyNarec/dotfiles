//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic

import "./modules/common/"
import "./modules/backgroundWidgets/"
import "./modules/bar/"
import "./modules/cheatsheet/"
import "./modules/dock/"
import "./modules/mediaControls/"
import "./modules/notificationPopup/"
import "./modules/onScreenDisplay/"
import "./modules/onScreenKeyboard/"
import "./modules/overview/"
import "./modules/screenCorners/"
import "./modules/session/"
import "./modules/sidebarLeft/"
import "./modules/sidebarRight/"
import "./modules/hyprmenu/"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Quickshell
import "./services/"

ShellRoot {
    // Enable/disable modules here. False = not loaded at all, so rest assured
    // no unnecessary stuff will take up memory if you decide to only use, say, the overview.
    property bool enableBar: false
    property bool enableBackgroundWidgets: false
    property bool enableCheatsheet: false
    property bool enableDock: true
    property bool enableMediaControls: false
    property bool enableNotificationPopup: false
    property bool enableOnScreenDisplayBrightness: false
    property bool enableOnScreenDisplayVolume: false
    property bool enableOnScreenKeyboard: false
    property bool enableOverview: false
    property bool enableReloadPopup: true
    property bool enableScreenCorners: false
    property bool enableSession: true
    property bool enableSidebarLeft: false
    property bool enableSidebarRight: false
    property bool enableHyprMenu: true

    // Force initialization of some singletons
    Component.onCompleted: {
        MaterialThemeLoader.reapplyTheme()
        ConfigLoader.loadConfig()
        PersistentStateManager.loadStates()
        Cliphist.refresh()
        FirstRunExperience.load()
    }

    Loader { active: enableBar; sourceComponent: Bar {} }
    Loader { active: enableBackgroundWidgets; sourceComponent: BackgroundWidgets {} }
    Loader { active: enableCheatsheet; sourceComponent: Cheatsheet {} }
    Loader { active: enableDock; sourceComponent: Dock {} }
    Loader { active: enableHyprMenu; sourceComponent: HyprMenu {} }
    Loader { active: enableMediaControls; sourceComponent: MediaControls {} }
    Loader { active: enableNotificationPopup; sourceComponent: NotificationPopup {} }
    Loader { active: enableOnScreenDisplayBrightness; sourceComponent: OnScreenDisplayBrightness {} }
    Loader { active: enableOnScreenDisplayVolume; sourceComponent: OnScreenDisplayVolume {} }
    Loader { active: enableOnScreenKeyboard; sourceComponent: OnScreenKeyboard {} }
    Loader { active: enableOverview; sourceComponent: Overview {} }
    Loader { active: enableReloadPopup; sourceComponent: ReloadPopup {} }
    Loader { active: enableScreenCorners; sourceComponent: ScreenCorners {} }
    Loader { active: enableSession; sourceComponent: Session {} }
    Loader { active: enableSidebarRight; sourceComponent: SidebarRight {} }
}

