#!/usr/bin/env bash

set -e

if command -v jq >/dev/null 2>&1; then
  echo "jq is already installed: $(jq --version)"
  exit 0
fi

echo "jq not found. Installing..."

if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y jq

elif command -v dnf >/dev/null 2>&1; then
  sudo dnf install -y jq

elif command -v yum >/dev/null 2>&1; then
  sudo yum install -y jq

elif command -v pacman >/dev/null 2>&1; then
  sudo pacman -S --noconfirm jq

elif command -v apk >/dev/null 2>&1; then
  sudo apk add jq

elif command -v zypper >/dev/null 2>&1; then
  sudo zypper install -y jq

elif command -v brew >/dev/null 2>&1; then
  brew install jq

else
  echo "Could not find a supported package manager."
  echo "Please install jq manually: https://jqlang.github.io/jq/download/"
  exit 1
fi

echo "jq installed successfully: $(jq --version)"