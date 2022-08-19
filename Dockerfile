FROM docker.repository.cloudera.com/cloudera/cdsw/ml-runtime-workbench-python3.8-cuda:2022.04.1-b6

#tensorflow/tensorflow:2.9.0-gpu

ARG DEBIAN_FRONTEND=noninteractive

RUN rm /etc/apt/sources.list.d/cuda.list
# RUN rm /etc/apt/sources.list.d/nvidia-ml.list
RUN apt-key del 7fa2af80
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub
# Adding the above lines to workaround a recent issue introduced by NVIDIA https://github.com/NVIDIA/nvidia-docker/issues/1631

# Install apt dependencies
RUN apt-get update && apt-get install -y \
    git \
    gpg-agent \
    python3-cairocffi \
    protobuf-compiler \
    python3-pil \
    python3-lxml \
    python3-tk \
    libgl1-mesa-dev \
    wget

# Copy this version of of the model garden into the image
COPY models/research/object_detection /home/tensorflow/models/research/object_detection 

# Compile protobuf configs
RUN (cd /home/tensorflow/models/research/ && protoc object_detection/protos/*.proto --python_out=.)
WORKDIR /home/tensorflow/models/research/

RUN cp object_detection/packages/tf2/setup.py ./
ENV PATH="/home/tensorflow/.local/bin:${PATH}"
RUN python -m pip install -U pip
RUN python -m pip install .

ENV TF_CPP_MIN_LOG_LEVEL 3
