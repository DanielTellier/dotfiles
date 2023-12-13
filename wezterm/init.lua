local wezterm = require('wezterm')
local mux = wezterm.mux
local init = {}


local function check_and_create_dir(dir)
    if os.execute('cd ' .. dir) ~= 0 then
        os.execute('mkdir ' .. dir)
    end
end


function init.startup(cmd)
    home = os.getenv('HOME')
    check_and_create_dir(home .. '/.local/share/planner')
    local tab_plan, pane, window = mux.spawn_window {
        workspace = 'current',
    }
    window:gui_window():maximize()
    pane:send_text('vi ~/.local/share/planner\n')
    local tab_new, pane, window = window:spawn_tab {}
    tab_new:activate()
end

return init
