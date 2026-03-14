#!/usr/bin/env bash

if is_macos; then

  # ── Power ─────────────────────────────────────────────────────────────────
  log_info "configuring power settings..."
  # set standby delay to 24 hours instead of default 1 hour — prevents mac from
  # sleeping too aggressively when on battery
  sudo pmset -a standbydelay 86400

  # ── Boot ──────────────────────────────────────────────────────────────────
  log_info "configuring boot..."
  # disable the startup chime — works on both Intel and Apple Silicon
  sudo nvram StartupMute=%01

  # ── General UI ────────────────────────────────────────────────────────────
  log_info "configuring general UI..."
  # set sidebar icon size to medium (1=small, 2=medium, 3=large)
  defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

  # speed up window resize animations for cocoa apps — near instant
  defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

  # expand the save dialog by default instead of showing the compact version
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode  -bool true
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

  # expand the print dialog by default instead of showing the compact version
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint  -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

  # disable auto-correct — essential when writing code or technical content
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

  # disable smart quotes — prevents " from becoming " which breaks code
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

  # disable smart dashes — prevents -- from becoming — which breaks code
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

  # disable automatic capitalization — annoying when typing commands or code
  defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

  # disable automatic period substitution (double space to period)
  defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

  # ── Language & locale ─────────────────────────────────────────────────────
  log_info "configuring language & locale..."
  # set preferred languages in order: english, arabic, turkish
  defaults write NSGlobalDomain AppleLanguages -array "en" "ar" "tr"

  # set locale to US english with USD currency
  defaults write NSGlobalDomain AppleLocale -string "en_US@currency=USD"

  # use centimeters for ruler and measurement displays
  defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"

  # enable metric units system-wide
  defaults write NSGlobalDomain AppleMetricUnits -bool true

  # ── Launch services ───────────────────────────────────────────────────────
  log_info "configuring launch services..."
  # disable gatekeeper quarantine prompt "are you sure you want to open this app?"
  defaults write com.apple.LaunchServices LSQuarantine -bool false

  # ── Printing ──────────────────────────────────────────────────────────────
  log_info "configuring printing..."
  # automatically quit the printer app once all print jobs have completed
  defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

  # ── Screenshots ───────────────────────────────────────────────────────────
  log_info "configuring screenshots..."
  # save screenshots as PNG — lossless and widely supported
  defaults write com.apple.screencapture type -string "png"

  # disable screenshot shadow — cleaner screenshots without drop shadow
  defaults write com.apple.screencapture disable-shadow -bool true

  # save screenshots to desktop by default
  defaults write com.apple.screencapture location -string "${HOME}/Desktop"

  # ── Screensaver ───────────────────────────────────────────────────────────
  log_info "configuring screensaver..."
  # require password immediately when screensaver starts or display sleeps
  defaults write com.apple.screensaver askForPassword -int 1

  # remove the grace period before password is required — enforce immediately
  defaults write com.apple.screensaver askForPasswordDelay -int 0

  # ── Finder ────────────────────────────────────────────────────────────────
  log_info "configuring finder..."
  # disable all finder window and get info animations — feels snappier
  defaults write com.apple.finder DisableAllAnimations -bool true

  # show the path bar at the bottom of finder windows
  defaults write com.apple.finder ShowPathbar -bool true

  # show the status bar at the bottom of finder windows
  defaults write com.apple.finder ShowStatusBar -bool true

  # show full POSIX path as finder window title
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

  # show hidden files by default
  defaults write com.apple.finder AppleShowAllFiles -bool true

  # show all file extensions in finder
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true

  # show external hard drives on the desktop
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true

  # show internal hard drives on the desktop
  defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true

  # show mounted network servers on the desktop
  defaults write com.apple.finder ShowMountedServersOnDesktop -bool true

  # show removable media (USB, SD cards) on the desktop
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

  # use list view in all finder windows by default
  # icnv=icon, Nlsv=list, clmv=column, Flwv=gallery
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

  # when performing a search, search the current folder by default
  defaults write com.apple.finder FXPreferredSearchScope -string "SCcf"

  # disable the warning dialog when changing a file extension
  defaults write com.apple.finder FFXEnableExtensionChangeWarning -bool false

  # disable the warning dialog before emptying the trash
  defaults write com.apple.finder WarnOnEmptyTrash -bool false

  # expand file info panes: General, Open With, and Sharing & Permissions
  defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General    -bool true \
    OpenWith   -bool true \
    Privileges -bool true

  # keep folders on top when sorting by name
  defaults write com.apple.finder _FXSortFoldersFirst -bool true

  # ── Desktop services ──────────────────────────────────────────────────────
  log_info "configuring desktop services..."
  # prevent .DS_Store files from being created on network volumes
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

  # prevent .DS_Store files from being created on USB volumes
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

  # ── Network ───────────────────────────────────────────────────────────────
  log_info "configuring network..."
  # enable AirDrop over ethernet and on older macs that don't support it by default
  defaults write com.apple.NetworkBrowser BrowserAllInterfaces -bool true

  # ── Dock ──────────────────────────────────────────────────────────────────
  log_info "configuring dock..."
  # disable the bounce animation when opening applications from the dock
  defaults write com.apple.dock launchanim -bool false

  # enable highlight hover effect for stack grid view in the dock
  defaults write com.apple.dock mouse-over-hilite-stack -bool true

  # minimize windows into their application icon instead of to the side of the dock
  defaults write com.apple.dock minimize-to-application -bool true

  # group windows by application in mission control
  defaults write com.apple.dock expose-group-by-app -bool true

  # remove the delay before the dock appears when auto-hide is enabled
  defaults write com.apple.dock autohide-delay -float 0

  # remove the animation when the dock appears or disappears
  defaults write com.apple.dock autohide-time-modifier -float 0

  # automatically hide and show the dock
  defaults write com.apple.dock autohide -bool true

  # show only open applications in the dock — no pinned apps clutter
  defaults write com.apple.dock static-only -bool true

  # set bottom-right hot corner to open launchpad (11=launchpad)
  defaults write com.apple.dock wvous-br-corner   -int 11
  defaults write com.apple.dock wvous-br-modifier -int 0

  # wipe all default app icons from the dock — start with a clean slate
  defaults write com.apple.dock persistent-apps -array

  # ── Mission control ───────────────────────────────────────────────────────
  log_info "configuring mission control..."
  # speed up mission control animations
  defaults write com.apple.dock expose-animation-duration -float 0.1

  # don't automatically rearrange spaces based on most recent use
  defaults write com.apple.dock mru-spaces -bool false

  # ── Terminal ──────────────────────────────────────────────────────────────
  log_info "configuring terminal..."
  # enable secure keyboard entry in terminal — prevents other apps from reading keystrokes
  defaults write com.apple.terminal SecureKeyboardEntry -bool true

  # ── Time machine ──────────────────────────────────────────────────────────
  log_info "configuring time machine..."
  # prevent time machine from prompting to use every new disk as a backup volume
  defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

  # ── Activity monitor ──────────────────────────────────────────────────────
  log_info "configuring activity monitor..."
  # show the main window when launching activity monitor
  defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

  # show CPU usage graph in the activity monitor dock icon
  defaults write com.apple.ActivityMonitor IconType -int 5

  # show all processes, not just the current user's processes
  defaults write com.apple.ActivityMonitor ShowCategory -int 0

  # sort activity monitor by CPU usage by default
  defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"

  # sort in descending order — highest CPU usage at the top
  defaults write com.apple.ActivityMonitor SortDirection -int 0

  # ── App store ─────────────────────────────────────────────────────────────
  log_info "configuring app store..."
  # enable automatic update checks
  defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

  # automatically download newly available updates in the background
  defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

  # automatically install critical system data files and security updates
  defaults write com.apple.Software CriticalUpdateInstall -int 1

  # automatically install app updates from the app store
  defaults write com.apple.Software AutoUpdate -bool true

  # ── Photos ────────────────────────────────────────────────────────────────
  log_info "configuring photos..."
  # prevent photos from launching automatically when iPhone or camera is plugged in
  defaults write com.apple.ImageCapture NdisableHotPlug -bool true

  # ── Chrome ────────────────────────────────────────────────────────────────
  log_info "configuring chrome..."
  # use the system print preview dialog instead of chrome's built-in one
  defaults write com.google.Chrome DisablePrintPreview -bool true

  # expand the print dialog by default in chrome
  defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true

  # ── Apply changes ─────────────────────────────────────────────────────────
  log_info "restarting affected apps..."
  for app in "Finder" "Dock" "SystemUIServer" "ActivityMonitor"; do
    killall "$app" &>/dev/null || true
  done

  log_ok "system defaults applied — some changes require a logout to take effect"
fi
