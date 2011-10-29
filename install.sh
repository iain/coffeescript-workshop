#!/bin/bash
set -e

echo "CoffeeScript installation package"

if [[ $(which apt-get) ]]; then
  echo "Installing required Ubuntu packages"
  sudo apt-get install -qq -y git-core build-essential curl
fi

if [[ $(which node) ]]; then
  echo "Node.js is installed"
else
  echo "Installing Node.js"
  rm -rf node
  git clone https://github.com/joyent/node.git
  cd node
  ./configure
  make
  sudo make install
fi

if [[ $(which npm) ]]; then
  echo "NPM is installed"
else
  echo "Installing NPM"
  curl http://npmjs.org/install.sh | clean=yes sh
fi

if [[ $(which coffee) ]]; then
  echo "CoffeeScript is installed"
else
  echo "Installing CoffeeScript"
  sudo npm install -g coffee-script
fi

if [[ $(which jasmine-node) ]]; then
  echo "Jasmine is installed"
else
  echo "Installing Jasmine"
  sudo npm install -g jasmine-node
fi

echo "All stuffs have been installed."
