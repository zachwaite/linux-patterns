#! /usr/bin/env bash

set -o errexit
set -o nounset

NVM_VERSION=0.39.3

lineInFile() {
  line="$1";
  file="$2";
  grep -qxF "$line" "$file" || echo "$line" >> "$file";
}

lineInBashrc() {
  line="$1";
  lineInFile "$1" ~/.bashrc;
}

declareFile() {
  callback=$1;
  path=$2;
  if [ -f "$path" ]; then
    eval $callback "$path";
  fi
}

declareDir() {
  callback=$1;
  path=$2;
  if [ -d "$path" ]; then
    eval $callback "$path";
  fi
}

systemUpdate() {
  sudo apt-get update
  sudo apt-get upgrade -y
}

declarePkgs() {
  sudo apt-get install "$@" -y
}


# ============== Main ==========================
systemUpdate
declarePkgs \
  libpq-dev \
  libldap2-dev \
  libsasl2-dev \
  libxml2-dev \
  libevent-dev \
  libxslt1-dev \
  libjpeg-dev \
  zlib1g-dev \
  libssl-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  libncurses5-dev \
  libffi-dev \
  liblzma-dev \
  git \
  unzip \
  make \
  build-essential \
  llvm \
  xz-utils \
  tk-dev \
  curl -y
systemUpdate
declareDir ~/.pyenv "curl https://pyenv.run | bash"
lineInBashrc 'export PYENV_ROOT="$HOME/.pyenv"';
lineInBashrc 'command -v pyenv > /dev/null || export PATH="$PYENV_ROOT/bin:$PATH"'
lineInBashrc 'eval "$(pyenv init -)"'
lineInBashrc "export PS1='($(pyenv version-name)) '\$PS1"
lineInBashrc 'set -o vi'
git clone https://github.com/alefpereira/pyenv-pyright.git /home/zach/.pyenv/plugins/pyenv-pyright
sudo apt-get remove vim vim-tiny -y
sudo apt-get install neovim -y
declareFile "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash" ~/.nvm/nvm.sh

