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
            [Nn]* ) return 1;;
            * ) echo "Please answer y or n.";;
        esac
    done
}

# Function to check if libra-framework directory exists
check_libra_dir() {
    if [ -d "$HOME/libra-framework" ]; then
        return 0
    else
        return 1
    fi
}

# Start of the script
clear
display_ascii_art
echo "Welcome to the Libra Validator Installer for Ubuntu!"
echo

# Step 1: Update and install dependencies
if prompt_user "Would you like to update the system and install required dependencies?"; then
    echo "Running: sudo apt update && sudo apt install -y git tmux jq build-essential cmake clang llvm libgmp-dev pkg-config libssl-dev lld libpq-dev"
    sudo apt update && sudo apt install -y git tmux jq build-essential cmake clang llvm libgmp-dev pkg-config libssl-dev lld libpq-dev
    if [ $? -eq 0 ]; then
        echo "Dependencies installed successfully!"
    else
        echo "Failed to install dependencies. Skipping to next step..."
    fi
else
    echo "Skipping dependency installation..."
fi
echo

# Step 2: Install Rust
if prompt_user "Would you like to install Rust?"; then
    echo "Installing Rust using rustup..."
    curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain stable -y
    if [ $? -eq 0 ]; then
        echo "Rust installed successfully!"
    else
        echo "Failed to install Rust. Skipping to next step..."
    fi
    source "$HOME/.cargo/env" 2>/dev/null || echo "Warning: Could not source Rust environment."
else
    echo "Skipping Rust installation..."
fi
echo

# Step 3: Clone Libra Framework
if prompt_user "Would you like to clone the Libra Framework repository?"; then
    echo "Cloning Libra Framework..."
    cd ~
    rm -rf libra-framework 2>/dev/null  # Clean up any failed previous clones
    git clone https://github.com/0LNetworkCommunity/libra-framework
    if [ $? -eq 0 ] && check_libra_dir; then
        echo "Repository cloned successfully!"
    else
        echo "Failed to clone repository. Skipping to next step..."
    fi
else
    echo "Skipping repository cloning..."
fi
echo

# Step 4: Run dev_setup.sh
if prompt_user "Would you like to run the development setup script?"; then
    if check_libra_dir; then
        echo "Running dev_setup.sh..."
        cd ~/libra-framework
        bash ./util/dev_setup.sh -bt
        if [ $? -eq 0 ]; then
            echo "Development setup completed successfully!"
            source ~/.bashrc 2>/dev/null || echo "Warning: Could not source .bashrc."
        else
            echo "Failed to run dev_setup.sh. Skipping to next step..."
        fi
    else
        echo "Libra Framework directory not found. Skipping development setup..."
    fi
else
    echo "Skipping development setup..."
fi
echo

# Step 5: Build and initialize Libra
if prompt_user "Would you like to build and initialize the Libra Framework?"; then
    if check_libra_dir; then
        echo "Building Libra Framework..."
        cd ~/libra-framework
        cargo build --release -p libra -p diem-db-tool -p diem
        if [ $? -eq 0 ]; then
            echo "Build completed successfully!"
        else
            echo "Failed to build Libra Framework. Skipping to configuration steps..."
        fi

        if [ -f "./target/release/libra" ]; then
            echo "Checking Libra version..."
            ./target/release/libra version
            if [ $? -eq 0 ]; then
                echo "Libra version displayed successfully!"
            else
                echo "Failed to display Libra version. Continuing..."
            fi

            echo "Fixing Libra configuration URL..."
            ./target/release/libra config fix --force-url https://rpc.openlibra.space:8080/v1
            if [ $? -eq 0 ]; then
                echo "Configuration URL fixed successfully!"
            else
                echo "Failed to fix configuration URL. Continuing..."
            fi

            echo "Initializing Libra configuration..."
            ./target/release/libra config init
            if [ $? -eq 0 ]; then
                echo "Configuration initialized successfully!"
            else
                echo "Failed to initialize configuration. Continuing..."
            fi
        else
            echo "Libra binary not found. Skipping configuration steps..."
        fi
    else
        echo "Libra Framework directory not found. Skipping build and configuration..."
    fi
else
    echo "Skipping build and configuration..."
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
