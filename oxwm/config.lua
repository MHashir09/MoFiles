---@meta
-------------------------------------------------------------------------------
-- OXWM Configuration File
-------------------------------------------------------------------------------
-- Dynamic window manager configuration for OxWM
-- Reload with Mod+Shift+R (no compilation needed)
-------------------------------------------------------------------------------

---Load type definitions for LSP
---@module 'oxwm'

-------------------------------------------------------------------------------
-- VARIABLES
-------------------------------------------------------------------------------

-- Modifier keys
local modkey = "Mod4"   -- Super/Windows key
local modkey2 = "Mod1"  -- Alt key

-- Terminal emulator
local terminal = "kitty"

-- Color palette
local colors = {
    bg = "#000000",        -- AMOLED black (true black, pixels off)
    fg = "#ffffff",        -- Pure white

    grey = "#1a1a1a",      -- Very dark grey (inactive elements)
    light_grey = "#2a2a2a",-- Slightly lighter inactive tone
    silver = "#b0b0b0",    -- Muted highlight

    accent = "#ffffff",    -- Pure highlight (bright white)

    -- Monochrome mapping preserved
    red = "#2a2a2a",        -- muted dark grey for urgency
    cyan = "#b0b0b0",
    green = "#ffffff",
    lavender = "#2a2a2a",
    light_blue = "#b0b0b0",
    blue = "#b0b0b0",
    purple = "#ffffff",
}

-- Workspace tags
local tags = { "  一  ", "  二  ", "  三  ", "  四  ", "  五  " }

-- Status bar font
local bar_font = "Noto Sans CJK JP:style=Bold:size=10"

-------------------------------------------------------------------------------
-- STATUS BAR BLOCKS
-------------------------------------------------------------------------------

local blocks = {
    -- Separator
    oxwm.bar.block.static({
        text = "  │  ",
        interval = 999999999,
        color = colors.fg,
        underline = false,
    }),

    -- RAM usage
    oxwm.bar.block.ram({
        format = "メモリ  :    {used} / {total} GB",
        interval = 5,
        color = colors.fg,
        underline = false,
    }),

    -- Separator
    oxwm.bar.block.static({
        text = "  │  ",
        interval = 999999999,
        color = colors.fg,
        underline = false,
    }),

    -- Kernel version
    oxwm.bar.block.shell({
        format = "システム  :    {}",
        command = "echo 'Fedora Linux'", -- Change with your OS name ig
        interval = 999999999,
        color = colors.fg,
        underline = false,
    }),

    -- Separator
    oxwm.bar.block.static({
        text = "  │  ",
        interval = 999999999,
        color = colors.fg,
        underline = false,
    }),

    -- Battery status
    oxwm.bar.block.battery({
        format = "状態  :   {}%",
        charging = "充電中  :   {}%",
        discharging = "状態  :   {}%",
        full = "充電完了  :   {}%",
        interval = 30,
        color = colors.fg,
        underline = false,
    }),

    -- Separator
    oxwm.bar.block.static({
        text = "  │  ",
        interval = 999999999,
        color = colors.fg,
        underline = false,
    }),

    -- Date and time
    oxwm.bar.block.datetime({
        format = "日時  :   {}",
        date_format = "%m/%d（%a） %I:%M  ",
        interval = 1,
        color = colors.fg,
        underline = false,
    }),

}

-------------------------------------------------------------------------------
-- BASIC SETTINGS
-------------------------------------------------------------------------------

oxwm.set_terminal(terminal)
oxwm.set_modkey(modkey)
oxwm.set_tags(tags)

-------------------------------------------------------------------------------
-- LAYOUTS
-------------------------------------------------------------------------------

oxwm.set_layout_symbol("scrolling", " │     配置  :    [スクロール] ")
oxwm.set_layout_symbol("tiling",    " │     配置  :    [タイル] ")
oxwm.set_layout_symbol("normie",    " │     配置  :    [フローティング] ")
oxwm.set_layout_symbol("tabbed",    " │     配置  :    [タブ] ")
oxwm.set_layout_symbol("monocle",   " │     配置  :    [モノクル] ")
oxwm.set_layout_symbol("grid",      " │     配置  :    [グリッド] ")

-- Set default layout (scrolling by default)
oxwm.set_layout("scrolling")

-------------------------------------------------------------------------------
-- APPEARANCE
-------------------------------------------------------------------------------

-- Window borders
oxwm.border.set_width(1)
oxwm.border.set_focused_color(colors.fg)
oxwm.border.set_unfocused_color(colors.grey)

-- Gaps
oxwm.gaps.set_smart(false)  -- No gaps if only 1 window
oxwm.gaps.set_inner(1, 1)  -- Horizontal, Vertical
oxwm.gaps.set_outer(0, 0)  -- Horizontal, Vertical

-------------------------------------------------------------------------------
-- STATUS BAR
-------------------------------------------------------------------------------

oxwm.bar.set_font(bar_font)
oxwm.bar.set_blocks(blocks)
oxwm.bar.set_hide_vacant_tags(true)

-- Bar color schemes
oxwm.bar.set_scheme_normal(colors.fg, colors.bg, colors.bg)           -- Unoccupied tags
oxwm.bar.set_scheme_occupied(colors.silver, colors.bg, colors.bg)       -- Occupied tags
oxwm.bar.set_scheme_selected(colors.fg, colors.bg, colors.bg)     -- Selected tag
oxwm.bar.set_scheme_urgent(colors.fg, colors.bg, colors.bg)          -- Urgent tags

-------------------------------------------------------------------------------
-- WINDOW RULES
-------------------------------------------------------------------------------

-- Workspace: 0 { No Specific Workspace }
oxwm.rule.add({ class = "org.gnome.Nautilus", floating = true })

-- Workspace: 1 { Browser & WebApps }
oxwm.rule.add({ class = "Helium", tag = 1 })

-- Workspace: 2 { Terminal & Coding }
oxwm.rule.add({ class = "kitty", tag = 2 })

-- Workspace: 3 { Socials }
oxwm.rule.add({ class = "vesktop", tag = 3 })
oxwm.rule.add({ class = "Element", tag = 3 })
oxwm.rule.add({ class = "halloy", tag = 3 })

-- Workspace: 4 { Media }
oxwm.rule.add({ class = "mpv", tag = 4 })
oxwm.rule.add({ class = "spotify", tag = 4 })

-- Workspace: 5 { Steam }
oxwm.rule.add({ class = "steam", tag = 5 })

-------------------------------------------------------------------------------
-- KEYBINDINGS
-------------------------------------------------------------------------------

-- Applications
oxwm.key.bind({ modkey }, "Return", oxwm.spawn_terminal())
oxwm.key.bind({ modkey }, "B", oxwm.spawn("helium-browser"))
oxwm.key.bind({ modkey }, "E", oxwm.spawn("nautilus"))

-- Rofi Keybinds
oxwm.key.bind({ modkey, modkey2 }, "C", oxwm.spawn({ "sh", "-c", "~/.config/rofi/scripts/rofi-clipboard.sh" }))
oxwm.key.bind({ modkey, modkey2 }, "B", oxwm.spawn({ "sh", "-c", "~/.config/rofi/scripts/rofi-battery-power-menu.sh" }))
oxwm.key.bind({ modkey }, "Space", oxwm.spawn({ "sh", "-c", "rofi -show drun" }))
oxwm.key.bind({ modkey, "Control" }, "Space", oxwm.spawn({ "sh", "-c", "~/.config/rofi/scripts/rofi-wallpaper-selector.sh" }))

oxwm.key.bind({ modkey2 }, "P", oxwm.spawn({ "sh", "-c", "~/.config/rofi/scripts/rofi-powermenu.sh" }))
oxwm.key.bind({ modkey2 }, "W", oxwm.spawn({ "sh", "-c", "~/.config/rofi/scripts/webapp-manager.sh" }))
oxwm.key.bind({ modkey2 }, "V", oxwm.spawn({ "sh", "-c", "~/.config/rofi/scripts/rofi-volume-selector.sh" }))
oxwm.key.bind({ modkey2 }, "B", oxwm.spawn({ "sh", "-c", "~/.config/rofi/scripts/rofi-brightness-selector.sh" }))

-- Screenshot and Screenrecording
oxwm.key.bind({}, "Print", oxwm.spawn({ "sh", "-c", "~/.config/oxwm/Scripts/screen-shot.sh" }))
oxwm.key.bind({ modkey }, "R", oxwm.spawn({ "sh", "-c", "~/.config/oxwm/Scripts/screen-record.sh" }))

-- Volume controls
oxwm.key.bind({}, "XF86AudioRaiseVolume", oxwm.spawn({ "sh", "-c", "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+ && ~/.config/oxwm/Scripts/volume-notify.sh" }))
oxwm.key.bind({}, "XF86AudioLowerVolume", oxwm.spawn({ "sh", "-c", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && ~/.config/oxwm/Scripts/volume-notify.sh" }))
oxwm.key.bind({}, "XF86AudioMute", oxwm.spawn({ "sh", "-c", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && ~/.config/oxwm/Scripts/volume-notify.sh" }))

-- Media controls
oxwm.key.bind({}, "XF86AudioPlay", oxwm.spawn({ "playerctl", "play-pause" }))
oxwm.key.bind({}, "XF86AudioStop", oxwm.spawn({ "playerctl", "stop" }))
oxwm.key.bind({}, "XF86AudioPrev", oxwm.spawn({ "playerctl", "previous" }))
oxwm.key.bind({}, "XF86AudioNext", oxwm.spawn({ "playerctl", "next" }))

-- Brightness controls
oxwm.key.bind({}, "XF86MonBrightnessUp", oxwm.spawn({ "sh", "-c", "brightnessctl set 5%+ && ~/.config/oxwm/Scripts/brightness-notify.sh" }))
oxwm.key.bind({}, "XF86MonBrightnessDown", oxwm.spawn({ "sh", "-c", "brightnessctl set 5%- && ~/.config/oxwm/Scripts/brightness-notify.sh" }))

-- Window management
oxwm.key.bind({ modkey }, "Q", oxwm.client.kill())
oxwm.key.bind({ modkey }, "F", oxwm.client.toggle_fullscreen())

-- Layouts
oxwm.key.bind({ modkey }, "T", oxwm.layout.set("tiling"))
oxwm.key.bind({ modkey }, "S", oxwm.layout.set("scrolling"))
oxwm.key.bind({ modkey }, "N", oxwm.layout.cycle())

-- Master area
oxwm.key.bind({ modkey }, "H", oxwm.set_master_factor(-5))
oxwm.key.bind({ modkey }, "L", oxwm.set_master_factor(5))
oxwm.key.bind({ modkey }, "I", oxwm.inc_num_master(1))
oxwm.key.bind({ modkey }, "P", oxwm.inc_num_master(-1))

-- Gaps
oxwm.key.bind({ modkey }, "A", oxwm.toggle_gaps())

-- WM controls
oxwm.key.bind({ modkey, "Shift" }, "Q", oxwm.quit())
oxwm.key.bind({ modkey, "Shift" }, "R", oxwm.restart())
oxwm.key.bind({ modkey, "Shift" }, "Slash", oxwm.show_keybinds())

-- Focus movement
oxwm.key.bind({ modkey2 }, "H", oxwm.client.focus_stack(1))
oxwm.key.bind({ modkey2 }, "L", oxwm.client.focus_stack(-1))

-- Window movement
oxwm.key.bind({ modkey, "Shift" }, "J", oxwm.client.move_stack(1))
oxwm.key.bind({ modkey, "Shift" }, "K", oxwm.client.move_stack(-1))

-- Workspace switching
for i = 1, 5 do
    oxwm.key.bind({ modkey }, tostring(i), oxwm.tag.view(i - 1))
    oxwm.key.bind({ modkey, "Shift" }, tostring(i), oxwm.tag.move_to(i - 1))
    oxwm.key.bind({ modkey, "Control" }, tostring(i), oxwm.tag.toggleview(i - 1))
    oxwm.key.bind({ modkey, "Control", "Shift" }, tostring(i), oxwm.tag.toggletag(i - 1))
end

-------------------------------------------------------------------------------
-- AUTOSTART
-------------------------------------------------------------------------------

oxwm.autostart("picom")
oxwm.autostart("fcitx5")
oxwm.autostart("dbus-update-activation-environment --all")
oxwm.autostart("dunst")
oxwm.autostart("xset r rate 200 60")
oxwm.autostart("flameshot")
oxwm.autostart("~/.config/oxwm/Scripts/set-default-layout.sh")
oxwm.autostart("~/.config/oxwm/Scripts/set-wallpaper.sh")
