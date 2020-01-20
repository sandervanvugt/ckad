#!/usr/bin/env bash

# Ask for the administrator password upfront
echo "Asking for your sudo password upfront..."
sudo -v

# Keep-alive: update existing `sudo` time stamp until this has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install Xcode command-line tools and Homebrew:
xcode-select --install;
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
brew doctor

# Install Docker Desktop for Mac from Homebrew cask
brew update;
brew cask upgrade;
brew cask install docker;

# Install asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf;
cd ~/.asdf || return
git checkout "$(git describe --abbrev=0 --tags)";
export PATH="$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH"
eval ~/.asdf/asdf.sh
eval ~/.asdf/completions/asdf.bash

# Create our code directory
[[ -d ~/src ]] || mkdir ~/src

# Install kubectl...
asdf plugin-add kubectl;
asdf install kubectl 1.17.0;
asdf global kubectl 1.17.0;

# Install minikube...
asdf plugin-add minikube;
asdf install minikube 1.6.2;
asdf global minikube 1.6.2;
minikube stop;
minikube delete;
minikube config set vm-driver hyperkit;

# Next, quit Docker Desktop if it is running...
test -z "$(docker ps -q 2>/dev/null)" && osascript -e 'quit app "Docker"'

# Now start it again, and wait for it to be ready, then start minikube...
open --background -a Docker &&
  while ! docker system info > /dev/null 2>&1; do sleep 1; done &&
minikube start --vm-driver=hyperkit --memory 5120;

echo "Done. Now let's see what we have..."

kubectl get pods --all-namespaces
