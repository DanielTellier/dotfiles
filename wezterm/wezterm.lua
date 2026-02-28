local wezterm = require('wezterm')
local act = wezterm.action
local init = require('init')

local function os_capture(cmd, raw)
    local out = assert(io.popen(cmd, 'r'))
    local out_str = assert(out:read('*a'))
    out:close()
    if raw then return out_str end
    -- %s indicates a space
    out_str = string.gsub(out_str, '^%s+', '')
    out_str = string.gsub(out_str, '%s+$', '')
    out_str = string.gsub(out_str, '[\n\r]+', '')
    return out_str
end

wezterm.on('gui-startup', function(window, pane)
    init.startup({})
end)
-- wezterm.on('update-right-status', function(window, pane)
--     window:set_right_status(window:active_workspace())
-- end)

keys = {
    -- Send "CTRL-t" to the terminal when pressing CTRL-t, CTRL-t
    {key = 't', mods="LEADER|CTRL", action=act.SendString('\x14')},
    {key = 'o', mods="LEADER", action=act{SplitVertical={domain="CurrentPaneDomain"}}},
    {key = 'v', mods="LEADER", action=act{SplitHorizontal={domain="CurrentPaneDomain"}}},
    {key = 't', mods="LEADER", action=act{SpawnTab="CurrentPaneDomain"}},
    {key = 'n', mods="SHIFT|CTRL", action=act.SpawnWindow},
    {key = 'n', mods="LEADER", action=act.ActivateTabRelative(1)},
    {key = 'p', mods="LEADER", action=act.ActivateTabRelative(-1)},
    {key = 'q', mods="LEADER", action=act.CloseCurrentTab{confirm = false }},
    {key = 'h', mods="LEADER", action=act{ActivatePaneDirection="Left"}},
    {key = 'l', mods="LEADER", action=act{ActivatePaneDirection="Right"}},
    {key = 'k', mods="LEADER", action=act{ActivatePaneDirection="Up"}},
    {key = 'j', mods="LEADER", action=act{ActivatePaneDirection="Down"}},
    {key = 'w', mods="LEADER", action=act.CloseCurrentPane{confirm = false}},
    {key = 'z', mods="LEADER", action="TogglePaneZoomState"},
    {key = 'f', mods="LEADER", action="ToggleFullScreen"},
    {key = 'c', mods="LEADER", action="ActivateCopyMode"},
    {key = 'UpArrow', mods="CTRL", action=act.ScrollByPage(-0.5)},
    {key = 'DownArrow', mods="CTRL", action=act.ScrollByPage(0.5)},
    {key = 'f', mods="CTRL|SHIFT", action=act.Search{CaseInSensitiveString=""}},
    {key = 'r', mods="LEADER", action=act.RotatePanes("Clockwise")},
    {key = '0', mods="LEADER", action=act.PaneSelect{mode="SwapWithActive"}},
    {key = '1', mods="ALT", action=act.SwitchWorkspaceRelative(-1)},
    {key = '2', mods="ALT", action=act.SwitchWorkspaceRelative(1)},
    {key = '3', mods="ALT", action=act.ShowLauncherArgs{flags = 'FUZZY|WORKSPACES'}},
    {key = 'Escape', mods="LEADER", action=act.QuitApplication},
}

if os_capture("uname", false) == "Linux" then
    table.insert(
        keys, {key = 'c', mods="CTRL|SHIFT", action=act.CopyTo("ClipboardAndPrimarySelection")}
    )
    table.insert(
        keys, {key = 'v', mods="CTRL|SHIFT", action=act.PasteFrom("Clipboard")}
    )
else
    table.insert(
        keys, {key = 'c', mods="CMD", action=act.CopyTo("ClipboardAndPrimarySelection")}
    )
    table.insert(
        keys, {key = 'v', mods="CMD", action=act.PasteFrom("Clipboard")}
    )
end

return {
    -- General
    audible_bell = 'Disabled',
    check_for_updates = false,
    color_scheme = 'Monokai (base16)',
    default_cursor_style = 'SteadyBlock',
    disable_default_key_bindings = true,
    enable_scroll_bar = true,
    font = wezterm.font_with_fallback {
        'Fira Code', 'DejaVu Sans Mono', 'Courier New'
    },
    font_size = 13.0,
    hide_tab_bar_if_only_one_tab = true,
    inactive_pane_hsb = {
        saturation = 0.9,
        brightness = 0.75,
    },
    window_background_opacity = 1.0,
    text_background_opacity = 0.5,
    scrollback_lines = 3500,
    window_close_confirmation = 'NeverPrompt',
    enable_kitty_keyboard = true,
    enable_kitty_graphics = true,

    -- Disable ligatures
    harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },

    -- Ensure that the Alt key is sent as Meta
    send_composed_key_when_left_alt_is_pressed = false,
    send_composed_key_when_right_alt_is_pressed = false,
    -- Leader key
    --[[
    LEADER stays active until a keypress is registered (whether it matches
    a key binding or not), or until it has been active for the duration
    specified by timeout_milliseconds, at which point it will automatically
    cancel itself.
    --]]
    leader = { key="t", mods="CTRL", timeout_milliseconds=2000 },
    -- Key bindings
    keys = keys,
    unicode_version = 16,
}
