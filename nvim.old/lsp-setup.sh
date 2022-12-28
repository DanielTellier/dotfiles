#!/bin/bash

# Install Node Version Manager and Node Package Manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install node

# Install ls's with npm
npm i -g bash-language-server
npm i -g pyright # python ls
npm i -g vim-language-server
npm i -g yaml-language-server

pip3 install --upgrade --target "$HOME/.local/bin/" cmake-language-server

# Latex LS
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
cargo install texlab

if [[ $OSTYPE == 'darwin'* ]]; then
  brew install fzf
  brew install ripgrep

  # Lua LS
  curl -L \
  https://github.com/sumneko/lua-language-server/releases/download/3.5.3/lua-language-server-3.5.3-darwin-x64.tar.gz | \
  tar -zx -C $HOME/.local/bin bin/lua-language-server
  mv $HOME/.local/bin/bin/lua-language-server $HOME/.local/bin/
  rm -rf $HOME/.local/bin/bin/

  # Markdown LS
  curl -o $HOME/.local/bin/marksman -L \
  https://github.com/artempyanykh/marksman/releases/download/2022-08-07/marksman-macos
  chmod +x $HOME/.local/bin/marksman
elif [[ $OSTYPE == 'linux-gnu'* ]]; then
  sudo apt install fzf
  sudo apt install ripgrep

  # Lua LS
  curl -L \
  https://github.com/sumneko/lua-language-server/releases/download/3.5.3/lua-language-server-3.5.3-linux-x64.tar.gz | \
  tar -zx -C $HOME/.local/bin bin/lua-language-server
  mv $HOME/.local/bin/bin/lua-language-server $HOME/.local/bin/
  rm -rf $HOME/.local/bin/bin/

  # Markdown LS
  curl -o $HOME/.local/bin/marksman -L \
  https://github.com/artempyanykh/marksman/releases/download/2022-08-07/marksman-linux
  chmod +x $HOME/.local/bin/marksman
fi
