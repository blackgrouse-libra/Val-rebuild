#!/bin/bash

# Function to display ASCII art
display_ascii_art() {
    echo -e "\033[1;34m"
    cat << "EOF"
********  Welcome to Libra Validator Rebuild Setup  ********
           _     <-.(`-')    (`-')  (`-')  _ 
   <-.    (_)     __( OO) <-.(OO )  (OO ).-/ 
 ,--. )   ,-(`-')'-'---.\ ,------,) / ,---.  
 |  (`-') | ( OO)| .-. (/ |   /`. ' | \ /`.\ 
 |  |OO ) |  |  )| '-' `.)|  |_.' | '-'|_.' |
(|  '__ |(|  |_/ | /`'.  ||  .   .'(|  .-.  |
 |     |' |  |'->| '--'  /|  |\  \  |  | |  |
 `-----'  `--'   `------' `--' '--' `--' `--' 
************************************************************
Validator Installer
EOF
    echo -e "\033[0m"
}

# Function to prompt user for confirmation
prompt_user() {
    local prompt_message=$1
    while true; do
        read -p "$prompt_message (y/n): " choice
        case $choice in
            [Yy]* ) return 0;;
            [Nn]* ) echo "Exiting..."; exit 1;;
            * ) echo "Please answer y or n.";;
        esac
    done
}

# Start of the script
clear
display_ascii_art
echo "Welcome to the Libra Validator Installer for Ubuntu!"
echo

# Step 1: Update and install dependencies
prompt_user "Would you like to update the system and install required dependencies?"
echo "Running: sudo apt update && sudo apt install -y git tmux jq build-essential cmake clang llvm libgmp-dev pkg-config libssl-dev lld libpq-dev"
sudo apt update && sudo apt install -y git tmux jq build-essential cmake clang llvm libgmp-dev pkg-config libssl-dev lld libpq-dev
if [ $? -eq 0 ]; then
    echo "Dependencies installed successfully!"
else
    echo "Failed to install dependencies. Exiting..."
    exit 1
fi
echo

# Step 2: Install Rust
prompt_user "Would you like to install Rust?"
echo "Installing Rust using rustup..."
curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain stable -y
if [ $? -eq 0 ]; then
    echo "Rust installed successfully!"
else
    echo "Failed to install Rust. Exiting..."
    exit 1
fi
source "$HOME/.cargo/env"
echo

# Step 3: Clone Libra Framework
prompt_user "Would you like to clone the Libra Framework repository?"
echo "Cloning Libra Framework..."
cd ~
git clone https://github.com/0LNetworkCommunity/libra-framework
if [ $? -eq 0 ]; then
    echo "Repository cloned successfully!"
else
    echo "Failed to clone repository. Exiting..."
    exit 1
fi
echo

# Step 4: Build and initialize Libra
prompt_user "Would you like to build and initialize the Libra Framework?"
echo "Building Libra Framework..."
cd ~/libra-framework
cargo build --release -p libra -p diem-db-tool -p diem
if [ $? -eq 0 ]; then
    echo "Build completed successfully!"
else
    echo "Failed to build Libra Framework. Exiting..."
    exit 1
fi
echo "Initializing Libra configuration..."
libra config init
if [ $? -eq 0 ]; then
    echo "Configuration initialized successfully!"
else
    echo "Failed to initialize configuration. Exiting..."
    exit 1
fi
echo

# Congratulate the user
echo -e "\033[1;32m"
cat << "EOF"
Congratulations! 🎉
You have successfully installed the Libra Validator!
Happy validating!
EOF
echo -e "\033[0m"
