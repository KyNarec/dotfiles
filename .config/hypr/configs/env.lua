hl.env("CLUTTER_BACKEND", "wayland")
-- hl.env("GDK_BACKEND", { "wayland", "x11" })
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")

-- firefox
hl.env("MOZ_ENABLE_WAYLAND", "1")


-- electron >28 apps (may help)
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- NVIDIA
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")

-- nvidia firefox (for hardware acceleration on FF)?
-- check this post https://github.com/elFarto/nvidia-vaapi-driver#configuration
hl.env("MOZ_DISABLE_RDD_SANDBOX", "1")
hl.env("NVD_BACKEND", "direct")
hl.env("EGL_PLATFORM", "wayland")

-- Android Studio
hl.env("IDE_USE_WAYLAND", "1")
hl.env("_JAVA_AWT_WM_MONREPARENTING", "1")
