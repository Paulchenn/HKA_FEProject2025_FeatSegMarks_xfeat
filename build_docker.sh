#!/bin/sh

CONTAINER_NAME=xfeat_keypoint
CONTAINER_TAG=latest

# Define the target directory and repository URL for the first repository (accelerated features)
TARGET_DIR_1="./code/accelerated_features"
REPO_URL_1="https://github.com/Paulchenn/HKA_FEProject2025_FeatSegMarks_acceFeatures.git"
BRANCH_NAME_1="main"

# Define the target directory and repository URL for the second repository (SDbOA)
TARGET_DIR_2="./code/SDbOA"
REPO_URL_2="https://github.com/Paulchenn/HKA_FEProjekt2025_FeatSegMarks_IccvEDbOA.git"
BRANCH_NAME_2="master"

# Check if the directory exists and is a Git repository (first repository)
if [ -d "$TARGET_DIR_1/.git" ]; then
    echo "Repository already exists in $TARGET_DIR_1."
else
    echo "Cloning repository..."
    git clone --recursive "$REPO_URL_1" -b "$BRANCH_NAME_1" "$TARGET_DIR_1"
fi

# Check if the directory exists and is a Git repository (second repository)
if [ -d "$TARGET_DIR_2/.git" ]; then
    echo "Repository already exists in $TARGET_DIR_2."
else
    echo "Cloning repository..."
    git clone --recursive "$REPO_URL_2" -b "$BRANCH_NAME_2" "$TARGET_DIR_2"
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