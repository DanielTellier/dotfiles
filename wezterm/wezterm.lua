local wezterm = require('wezterm')
local act = wezterm.action

return {
    -- General
    audible_bell = 'Disabled',
    check_for_updates = false,
    color_scheme = 'Monokai (base16)',
    default_cursor_style = 'SteadyBlock',
    disable_default_key_bindings = true,
    enable_scroll_bar = true,
    font = wezterm.font_with_fallback {'DejaVu Sans Mono', 'Courier New',},
    font_size = 13.0,
    hide_tab_bar_if_only_one_tab = true,
    scrollback_lines = 3500,
    window_close_confirmation = 'NeverPrompt',
    window_background_opacity = 1.0,

    -- Disable ligatures
    harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },

    -- Leader key
    --[[
    LEADER stays active until a keypress is registered (whether it matches
    a key binding or not), or until it has been active for the duration
    specified by timeout_milliseconds, at which point it will automatically
    cancel itself.
    --]]
    leader = { key="t", mods="CTRL", timeout_milliseconds=2000 },

    -- Key bindings
    keys = {
        -- Send "CTRL-t" to the terminal when pressing CTRL-t, CTRL-t
        {key = 't', mods="LEADER|CTRL", action=act.SendString('\x14')},
        {key = 'o', mods="LEADER",
            action=act{SplitVertical={domain="CurrentPaneDomain"}}},
        {key = 'v', mods="LEADER",
            action=act{SplitHorizontal={domain="CurrentPaneDomain"}}},
        {key = 't', mods="LEADER", action=act{SpawnTab="CurrentPaneDomain"}},
        {key = 'n', mods="LEADER", action=act.ActivateTabRelative(1)},
        {key = 'p', mods="LEADER", action=act.ActivateTabRelative(-1)},
        {key = 'q', mods="LEADER",
            action=act.CloseCurrentTab{confirm = false }},
        {key = 'h', mods="LEADER", action=act{ActivatePaneDirection="Left"}},
        {key = 'l', mods="LEADER", action=act{ActivatePaneDirection="Right"}},
        {key = 'k', mods="LEADER", action=act{ActivatePaneDirection="Up"}},
        {key = 'j', mods="LEADER", action=act{ActivatePaneDirection="Down"}},
        {key = 'w', mods="LEADER",
            action=act.CloseCurrentPane{confirm = false}},
        {key = 'z', mods="LEADER", action="TogglePaneZoomState"},
        {key = 'f', mods="LEADER", action="ToggleFullScreen"},
        {key = 'a', mods="LEADER", action="ActivateCopyMode"},
        {key = 'UpArrow', mods="CTRL", action=act.ScrollByPage(-0.5)},
        {key = 'DownArrow', mods="CTRL", action=act.ScrollByPage(0.5)},
        {key = 'c', mods="CTRL|SHIFT",
            action=act.CopyTo("ClipboardAndPrimarySelection")},
        {key = 'v', mods="CTRL|SHIFT", action=act.PasteFrom("Clipboard")},
        {key = 'v', mods="CTRL|SHIFT",
            action=act.PasteFrom("PrimarySelection")},
        {key = 'f', mods="CTRL|SHIFT",
            action=act.Search{CaseInSensitiveString=""}},
    },
}
