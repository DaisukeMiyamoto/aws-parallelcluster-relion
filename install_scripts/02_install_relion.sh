#!/bin/bash -xe

TARGET=relion-v31
RELION_TAG=ver3.1
MPI_MODULE=intelmpi

##########################################################
git clone https://github.com/3dem/relion.git ${TARGET}
cd ${TARGET}
git checkout ${RELION_TAG}
module load ${MPI_MODULE}

# Build for G4dn (CUDA75)
BUILD_DIR=build-cuda75
mkdir ${BUILD_DIR}
cd ${BUILD_DIR}
cmake -DCUDA_ARCH=75 -DCUDA=ON -DCudaTexture=ON -DGUI=OFF -DCMAKE_BUILD_TYPE=Release ..
make
cd ..

# Build for P3 (CUDA70)
BUILD_DIR=build-cuda70
mkdir ${BUILD_DIR}
cd ${BUILD_DIR}
cmake -DCUDA_ARCH=70 -DCUDA=ON -DCudaTexture=ON -DGUI=OFF -DCMAKE_BUILD_TYPE=Release ..
make
cd ..

# Build for CPU (AVX512)
BUILD_DIR=build-cpu
mkdir ${BUILD_DIR}
cd ${BUILD_DIR}
CC=mpiicc CXX=mpiicpc cmake -DMKLFFT=ON -DCUDA=OFF -DALTCPU=ON -DCudaTexture=OFF\
  -DCMAKE_C_COMPILER=icc -DCMAKE_CXX_COMPILER=icpc -DMPI_C_COMPILER=mpiicc -DMPI_CXX_COMPILER=mpiicpc \
  -DCMAKE_C_FLAGS="-O3 -ip -g -xCOMMON-AVX512 -restrict " \
  -DCMAKE_CXX_FLAGS="-O3 -ip -g -xCOMMON-AVX512 -restrict " -DGUI=OFF -DCMAKE_BUILD_TYPE=Release ..
make
cd ..

echo "Relion Path:"
echo $(pwd)/bin
