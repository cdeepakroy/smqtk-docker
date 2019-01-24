FROM nvidia/cuda:9.2-cudnn7-devel-ubuntu16.04
MAINTAINER Deepak Chittajallu <deepak.chittajallu@kitware.com>

# Install system prerequisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    git \
    ca-certificates \
    wget \
    curl \
    make \
    cmake && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4 && \
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.0.list && \
    apt-get update && \
    apt-get install -y mongodb-org && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install miniconda
ENV build_path=/opt/build
RUN mkdir -p $build_path && \
    wget --quiet --no-check-certificate https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    -O $build_path/install_miniconda.sh && \
    bash $build_path/install_miniconda.sh -b -p $build_path/miniconda && \
    rm $build_path/install_miniconda.sh && \
    chmod -R +r $build_path && \
    chmod +x $build_path/miniconda/bin/python
ENV PATH=$build_path/miniconda/bin:${PATH}
WORKDIR $build_path

# Copy setup files from current folder
RUN mkdir -p $build_path/docker_setup
COPY ./docker_setup $build_path/docker_setup

# setup conda environment
RUN conda env create --name smqtk --file $build_path/docker_setup/smqtk_xai.yml && \
    conda clean --yes --all && \
    echo "source activate smqtk" > ~/.bashrc
ENV PATH=$build_path/miniconda/envs/smqtk/bin:${PATH}

# git clone smqtk and build it
RUN cd $build_path && \
    # git clone --depth 1 https://github.com/dongshuhao/SMQTK.git --branch dev/XAI-master && \
    git clone --depth 1 https://github.com/cdeepakroy/SMQTK.git --branch dev/XAI-MIS-master && \
    # git clone --depth 1 https://github.com/cdeepakroy/SMQTK.git --branch svm_saliency && \
    cd SMQTK && mkdir -p build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DSMQTK_BUILD_FLANN=OFF ../ && make && \
    /bin/bash -c "source ${build_path}/SMQTK/build/setup_env.build.sh" && \
    cd ../ && python setup.py install

# call entrypoint script
ENTRYPOINT /bin/bash $build_path/docker_setup/entrypoint.sh