# xFeat Docker Environment

This repo provides a docker running ubuntu 22.04 with all dependencies needed to use the xFeat keypoint detector using pytorch.

To use this container first run the `build.sh` script. This script will build the needed container and clone the needed source code for xFeat from github.

After building you can find all relevant code within the `code` directory. The data needed for training either needs to be moved into the datafolder, or if working with bigger datasets located on external storage devices mount the filepath to the external device into the container by changing the `LOCAL_DATA_PATH` variable within the `start_docker.sh` script.

Using the `start_docker.sh` script you can start the needed container.

If you need a second terminal working within the container, you can run
```bash
docker exec -it xfeat_keypoint bash
```
to connect to the running container. Or just rerun the `start_docker.sh` script within a second terminal.

Within the docker change your directory into the 'accelerated features' root folder. Then you can run:
```bash
python3 -m modules.training.train --training_type xfeat_default --megadepth_root_path /home/docker/torch/data/megadepth/ --synthetic_root_path /home/docker/torch/data/coco_20k/ --ckpt_save_path /home/docker/torch/logs/
```
within the module folder of xfeat to start the training.

## Code management using git
This repo itself contains the utilities needed to work with the xFeat network architecture within pytorch.
After building the container, you will find another repo within the code repository, which holds the source code for the xFeat network.

When contributing to either of these repositories make sure to create a fork of the corresponding repository and add this fork as a remote. Before commiting or pushing ensure that you are on the correct path to the wanted repository.

If you want to commit to the utils, ensure that you are on the same level as this README. If you want to commit to the xFeat source code, ensure that you are either within the `code/xfeat` folder or create a new repo inside of the `code` folder if your code is not directly part of the xFeat architecture.

