FROM docker.repository.cloudera.com/cloudera/cdsw/ml-runtime-jupyterlab-python3.8-cuda:2022.04.1-b6


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

RUN git clone --depth 1 https://github.com/tensorflow/models
RUN cd models/research && \
    protoc object_detection/protos/*.proto --python_out=. && \
    cp object_detection/packages/tf2/setup.py . && \
    python -m pip install .

# Override Runtime label and environment variables metadata
ENV ML_RUNTIME_EDITION="CML_Bees_Example_Jupyter" \
 ML_RUNTIME_SHORT_VERSION="1.1" \
 ML_RUNTIME_MAINTENANCE_VERSION="1"
ENV ML_RUNTIME_FULL_VERSION="$ML_RUNTIME_SHORT_VERSION.$ML_RUNTIME_MAINTENANCE_VERSION" \
  ML_RUNTIME_DESCRIPTION="This runtime includes the tf object detection api"

LABEL com.cloudera.ml.runtime.edition=$ML_RUNTIME_EDITION \
com.cloudera.ml.runtime.full-version=$ML_RUNTIME_FULL_VERSION \
com.cloudera.ml.runtime.short-version=$ML_RUNTIME_SHORT_VERSION \
com.cloudera.ml.runtime.maintenance-version=$ML_RUNTIME_MAINTENANCE_VERSION \
com.cloudera.ml.runtime.description=$ML_RUNTIME_DESCRIPTION


ENV TF_CPP_MIN_LOG_LEVEL 3
