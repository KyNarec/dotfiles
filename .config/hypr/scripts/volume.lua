local iDir = os.getenv("HOME") .. "/.config/swaync/icons/"

local function getVolume()
    local handle, err = io.popen("pamixer --get-volume")
    if not handle then
        print("Error running pamixer:", err)
        return 0
    end

    local output = handle:read("*a") or ""
    handle:close()
    output = output:gsub("%s+$", "") -- trim newline

    local volume = tonumber(output)
    if volume == 0 then
        return "muted"
    else
        return volume
    end
end

local function getIcon()
    local current = getVolume()
    if current == "muted" then
        return iDir .. "volume-mute.png"
    elseif current < 30 then
        return iDir .. "volume-low.png"
    elseif current < 60 then
        return iDir .. "volume-mid.png"
    else
        return iDir .. "volume-high.png"
    end
end


local function notifyUser()
    local current = getVolume()
    if current == "muted" then
        os.execute('notify-send -e -h string:x-canonical-private-synchronous:volume_notif -u low -i "' ..
            getIcon() .. '" "Volume: Muted" &')
    else
        os.execute('notify-send -e -h int:value:"' ..
            current .. ' %" -h string:x-canonical-private-synchronous:volume_notif -u low -i "' ..
            getIcon() .. '" "Volume: ' .. current .. '" &')
    end
end

local function toggleMute()
    local handle, err = io.popen("pamixer --get-mute")
    if not handle then
        print("Error running playerctl:", err)
        return
    end

    local output = handle:read("*a") or "" -- read output
    handle:close()

    output = output:gsub("%s+$", "") -- trim newline
    if output == "false" then
        os.execute("pamixer -m &")
        os.execute('notify-send -e -u low -i "' .. iDir .. 'volume-mute.png" "Volume Switched Off" &')
    elseif output == "true" then
        os.execute("pamixer -u &")
        os.execute('notify-send -e -u low -i "' .. getIcon() .. '" "Volume Switched ON" &')
    end
end

local function increaseVolume()
    local handle, err = io.popen("pamixer --get-mute")
    if not handle then
        print("Error running pamixer:", err)
        return
    end

    local output = handle:read("*a") or "" -- read output
    handle:close()

    output = output:gsub("%s+$", "") -- trim newline
    if output == "true" then
        toggleMute()
    else
        os.execute("pamixer -i 5 --allow-boost --set-limit 200")
        notifyUser()
    end
end

local function decreaseVolume()
    local handle, err = io.popen("pamixer --get-mute")
    if not handle then
        print("Error running pamixer:", err)
        return
    end

    local output = handle:read("*a") or "" -- read output
    handle:close()
    output = output:gsub("%s+$", "")       -- trim newline

    if output == "true" then
        toggleMute()
    else
        os.execute("pamixer -d 5")
        notifyUser()
    end
end


return {
    increaseVolume = increaseVolume,
    decreaseVolume = decreaseVolume,
    toggleMute = toggleMute,
}
