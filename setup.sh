#!/bin/bash
set -euo pipefail

# Auto-install Homebrew dependencies
if ! command -v brew &>/dev/null; then
  echo "Homebrew not found. Please install Homebrew first: https://brew.sh"
  exit 1
fi

echo "🏡 Installing Homebrew dependencies..."
brew bundle --file=Brewfile

# Create build directory and configure
echo "📦 Bootstrapping project via CMake"
cmake --preset bg3se-macos-debug

# Build the project
echo "🚧 Building"
cmake --build --preset bg3se-macos-debug --target clean

# Set up Ghidra
echo "Setting up Ghidra"
./SetupScripts/setup_ghidra.sh