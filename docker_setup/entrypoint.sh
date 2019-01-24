#!/usr/bin/env bash

# setup SMQTK environment variables
source ${build_path}/SMQTK/build/setup_env.build.sh

# generate image list file
find /opt/data -type f \( -iname "*.jpg" -or -iname "*.png" -or -iname "*.tif" \) > $build_path/image_list.txt
# find . -name '*' -exec file {} \; | grep -o -P '^.+: \w+ image' | cut -d':' -f1 > image_list.txt  # finds all types of image but is a bit slow

# load images into database and index them
smqtk_bin_dir=$build_path/SMQTK/python/smqtk/bin
python $smqtk_bin_dir/iqr_app_model_generation.py -t csift -c $build_path/system_config/config.IqrSearchApp.json --input_files $build_path/image_list.txt

# start mondod
mkdir -p $build_path/mongod_workspace
mongod --dbpath $build_path/mongod_workspace &

# start the web app
python $smqtk_bin_dir/runApplication.py -a IqrSearchDispatcher -c $build_path/system_config/config.IqrSearchApp.json

