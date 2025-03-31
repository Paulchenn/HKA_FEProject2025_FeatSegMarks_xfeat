FROM ubuntu:22.04

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
RUN groupadd -g ${GID} ${USER} && \
    useradd -m -u ${UID} -g ${GID} -p "$(openssl passwd -1 ${PASSWORD})" --shell /bin/bash ${USER} -G sudo,video

# Run sudo without password
RUN mkdir -p /etc/sudoers.d && echo "%sudo ALL=(ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/sudogrp > /dev/null

##############################################################################
##                            Global Dependencies                           ##
##############################################################################
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    nano htop git sudo wget curl gedit python3-pip \ 
    ffmpeg libsm6 libxext6 \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install torch torchvision --index-url https://download.pytorch.org/whl/cu118

RUN pip install --no-cache-dir opencv-contrib-python tqdm

##############################################################################
##                                 Torch directory                          ##
##############################################################################
USER ${USER}
# Copy local data files
COPY ./data /home/${USER}/torch/data

# Copy local code files
COPY ./code /home/${USER}/torch/code

# Copy local log files
COPY ./logs /home/${USER}/torch/logs
WORKDIR /home/${USER}/torch/

CMD ["bash"]
