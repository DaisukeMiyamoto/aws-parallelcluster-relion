#!/bin/bash -xue

BASE_DIR=/shared
TARGET=relion-v31
RELION_TAG=ver3.1
BUILD_DIR=relion-gui

cd ${BASE_DIR}
git clone https://github.com/3dem/relion.git ${TARGET}
cd ${TARGET}
git checkout ${RELION_TAG}

mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}
cmake ..
make -j 4

echo "export PATH=${PATH}:${BASE_DIR}/${TARGET}/${BUILD_DIR}/bin" |tee -a ~/.bashrc

