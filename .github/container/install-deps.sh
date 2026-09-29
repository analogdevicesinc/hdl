#!/bin/bash

set -e

# core
zypper install -y --no-recommends \
    update-alternatives \
    which wget make openssl openssl-devel ca-certificates ca-certificates-mozilla

# utils
zypper install -y --no-recommends \
    git find tcl \
    python3 python3-devel \
    gcc13 gcc13-c++ \
    graphviz

# amd xilinx
zypper install -y --no-recommends \
    xorg-x11-server-Xvfb xlsclients \
