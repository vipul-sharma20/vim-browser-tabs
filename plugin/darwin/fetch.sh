browser=$1
osascript << EOF
set _output to ""
tell application "$browser"
    set _window_index to 1
    repeat with w in windows
        set _tab_index to 1
        repeat with t in tabs of w
            set _title to get title of t
            set _url to get URL of t
            set _output to (_output & _window_index & "\t" & _tab_index & "\t" & _title & "\t" & _url & "\n")
            set _tab_index to _tab_index + 1
        end repeat
        set _window_index to _window_index + 1
        if _window_index > count windows then exit repeat
    end repeat
end tell
return _output
EOF
