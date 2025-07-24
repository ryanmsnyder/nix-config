{ user, ... }:

{
  # System activation scripts for macOS configuration
  
  # disable Spotlight's CMD-SPC hotkey so Raycast can use it (no restart needed for this to work)
  # add Downloads stack to Dock with grid view (there's a native system.defaults.dock.persistent-others option that allows
  # for setting paths but it doesn't seem to allow for setting the "displayas" parameter)
  system.activationScripts.text = ''
    defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 64 "
    <dict>
      <key>enabled</key><false/>
      <key>value</key><dict>
        <key>type</key><string>standard</string>
        <key>parameters</key>
        <array>
          <integer>32</integer>
          <integer>49</integer>
          <integer>1048576</integer>
        </array>
      </dict>
    </dict>
    "

    defaults write com.apple.dock persistent-others -array "
    <dict>
      <key>tile-data</key>
      <dict>
        <key>arrangement</key>
        <integer>1</integer>
        <key>displayas</key>
        <integer>1</integer>
        <key>file-data</key>
        <dict>
          <key>_CFURLString</key>
          <string>file:///Users/${user}/Downloads</string>
          <key>_CFURLStringType</key>
          <integer>15</integer>
        </dict>
        <key>file-type</key>
        <integer>2</integer>
        <key>showas</key>
        <integer>2</integer>
      </dict>
      <key>tile-type</key>
      <string>directory-tile</string>
    </dict>
    "
  '';

  system.activationScripts.activateSettings.text = ''
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    killall Dock
  '';
}
