#!/usr/bin/env bash
KANATA_VERSION="1.12.0"
KANATA_TAG="v${KANATA_VERSION}"
VHID_VERSION="6.2.0" # Required by kanata v1.12.0 (IPC protocol compatibility).
INSTALL_BIN="/usr/local/bin/kanata"

if ! is_macos; then
  log_warn "kanata setup currently supports macOS only — skipping"
  exit 0
fi

case "$(uname -m)" in
  arm64)  release_arch="arm64" ;;
  x86_64) release_arch="x64" ;;
  *)
    log_err "no official kanata $KANATA_TAG macOS binary exists for architecture: $(uname -m)"
    log_err "source builds are intentionally disabled; install kanata manually"
    exit 1
    ;;
esac

release_archive="macos-binaries-${release_arch}.zip"
release_url="https://github.com/jtroo/kanata/releases/download/${KANATA_TAG}"
temp_dir=""
installed_version="$(kanata --version 2>/dev/null | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -1 || true)"
if [ "$installed_version" = "$KANATA_VERSION" ]; then
  log_ok "kanata v$KANATA_VERSION already installed"
else
  temp_dir="$(mktemp -d)"
  trap '[ -z "$temp_dir" ] || rm -rf "$temp_dir"' EXIT
  log_info "downloading official kanata $KANATA_TAG binary for macOS $release_arch..."
  if ! curl -fL --retry 3 -o "$temp_dir/$release_archive" "$release_url/$release_archive"; then
    log_err "no official binary was found; source builds are intentionally disabled"
    exit 1
  fi
  curl -fL --retry 3 -o "$temp_dir/sha256sums" "$release_url/sha256sums"
  expected_sha="$(awk -v file="$release_archive" '$2 == file { print $1 }' "$temp_dir/sha256sums")"
  actual_sha="$(shasum -a 256 "$temp_dir/$release_archive" | awk '{ print $1 }')"
  if [ -z "$expected_sha" ] || [ "$actual_sha" != "$expected_sha" ]; then
    log_err "checksum verification failed for $release_archive"
    exit 1
  fi
  log_ok "verified $release_archive checksum"
  unzip -q "$temp_dir/$release_archive" -d "$temp_dir/kanata"
  sudo install -m 0755 "$temp_dir/kanata/kanata_macos_${release_arch}" "$INSTALL_BIN"
  log_ok "installed $INSTALL_BIN ($("$INSTALL_BIN" --version 2>/dev/null || true))"
fi

# Do not use the newest VHID blindly: kanata 1.12.0 explicitly requires 6.2.0.
receipt_version="$(pkgutil --pkg-info org.pqrs.Karabiner-DriverKit-VirtualHIDDevice 2>/dev/null | awk '/version:/ {print $2}' || true)"
if [ -n "$receipt_version" ] && [ "$receipt_version" != "$VHID_VERSION" ]; then
  log_err "Karabiner VirtualHIDDevice $receipt_version is installed, but kanata $KANATA_VERSION requires $VHID_VERSION"
  log_err "upgrade kanata and its driver together; refusing an incompatible install"
  exit 1
fi

if [ "$receipt_version" = "$VHID_VERSION" ] || [ -d /Applications/.Karabiner-VirtualHIDDevice-Manager.app ]; then
  log_ok "Karabiner VirtualHIDDevice is installed"
else
  if [ -z "$temp_dir" ]; then
    temp_dir="$(mktemp -d)"
    trap '[ -z "$temp_dir" ] || rm -rf "$temp_dir"' EXIT
  fi
  pkg="$temp_dir/Karabiner-DriverKit-VirtualHIDDevice-${VHID_VERSION}.pkg"
  log_info "downloading compatible Karabiner VirtualHIDDevice v$VHID_VERSION..."
  curl -fL --retry 3 -o "$pkg" "https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/download/v${VHID_VERSION}/Karabiner-DriverKit-VirtualHIDDevice-${VHID_VERSION}.pkg"
  log_info "installing VirtualHIDDevice (administrator password required)..."
  sudo installer -pkg "$pkg" -target /
  log_ok "VirtualHIDDevice v$VHID_VERSION installed"
fi

log_info "activating the Karabiner virtual HID system extension..."
sudo /Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager forceActivate || \
  log_warn "activation needs approval in System Settings"

log_info "installing config and LaunchDaemons..."
sudo mkdir -p /etc/kanata
sudo install -m 0644 "$DOTS/kanata/config/kanata.kbd" /etc/kanata/kanata.kbd
sudo install -m 0644 "$DOTS/kanata/config/dev.kanata.kanata.plist" /Library/LaunchDaemons/dev.kanata.kanata.plist
sudo chown root:wheel /Library/LaunchDaemons/dev.kanata.kanata.plist

# Karabiner-Elements manages this daemon itself; standalone VHID does not.
if [ ! -d /Applications/Karabiner-Elements.app ]; then
  vhid_plist="/Library/LaunchDaemons/org.pqrs.Karabiner-VirtualHIDDevice-Daemon.plist"
  sudo install -m 0644 "$DOTS/kanata/config/org.pqrs.Karabiner-VirtualHIDDevice-Daemon.plist" "$vhid_plist"
  sudo chown root:wheel "$vhid_plist"
  sudo launchctl bootout system/org.pqrs.Karabiner-VirtualHIDDevice-Daemon 2>/dev/null || true
  sudo launchctl bootstrap system "$vhid_plist" || log_warn "VHID daemon is waiting for system-extension approval"
fi

sudo launchctl bootout system/dev.kanata.kanata 2>/dev/null || true
sudo launchctl bootstrap system /Library/LaunchDaemons/dev.kanata.kanata.plist || \
  log_warn "kanata did not start yet; grant permissions first, then rerun this setup"

log_info "runtime logs: /var/log/kanata.log, /var/log/kanata.error.log, and /var/log/karabiner-vhid-daemon.log"

if systemextensionsctl list 2>/dev/null | grep -q 'org.pqrs.Karabiner-DriverKit-VirtualHIDDevice.*activated enabled'; then
  log_ok "Karabiner VirtualHIDDevice extension is enabled"
else
  log_warn "enable the VHID driver in System Settings > General > Login Items & Extensions > Driver Extensions"
  open "x-apple.systempreferences:com.apple.LoginItems-Settings.extension" 2>/dev/null || true
fi

# launchd may need a moment to get past kanata's startup delay.
sleep 3
if launchctl print system/dev.kanata.kanata 2>/dev/null | grep -q 'state = running'; then
  log_ok "kanata LaunchDaemon is running"
else
  log_warn "kanata is not running; macOS permissions may still be required"
  log_warn "add $INSTALL_BIN to Privacy & Security > Input Monitoring and Accessibility"
  "$INSTALL_BIN" --macos-request-permissions 2>/dev/null || true
  open "x-apple.systempreferences:com.apple.preference.security?Privacy_ListenEvent" 2>/dev/null || true
  log_info "after granting access, run: sudo launchctl kickstart -k system/dev.kanata.kanata"
  log_info "error details: tail -f /var/log/kanata.error.log"
fi

log_info "status: sudo launchctl print system/dev.kanata.kanata"
log_info "reload after config changes: sudo launchctl kickstart -k system/dev.kanata.kanata"
