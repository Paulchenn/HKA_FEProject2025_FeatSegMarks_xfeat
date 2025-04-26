#!/bin/sh

# Autostart command to run inside the container, default is bash
# Usage1: Modify ./autostart.sh file and add custom command there
# Usage2: Run from cli with ./start_docker "custom command"
COMMAND=${1:-bash}
CONTAINER_NAME=xfeat_keypoint
CONTAINER_TAG=latest
LOCAL_DATA_PATH="/media/dominik/PG_1TB_01/xfeat_data"
LOCAL_CODE_PATH="$PWD/code"
LOCAL_LOG_PATH="$PWD/logs"

# Check if the container is already running
if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Container ${CONTAINER_NAME} is already running. Attaching to it..."
    docker exec -it ${CONTAINER_NAME} ${COMMAND}
    exit 0
fi

# Ensure XAUTHORITY is set
export XAUTHORITY=${XAUTHORITY:-$HOME/.Xauthority}

docker run \
    --name ${CONTAINER_NAME} \
    --privileged \
    -it \
    --net host \
    --rm \
    -e DISPLAY=${DISPLAY} \
    -e QT_X11_NO_MITSHM=1 \
    -e XAUTHORITY=${XAUTHORITY} \
    -v $XAUTHORITY:$XAUTHORITY:rw \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $LOCAL_DATA_PATH:/home/docker/torch/data:rw \
    -v $LOCAL_CODE_PATH:/home/docker/torch/code:rw \
    -v $LOCAL_LOG_PATH:/home/docker/torch/logs:rw \
    -v /dev:/dev  \
    ${CONTAINER_NAME}:${CONTAINER_TAG} \
    ${COMMAND}

    # --gpus all \ # Use this if you have a GPU

    # --env-file .env \
    # libEGL for Gazebo needs access to /dev/dri/renderD129
    # -v /dev:/dev \
    # -v /lib/modules:/lib/modules:ro \