#!/usr/bin/env bash
if [ $# -eq 0 ] || [ $# -gt 2 ]; then
  printf 'Usage: run_docker <data_dir>\n' >&2
  exit 1
fi

DATA_DIR=$(readlink -f $1)
echo ${DATA_DIR}

docker run --rm --runtime=nvidia -ti \
    -p 5000:5000 \
    --shm-size 32G \
    -v ${PWD}/system_config:/opt/build/system_config \
    -v ${DATA_DIR}:/opt/data mis_iqr_xai