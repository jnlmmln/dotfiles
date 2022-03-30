#!/bin/sh
# Inspired by: https://github.com/akinsho/dotfiles/blob/main/install.sh

# Packages
packages=(
  "curl",
  "git",
  "gcc",
  "neovim",
  "pkg-config",
  "libssl-dev",
  "ibxcb-composite0-dev",
  "libx11-dev",
  "sqlite3",
  "libsqlite3-dev"
#  "lazygit"
)

exists() {
  type "$1" &> /dev/null;
}

install_missing_packages() {
  for p in "${packages[@]}"; do
    if hash "$p" 2>/dev/null; then
      echo "$p is installed"
    else
      echo "$p is not installed"
      # Detect the platform (similar to $OSTYPE)
      OS="`uname`"
      case $OS in
        'Linux')
          apt install "$1" || echo "$p failed to install"
          ;;
        'Darwin')
          brew install "$1" || echo "$p failed to install"
          ;;
        *) ;;
      esac
      echo "---------------------------------------------------------"
      echo "Done "
      echo "---------------------------------------------------------"
    fi
  done
}

# Might as well ask for password up-front, right?
echo "Starting install script, please grant me sudo access..."
sudo -v

# Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Add nvim ppa"
sudo apt install software-properties-common
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt update

echo "Install missing apt packages"
install_missing_packages || echo "failed to install missing packages"

echo "Set neovim as the default editor"
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
sudo update-alternatives --config vi
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --config vim
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
sudo update-alternatives --config editor

# https://www.rust-lang.org/learn/get-started
echo "Install rust:"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

if exists cargo; then
  cargo install topgrade
  cargo install ripgrep
  cargo install zoxide
  cargo install starship
  cargo install fnm
  cargo install nu --all-features
  cargo install vivid
  cargo install gitui
fi

echo "Install fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

echo "Set nu as default shell"
echo "Append to /etc/shells"
echo `which nu` |sudo tee -a /etc/shells

echo "Run chsh"
chsh -s $(which nu)

echo "TODOS:"
echo "\t- Nerdfont https://www.nerdfonts.com/"
echo "\t- GPU accelerated terminal emulator https://alacritty.org/"

echo "Setup dotfiles -------------------------------------------------"

sh -c "$(curl -fsLS chezmoi.io/get)" -- init --apply jnlmmln

echo "----------------------------------------------------------"

echo 'done'
echo "---------------------------------------------------------"
echo "All done!"
echo "Cheers"
echo "---------------------------------------------------------"

exit 0

