#!/bin/bash

set -e  # Exit on any error

echo "Updating packages..."
sudo apt update && sudo apt upgrade -y

echo "Installing basic development tools..."
sudo apt install -y build-essential curl wget git

echo "Installing python dependencies..."
sudo apt install -y python3 python3-pip python3-venv


if ! command -v zsh &> /dev/null; then
    echo "Zsh is not installed. Installing Zsh..."
    sudo apt install -y zsh
    chsh -s $(which zsh)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
    echo "Zsh installed and set as default shell."
else
    echo "Zsh is already installed."
fi


if [ ! -d "$HOME/.nvm" ]; then
    echo "NVM is not installed. Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    nvm install --lts
    echo "NVM installed with LTS Node.js."
else
    echo "NVM is already installed."
fi

if ! command -v code &> /dev/null; then
    echo "Visual Studio Code is not installed. Installing VS Code..."
    sudo snap install --classic code
else
    echo "Visual Studio Code is already installed."
fi

if [ ! -d "$HOME/.pyenv" ]; then
	echo "Pyenv is not installed. Installing pyenv..."
	curl https://pyenv.run | bash
	
	echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
	echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
	echo 'eval "$(pyenv init - zsh)"' >> ~/.zshrc
	
    echo "Pyenv installed and configured."
else
    echo "Pyenv is already installed."
fi

if ! command -v poetry &> /dev/null; then
    echo "Poetry is not installed. Installing Poetry..."
    curl -sSL https://install.python-poetry.org | python3 -
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
    echo "Poetry installed."
else
    echo "Poetry is already installed."
fi

if ! command -v docker &> /dev/null; then
	sudo apt-get install -y ca-certificates curl
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc


	echo \
	  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
	  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
	  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt-get update
	
	sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	
	sudo usermod -aG docker $USER
	
	newgrp docker
else
    echo "Docker is already installed."
fi
