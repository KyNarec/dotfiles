local notif = os.getenv("HOME") .. "/.config/swaync/images/bell.png"

local function toggleWifi()
    -- Run rfkill and capture output
    local handle = io.popen("rfkill list wifi")
    if not handle then
        print("Error running rfkill")
        return
    end

    local output = handle:read("*a") or ""
    handle:close()

    -- Check if any line says "Soft blocked: yes"
    if output:match("Soft blocked:%s+yes") then
        os.execute("rfkill unblock wifi")
        os.execute('notify-send -u low -i "' .. notif .. '" "Airplane mode: OFF" &')
    else
        os.execute("rfkill block wifi")
        os.execute('notify-send -u low -i "' .. notif .. '" "Airplane mode: ON" &')
    end
end

return {
    toggleWifi = toggleWifi,
}
