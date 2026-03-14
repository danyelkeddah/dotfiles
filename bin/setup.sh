# bin/setup.sh
log_info "symlinking bin scripts..."
mkdir -p "$HOME/.local/bin"

# symlink dot runner globally
chmod +x "$DOTS/dot.sh"
symlink "$DOTS/dot.sh" "$HOME/.local/bin/dot"

# symlink secrets runner globally
chmod +x "$DOTS/secrets.sh"
symlink "$DOTS/secrets.sh" "$HOME/.local/bin/secrets"

# symlink bin scripts
for script in "$DOTS/bin/scripts/"*; do
  chmod +x "$script"
  symlink "$script" "$HOME/.local/bin/$(basename "$script")"
done
