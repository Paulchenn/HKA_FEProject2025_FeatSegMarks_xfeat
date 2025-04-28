FROM ubuntu:22.04 AS base

# Set environment variables
ENV TZ=Europe/Berlin \
    TERM=xterm-256color

RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

##############################################################################
##                                  User                                    ##
##############################################################################
ARG USER=docker
ARG UID=1000
ARG GID=1000
ENV USER=${USER}

# Create user and group
RUN groupadd -o -g ${GID} ${USER} && \
    useradd -m -u ${UID} -g ${GID} -p "$(openssl passwd -1 ${PASSWORD})" --shell /bin/bash ${USER} -G sudo,video

# Run sudo without password
RUN mkdir -p /etc/sudoers.d && echo "%sudo ALL=(ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/sudogrp > /dev/null

##############################################################################
##                            Global Dependencies                           ##
##############################################################################
FROM base AS xfeatbase
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        nano \
        htop \
        git \
        sudo \
        wget \
        curl \
        gedit \
        python3-pip \
        ffmpeg \
        libsm6 \
        libxext6 \
        librsvg2-common \
        build-essential \
        gcc \
        g++ \
        cmake \
        ninja-build \
        python3-dev \
        libeigen3-dev \
    && rm -rf /var/lib/apt/lists/*

RUN python3 --version

# Install Python dependencies
RUN pip install torch torchvision --index-url https://download.pytorch.org/whl/cu118

# Install other dependencies
RUN pip install --no-cache-dir opencv-contrib-python tqdm matplotlib opencv-contrib-python-headless==4.10.0.84 kornia==0.7.2 gdown tensorboard h5py

RUN pip install --upgrade pip
RUN pip install git+https://github.com/PoseLib/PoseLib.git

FROM xfeatbase AS xfeatadvanced
# Install additional dependencies if needed

# RUN pip install --no-cache-dir <additional-dependencies>

##############################################################################
##                                 Torch directory                          ##
##############################################################################
FROM xfeatadvanced AS localfilestage
USER ${USER}
# Copy local data files
COPY ./data /home/${USER}/torch/data

# Copy local code files
COPY ./code /home/${USER}/torch/code

# Copy local log files
COPY ./logs /home/${USER}/torch/logs
WORKDIR /home/${USER}/torch/

CMD ["bash"]