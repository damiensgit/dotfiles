  #!/bin/sh
# Setup iTerm2 and Terminal
set -x

curl -L --create-dirs --output "Solarized Dark.itermcolors" https://github.com/altercation/solarized/raw/master/iterm2-colors-solarized/Solarized%20Dark.itermcolors
  # open "/tmp/Solarized Dark.itermcolors"

curl -L --create-dirs --output "Solarized Dark.terminal"  https://github.com/tomislav/osx-terminal.app-colors-solarized/raw/master/Solarized%20Dark.terminal
  # open "/tmp/Solarized Dark.terminal"


  # Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# Set Solarized
osascript <<EOD
tell application "Terminal"
    local allOpenedWindows
    local initialOpenedWindows
    local windowID
    set themeName to "Solarized Dark"
    (* Store the IDs of all the open terminal windows. *)
    set initialOpenedWindows to id of every window
    (* Open the custom theme so that it gets added to the list
       of available terminal themes (note: this will open two
       additional terminal windows). *)
    do shell script "open '" & themeName & ".terminal'"
    (* Wait a little bit to ensure that the custom theme is added. *)
    delay 1
    (* Set the custom theme as the default terminal theme. *)
    set default settings to settings set themeName
    (* Get the IDs of all the currently opened terminal windows. *)
    set allOpenedWindows to id of every window
    repeat with windowID in allOpenedWindows
        (* Close the additional windows that were opened in order
           to add the custom theme to the list of terminal themes. *)
        if initialOpenedWindows does not contain windowID then
            close (every window whose id is windowID)
        (* Change the theme for the initial opened terminal windows
           to remove the need to close them in order for the custom
           theme to be applied. *)
        else
            set current settings of tabs of (every window whose id is windowID) to settings set themeName
        end if
    end repeat
end tell
EOD

# Enable “focus follows mouse” for Terminal.app and all X11 apps
# i.e. hover over a window and start typing in it without clicking first
#defaults write com.apple.terminal FocusFollowsMouse -bool true
#defaults write org.x.X11 wm_ffm -bool true

# Install the Tango Dark theme for iTerm
open "Solarized Dark.itermcolors"

# Don’t display the annoying prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

# killall "Terminal" > /dev/null 2>&1
# killall "iTerm" > /dev/null 2>&1