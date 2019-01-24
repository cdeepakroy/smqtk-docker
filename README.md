# smqtk-docker - Easy Docker deployment of SMQTK

This repository contains the code for building a docker container of the SMQTK CBIR web interface and run it against a folder of images

#### Building the docker image

Run `bash build_docker.sh`.


#### Running the docker image

Run `bash run_docker.sh <image-data-dir>`

`<image-data-dir>` must be the path to a directory containing the archive of images optionally organized into sub-folders named after their class/category.

The SMQTK IQR web interface will then allow you to select a query image from disk and retrieve similar images from this archive.

