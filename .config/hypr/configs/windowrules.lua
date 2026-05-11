hl.window_rule({
    match = {
        class = "[Nn]emo"
    },
    float = true,
    center = true,
    size = { "(monitor_w*0.55)", "(monitor_h*0.7)" }
})

hl.window_rule({
    match = {
        fullscreen = true
    },
    idle_inhibit = "fullscreen"
})

hl.window_rule({
    match = {
        class = "org.mozilla.Thunderbird"
    },
    workspace = "7"
})

hl.window_rule({
    match = {
        class = "[Vv]esktop"
    },
    workspace = "1"
})

hl.window_rule({
    match = {
        class = "virt-manager"
    },
    workspace = "6"
})

hl.window_rule({
    match = {
        class = "[Ll]ocal[Ss]end"
    },
    -- workspace = "silent 9"
    workspace = "9 silent"
})

hl.window_rule({
    match = {
        class = "org.gnome.Calculator"
    },
    float = true,
    center = true,
    size = { "(monitor_w*0.3)", "(monitor_h*0.7)" }
})


hl.window_rule({
    match = {
        class = "(pavucontrol|org.pulseaudio.pavucontrol)"
    },
    float = true,
    center = true,
    size = { "(monitor_w*0.4)", "(monitor_h*0.5)" }
})

hl.window_rule({
    match = {
        class = "blueman-manager"
    },
    float = true,
    center = true,
    size = { "(monitor_w*0.4)", "(monitor_h*0.5)" }
})
