local mainMod = "SUPER"
local files = "nemo"
local term = "kitty"
local userScripts = "~/.config/hypr/UserScripts/"
local scripts = "~/.config/hypr/scripts/"

-- term
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(term))

-- app picker
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("vicinae toggle"))

-- files
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(files))

-- pyprland
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd("pypr toggle term"))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("pypr zoom"))

-- fullscreen & floating
hl.bind(mainMod .. " + F", function()
    hl.dispatch(hl.dsp.window.fullscreen({ toggle = true }))
end)
hl.bind(mainMod .. " + SHIFT + F", function()
    hl.dispatch(hl.dsp.window.float({ toggle = true }))
end)

-- killing windows
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.kill())

-- wallpaper stuff
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(userScripts .. "WallpaperSelect.sh"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(userScripts .. "WallpaperEffects.sh"))
hl.bind(mainMod .. " + ALT + W", hl.dsp.exec_cmd(userScripts .. "WallpaperEngineSelect.sh"))

-- emoji picker
hl.bind(mainMod .. " + ALT + E", hl.dsp.exec_cmd(scripts .. "RofiEmoji.sh"))

-- clipboard manager
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(scripts .. "ClipManager.sh"))

-- logout & lock screen
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(scripts .. "LockScreen.sh"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(scripts .. "Wlogout.sh"))

-- screenshot
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(scripts .. "ScreenShot.sh --now"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(scripts .. "ScreenShot.sh --swappy"))

-- window switching
hl.bind("ALT + TAB", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end)
hl.bind(mainMod .. " + TAB", hl.dsp.focus({ workspace = "m+1" }))

-- navigate to workspace
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + mouse_right", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + mouse_left", hl.dsp.focus({ workspace = "m-1" }))

hl.bind(mainMod .. " + code:10", hl.dsp.focus({ workspace = "1" }))
hl.bind(mainMod .. " + code:11", hl.dsp.focus({ workspace = "2" }))
hl.bind(mainMod .. " + code:12", hl.dsp.focus({ workspace = "3" }))
hl.bind(mainMod .. " + code:13", hl.dsp.focus({ workspace = "4" }))
hl.bind(mainMod .. " + code:14", hl.dsp.focus({ workspace = "5" }))
hl.bind(mainMod .. " + code:15", hl.dsp.focus({ workspace = "6" }))
hl.bind(mainMod .. " + code:16", hl.dsp.focus({ workspace = "7" }))
hl.bind(mainMod .. " + code:17", hl.dsp.focus({ workspace = "8" }))
hl.bind(mainMod .. " + code:18", hl.dsp.focus({ workspace = "9" }))
hl.bind(mainMod .. " + code:19", hl.dsp.focus({ workspace = "10" }))

-- move active window and follow to workspace mainMod + SHIFT [0-9]
hl.bind(mainMod .. " + SHIFT + code:10", hl.dsp.window.move({ workspace = "1" }))
hl.bind(mainMod .. " + SHIFT + code:11", hl.dsp.window.move({ workspace = "2" }))
hl.bind(mainMod .. " + SHIFT + code:12", hl.dsp.window.move({ workspace = "3" }))
hl.bind(mainMod .. " + SHIFT + code:13", hl.dsp.window.move({ workspace = "4" }))
hl.bind(mainMod .. " + SHIFT + code:14", hl.dsp.window.move({ workspace = "5" }))
hl.bind(mainMod .. " + SHIFT + code:15", hl.dsp.window.move({ workspace = "6" }))
hl.bind(mainMod .. " + SHIFT + code:16", hl.dsp.window.move({ workspace = "7" }))
hl.bind(mainMod .. " + SHIFT + code:17", hl.dsp.window.move({ workspace = "8" }))
hl.bind(mainMod .. " + SHIFT + code:18", hl.dsp.window.move({ workspace = "9" }))
hl.bind(mainMod .. " + SHIFT + code:19", hl.dsp.window.move({ workspace = "10" }))


hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })


-- resize (relative)
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })

-- move windows
hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.move({ direction = "l" }), { repeating = true })
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ direction = "r" }), { repeating = true })
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.move({ direction = "u" }), { repeating = true })
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.move({ direction = "d" }), { repeating = true })

-- move focus
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }), { repeating = true })
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }), { repeating = true })
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }), { repeating = true })
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }), { repeating = true })

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- cycle keyboard layout
local cmd = [[
  hyprctl switchxkblayout at-translated-set-2-keyboard next && \
  LAYOUT=$(hyprctl devices -j | jq -r '.keyboards[] | select(.name == "at-translated-set-2-keyboard") | .active_keymap') && \
  notify-send "Keyboard: $LAYOUT"
]]
hl.bind("ALT + SHIFT_L", hl.dsp.exec_cmd(cmd), { on_release = true })

-- special keys
local volume = require("scripts.volume")
local mic = require("scripts.microphone")
local airplaneMode = require("scripts.airplaneMode")

hl.bind("xf86audioraisevolume", volume.increaseVolume, { repeating = true })
hl.bind("xf86audiolowervolume", volume.decreaseVolume, { repeating = true })
hl.bind("xf86audiomute", volume.toggleMute)
hl.bind("xf86AudioMicMute", mic.toggleMic)
hl.bind("xf86Sleep", hl.dsp.exec_cmd("systemctl suspend"))
hl.bind("xf86Rfkill", airplaneMode.toggleWifi)


-- hl.bind(mainMod .. " + H", mic.toggleMic)
-- hl.bind(mainMod .. " + J", mic.decreaseMicVolume)
-- hl.bind(mainMod .. " + K", mic.increaseMicVolume)

-- media controls
local media = require("scripts.media")
hl.bind("XF86AudioPause", media.pause)
hl.bind("XF86AudioPlay", media.pause)
hl.bind("XF86AudioPrev", media.previous)
hl.bind("XF86AudioNext", media.next)
hl.bind("XF86AudioStop", media.stop)
