#!/bin/sh

CONTAINER_NAME=xfeat_keypoint
CONTAINER_TAG=latest

# Define the target directory and repository URL
TARGET_DIR="./code/accelerated_features"
REPO_URL="https://github.com/Odin-byte/accelerated_features.git"

# Check if the directory exists and is a Git repository
if [ -d "$TARGET_DIR/.git" ]; then
    echo "Repository already exists in $TARGET_DIR."
else
    echo "Cloning repository..."
    git clone "$REPO_URL" "$TARGET_DIR"
fi

# Check if the local data and logs directories exist, if not create them
if [ ! -d "./data" ]; then
    mkdir -p ./data
fi
if [ ! -d "./logs" ]; then
    mkdir -p ./logs
fi
docker build \
    --build-arg UID="$(id -u)" \
    --build-arg GID="$(id -g)" \
    -t ${CONTAINER_NAME}:${CONTAINER_TAG} \
    .

    # --no-cache \
    # --progress plain \
    # --build-arg CACHE_BUST="$(date +%s)" \