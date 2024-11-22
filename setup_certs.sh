#!/bin/bash

# Create certs directory
mkdir -p certs

# Detect OS and Architecture
OS="$(uname)"
ARCH="$(uname -m)"

if [ "$OS" == "Darwin" ]; then
    echo "Detected macOS"
    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bash_profile
        source ~/.bash_profile
    fi
    # Install mkcert and nss (for Firefox)
    brew install mkcert nss
elif [ "$OS" == "Linux" ]; then
    echo "Detected Linux"
    # Install certutil (part of libnss3-tools or nss-tools)
    if command -v apt-get &> /dev/null; then
        echo "Using apt-get package manager"
        sudo apt-get update
        sudo apt-get install libnss3-tools wget -y
    elif command -v yum &> /dev/null; then
        echo "Using yum package manager"
        sudo yum install nss-tools wget -y
    elif command -v dnf &> /dev/null; then
        echo "Using dnf package manager"
        sudo dnf install nss-tools wget -y
    else
        echo "Unsupported package manager. Please install libnss3-tools or nss-tools manually."
        exit 1
    fi
    # Download mkcert
    if ! command -v mkcert &> /dev/null; then
        echo "Downloading mkcert"
        if [ "$ARCH" == "x86_64" ]; then
            wget -O mkcert https://dl.filippo.io/mkcert/latest?for=linux/amd64
        elif [ "$ARCH" == "aarch64" ] || [ "$ARCH" == "arm64" ]; then
            wget -O mkcert https://dl.filippo.io/mkcert/latest?for=linux/arm64
        else
            echo "Unsupported architecture: $ARCH"
            exit 1
        fi
        chmod +x mkcert
        sudo mv mkcert /usr/local/bin/
    fi
else
    echo "Unsupported OS: $OS"
    exit 1
fi

# Install the local CA
mkcert -install

# Generate certificate and key, place them in certs folder
mkcert -cert-file certs/server.crt -key-file certs/server.key localhost 127.0.0.1 ::1

echo "Certificates have been generated in the 'certs' directory:"
ls -l certs/server.*
