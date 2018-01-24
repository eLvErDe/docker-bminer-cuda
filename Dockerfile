FROM debian:stretch

MAINTAINER Adam Cecile <acecile@le-vert.net>

ENV TERM xterm
ENV HOSTNAME bminer-cuda.local
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /root

# Upgrade base system
RUN apt update \
    && apt -y -o 'Dpkg::Options::=--force-confdef' -o 'Dpkg::Options::=--force-confold' --no-install-recommends dist-upgrade \
    && rm -rf /var/lib/apt/lists/*

# Install dependencies
RUN apt update && apt -y -o 'Dpkg::Options::=--force-confdef' -o 'Dpkg::Options::=--force-confold' --no-install-recommends install wget ca-certificates xz-utils && rm -rf /var/lib/apt/lists/*

# Install binary
#
# https://bitcointalk.org/index.php?topic=2519271.0
# https://www.bminer.me/releases/
RUN mkdir /root/src \
    && wget "https://www.bminercontent.com/releases/bminer-v5.2.0-4f20af3-amd64.tar.xz" -O /root/src/miner.tar.xz \
    && tar xvf /root/src/miner.tar.xz -C /root/src/ \
    && find /root/src -name 'bminer' -exec cp {} /root/bminer \; \
    && chmod 0755 /root/ && chmod 0755 /root/bminer \
    && rm -rf /root/src/

# nvidia-container-runtime @ https://gitlab.com/nvidia/cuda/blob/ubuntu16.04/8.0/runtime/Dockerfile
ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
