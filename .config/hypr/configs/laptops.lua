local scripts = "~/.config/hypr/scripts/"

hl.bind("xf86KbdBrightnessDown", hl.dsp.exec_cmd(scripts .. "BrightnessKbd.sh --dec"))
hl.bind("xf86KbdBrightnessUp", hl.dsp.exec_cmd(scripts .. "BrightnessKbd.sh --inc"))
hl.bind("xf86TouchpadToggle", hl.dsp.exec_cmd(scripts .. "TouchPad.sh"))

-- this works on my laptop
hl.bind("xf86MonBrightnessDown", hl.dsp.exec_cmd(scripts .. "Brightness.sh --dec"))
hl.bind("xf86MonBrightnessUp", hl.dsp.exec_cmd(scripts .. "Brightness.sh --inc"))
