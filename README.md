# xFeat Docker

This repo provides a docker running ubuntu 22.04 with all dependencies needed to use the xFeat keypoint detector using pytorch.

To use this container first run the `build.sh` script. This script will build the needed container and clone the needed source code for xFeat from github.

After building you can find all relevant code within the `code` directory. The data needed for training either needs to be moved into the datafolder, or if working with bigger datasets located on external storage devices mount the filepath to the external device into the container by changing the `LOCAL_DATA_PATH` variable within the `start_docker.sh` script.

