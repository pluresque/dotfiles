{...}: {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
    local wezterm = require("wezterm")
    local act = wezterm.action
    local config = wezterm.config_builder()

    config.front_end = "WebGpu"
    config.keys = {
            {
                    key = "E",
                    mods = "CTRL|SHIFT",
                    action = act.PromptInputLine({
                            description = "Enter new name for tab",
                            action = wezterm.action_callback(function(window, pane, line)
                                    if line then
                                            window:active_tab():set_title(line)
                                    end
                            end),
                    }),
            },
            {
                    key = "K",
                    mods = "CTRL|SHIFT",
                    action = wezterm.action({ SendKey = { key = "K", mods = "CTRL|SHIFT" } }),
            },
            -- { key = 'l', mods = 'ALT', action = wezterm.action.ShowLauncher },
            {
                    key = "l",
                    mods = "ALT",
                    action = wezterm.action.ShowLauncherArgs({
                            flags = "FUZZY|LAUNCH_MENU_ITEMS|COMMANDS|TABS|WORKSPACES|KEY_ASSIGNMENTS",
                    }),
            },
            { key = "LeftArrow", mods = "SHIFT|ALT", action = act.MoveTabRelative(-1) },
            { key = "RightArrow", mods = "SHIFT|ALT", action = act.MoveTabRelative(1) },
            -- { key = "LeftArrow", mods = "ALT", action = wezterm.action({ ActivateTabRelative = -1 }) },
            -- { key = "RightArrow", mods = "ALT", action = wezterm.action({ ActivateTabRelative = 1 }) },
    }

    config.hyperlink_rules = {
            {
                    regex = "\\((\\w+://\\S+)\\)",
                    format = "$1",
                    highlight = 1,
            },
            {
                    regex = "\\[(\\w+://\\S+)\\]",
                    format = "$1",
                    highlight = 1,
            },
            {
                    regex = "\\{(\\w+://\\S+)\\}",
                    format = "$1",
                    highlight = 1,
            },
            {
                    regex = "<(\\w+://\\S+)>",
                    format = "$1",
                    highlight = 1,
            },
            {
                    regex = "[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)",
                    format = "$1",
                    highlight = 1,
            },
            {
                    regex = "\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b",
                    format = "mailto:$0",
            },
    }

    config.window_decorations = "RESIZE"


    config.hide_tab_bar_if_only_one_tab = true
    config.window_padding = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0,
    }

    config.color_scheme = "GruvboxDarkHard"
    config.font = wezterm.font("JetBrains Mono")
    config.font_size = 14.6
    config.adjust_window_size_when_changing_font_size = false

    return config
    '';
  };

}

