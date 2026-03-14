# bin/setup.sh
log_info "symlinking bin scripts..."
mkdir -p "$HOME/.local/bin"


# symlink bin scripts
for script in "$DOTS/bin/scripts/"*; do
  chmod +x "$script"
  symlink "$script" "$HOME/.local/bin/$(basename "$script")"
done
