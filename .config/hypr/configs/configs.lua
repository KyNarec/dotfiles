hl.config({
    input = {
        kb_layout = "de,us",
        -- kb_options = "grp:alt_shift_toggle,caps:escape",
        kb_options = "caps:escape",
        repeat_rate = 50,
        repeat_delay = 300,
        numlock_by_default = false,
        left_handed = false,
        follow_mouse = 1,
        float_switch_override_focus = 1,

        accel_profile = "flat",
        sensitivity = 0,

        touchpad = {
            natural_scroll = true,
            disable_while_typing = true,
            -- might change that to true
            clickfinger_behavior = false,
            tap_to_click = true,
            drag_lock = false
        }
    },

    cursor = {
        -- no_hardware_cursor = true,
        enable_hyprcursor = true
    },

    gestures = {
        workspace_swipe_distance = 300,
        workspace_swipe_invert = true,
        workspace_swipe_min_speed_to_force = 30,
        workspace_swipe_cancel_ratio = 0.5,
        workspace_swipe_create_new = true,
        workspace_swipe_forever = true,
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
        enable_swallow = true,
        focus_on_activate = true,
        swallow_regex = "^(kitty)$"
    },

    binds = {
        workspace_back_and_forth = true,
        allow_workspace_cycles = true,
        pass_mouse_when_bound = false,
    },

    general = {
        gaps_in = 4,
        gaps_out = 6,
        border_size = 2,
        col = {
            inactive_border = "0xff181825",
            active_border = "0xff1E1E2E"
        }
    },

    decoration = {
        rounding = 10,

        active_opacity = 1,
        inactive_opacity = 0.95,
        -- inactive_opacity = 1,
        fullscreen_opacity = 1,

        dim_inactive = false,

        blur = {
            enabled = true,
            size = 6,
            passes = 2,
            ignore_opacity = true,
            new_optimizations = true,
            special = true
        }
    },

    animations = {
        enabled = true,
        hl.curve("wind", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } }),
        hl.curve("winIn", { type = "bezier", points = { { 0.1, 1.1 }, { 0.1, 1.1 } } }),
        hl.curve("winOut", { type = "bezier", points = { { 0.3, -0.3 }, { 0, 1 } } }),
        hl.curve("liner", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } }),

        hl.animation({ leaf = "windows", enabled = true, speed = 6, bezier = "wind", style = "slide" }),
        hl.animation({ leaf = "windowsIn", enabled = true, speed = 6, bezier = "winIn", style = "slide" }),
        hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "winOut", style = "slide" }),
        hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, bezier = "wind", style = "slide" }),
        hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "liner" }),

        hl.animation({ leaf = "fade", enabled = true, speed = 1, bezier = "default" }),
        hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "wind", style = "slide" }),
    },
})



-- xwayland {
--     force_zero_scaling = true
-- }
