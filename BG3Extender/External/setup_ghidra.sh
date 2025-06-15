#!/bin/bash

GHIDRA_URL="https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.3.2_build/ghidra_11.3.2_PUBLIC_20250415.zip"
TARGET_DIR="./External/Ghidra"

mkdir -p "$TARGET_DIR"
curl -L "$GHIDRA_URL" -o "$TARGET_DIR/Ghidra.zip"
unzip -q "$TARGET_DIR/Ghidra.zip" -d "$TARGET_DIR"
rm "$TARGET_DIR/Ghidra.zip"