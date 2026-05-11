-- Music control Lua module
local music_icon = os.getenv("HOME") .. "/.config/swaync/icons/music.png"

-- Function to display notifications
local function show_music_notification()
    local handle, err = io.popen("playerctl status &")
    if not handle then
        print("Error running playerctl:", err)
        return
    end

    local status = handle:read("*a")
    handle:close()

    if not status then
        return
    end

    status = status:gsub("%s+$", "") -- trim trailing newline

    if status == "Playing" then
        local title_handle = io.popen("playerctl metadata title &")
        local title = title_handle and title_handle:read("*a") or "Unknown"
        if title_handle then title_handle:close() end
        title = title:gsub("%s+$", "")

        local artist_handle = io.popen("playerctl metadata artist &")
        local artist = artist_handle and artist_handle:read("*a") or "Unknown"
        if artist_handle then artist_handle:close() end
        artist = artist:gsub("%s+$", "")

        os.execute('notify-send -e -u low -i "' .. music_icon .. '" "Now Playing:" "' ..
            title .. '\\nby ' .. artist .. '" &')
    elseif status == "Paused" then
        os.execute('notify-send -e -u low -i "' .. music_icon .. '" "Playback Paused" &')
    end
end

local function play_next()
    os.execute("playerctl next &")
    show_music_notification()
end

local function play_previous()
    os.execute("playerctl previous &")
    show_music_notification()
end

local function toggle_play_pause()
    os.execute("playerctl play-pause &")
    show_music_notification()
end

local function stop_playback()
    os.execute("playerctl stop &")
    os.execute('notify-send -e -u low -i "' .. music_icon .. '" "Playback Stopped" &')
end

-- Return functions for keybinds
return {
    next = play_next,
    previous = play_previous,
    pause = toggle_play_pause,
    stop = stop_playback
}
