_window_index=$1
_tab_index=$2
osascript -- - "$_window_index" "$_tab_index" << EOF
on run argv
    set _window_index to item 1 of argv
    set _tab_index to item 2 of argv
    tell application "Brave"
        activate
        set index of window (_window_index as number) to (_window_index as number)
        set active tab index of window (_window_index as number) to (_tab_index as number)
    end tell
end run
EOF
