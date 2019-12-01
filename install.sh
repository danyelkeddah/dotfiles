#!/bin/sh
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
echo "${red}red text ${green}green text${reset}"

echo "${green}Setting up your Mac..."

# Check for Homebrew and install if we don't have it
echo "${red}[SYSTEM] ${green}Checking if Homebrew is installed${reset}"
if test ! $(which brew); then
  echo "${red}[SYSTEM] ${green}Installing Homebrew...${reset}"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
echo "${red}[SYSTEM] ${green}Updating Homebrew...${reset}"
# Update Homebrew recipes
brew update

echo "${red}[SYSTEM] ${green}Installing Dependencies from Brewfile...${reset}"
# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle

echo "${red}[SYSTEM] ${green}Installing PHP Extensions with PECL...${reset}"
# Install PHP extensions with PECL
pecl install memcached imagick

echo "${red}[SYSTEM] ${green}Installing global Composer packages...${reset}"
# Install global Composer packages
/usr/local/bin/composer global require laravel/installer laravel/spark-installer laravel/valet

echo "${red}[SYSTEM] ${green}Installing Laravel Valet...${reset}"
# Install Laravel Valet
$HOME/.composer/vendor/bin/valet install

echo "${red}[SYSTEM] ${green}Creating directories...${reset}"
# Create a Sites directory
# This is a default directory for macOS user accounts but doesn't comes pre-installed
mkdir $HOME/Sites

echo "${red}[SYSTEM] ${green}Symlink .zshrc from the .dotfiles...${reset}"
# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

echo "${red}[SYSTEM] ${green}Symlink Mackup config file from the .dotfiles...${reset}"
# Symlink the Mackup config file to the home directory
ln -s $HOME/.dotfiles/.mackup.cfg $HOME/.mackup.cfg

echo "${red}[SYSTEM] ${green}Installing NPM global packages...${reset}"
./install/npm.sh

echo "${red}[SYSTEM] ${green}Setting MacOS Preferences...${reset}"
# Set macOS preferences
# We will run this last because this will reload the shell
source .macos