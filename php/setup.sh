#!/usr/bin/env bash
DEPS=(homebrew)

if is_macos; then
  log_info "tapping shivammathur/php..."
  brew tap shivammathur/php

  log_info "installing php..."
  brew install shivammathur/php/php

  log_info "installing composer..."
  brew install composer
fi


