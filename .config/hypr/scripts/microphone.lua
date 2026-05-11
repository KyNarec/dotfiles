local iDir = os.getenv("HOME") .. "/.config/swaync/icons/"

local function getMicIcon()
    local handle, err = io.popen("pamixer --default-source --get-volume")
    if not handle then
        print("Error running pamixer:", err)
        return
    end
    local output = handle:read("*a") or ""
    handle:close()
    output = output:gsub("%s+$", "")

    if tonumber(output) == 0 then
        return iDir .. "microphone-mute.png"
    else
        return iDir .. "microphone.png"
    end
end

local function getMicVolume()
    local handle, err = io.popen("pamixer --default-source --get-volume")
    if not handle then
        print("Error running pamixer:", err)
        return
    end
    local output = handle:read("*a") or ""
    handle:close()
    output = output:gsub("%s+$", "")

    if tonumber(output) == 0 then
        return "muted"
    else
        return tonumber(output)
    end
end

local function notifyMicUser()
    local volume = getMicVolume()
    local icon = getMicIcon()

    os.execute('notify-send -e -h int:value:"' ..
        volume ..
        '" -h "string:x-canonical-private-synchronous:volume_notif" -u low -i "' ..
        icon .. '" "Mic-Level: ' .. volume .. '" &')
end

local function toggleMic()
    local handle, err = io.popen("pamixer --default-source --get-mute")
    if not handle then
        print("Error running pamixer:", err)
        return
    end
    local output = handle:read("*a") or ""
    handle:close()
    output = output:gsub("%s+$", "")
    if output == "false" then
        os.execute("pamixer --default-source -m")
        os.execute('notify-send -e -u low -i "' .. iDir .. 'microphone-mute.png" "Microphone Switched OFF" &')
    elseif output == "true" then
        os.execute("pamixer --default-source -u")
        os.execute('notify-send -e -u low -i "' .. iDir .. 'microphone.png" "Microphone Switched ON" &')
    end
end

local function increaseMicVolume()
    local handle, err = io.popen("pamixer --default-source --get-mute")
    if not handle then
        print("Error running pamixer:", err)
        return
    end
    local output = handle:read("*a") or ""
    handle:close()
    output = output:gsub("%s+$", "")
    if output == "true" then
        toggleMic()
    else
        os.execute("pamixer --default-source -i 5")
        notifyMicUser()
    end
end

local function decreaseMicVolume()
    local handle, err = io.popen("pamixer --default-source --get-mute")
    if not handle then
        print("Error running pamixer:", err)
        return
    end
    local output = handle:read("*a") or ""
    handle:close()
    output = output:gsub("%s+$", "")
    if output == "true" then
        toggleMic()
    else
        os.execute("pamixer --default-source -d 5")
        notifyMicUser()
    end
end


return {
    toggleMic = toggleMic,
    increaseMicVolume = increaseMicVolume,
    decreaseMicVolume = decreaseMicVolume,
}
