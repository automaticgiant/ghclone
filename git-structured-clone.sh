#!/bin/bash

# Git Structured Clone script
# Clones repositories into ~/git/<host>/<owner>/<repo>

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <git-url>"
    exit 1
fi

URL="$1"

# Remove protocol (https://, http://, git://)
CLEAN_URL=$(echo "$URL" | sed -E 's#^(https?|git)://##')

# Extract host, owner and repo
# Expecting format: host.com/owner/repo[.git]
HOST=$(echo "$CLEAN_URL" | cut -d'/' -f1)
REST=$(echo "$CLEAN_URL" | cut -d'/' -f2-)

if [ -z "$REST" ] || [ "$REST" == "" ]; then
    echo "Error: Invalid Git URL format. Expected host/owner/repo."
    exit 1
fi

# Extract owner and repo name from the remaining path
OWNER=$(echo "$REST" | cut -d'/' -f1)
REPO_RAW=$(echo "$REST" | cut -d'/' -f2)
# Remove .git extension if present
REPO=$(echo "$REPO_RAW" | sed 's/\.git$//')

if [ -z "$OWNER" ] || [ -z "$REPO" ]; then
    echo "Error: Could not extract owner or repository name from URL."
    exit 1
fi

TARGET_DIR="$HOME/git/$HOST/$OWNER/$REPO"

if [ -d "$TARGET_DIR" ]; then
    echo "Directory $TARGET_DIR already exists. Skipping clone."
    exit 0
fi

echo "Cloning into $TARGET_DIR..."
mkdir -p "$(dirname "$TARGET_DIR")"
git clone --depth 1 "$URL" "$TARGET_DIR"

# Start background unshallow process
echo "Initiating background unshallow for full history..."
nohup git -C "$TARGET_DIR" fetch --unshallow > /dev/null 2>&1 &

echo "Successfully cloned to $TARGET_DIR"
