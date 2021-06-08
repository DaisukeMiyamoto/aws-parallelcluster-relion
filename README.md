# aws-parallelcluster-relion

set up example for Relion on AWS ParallelCluster

- AWS ParallelCluster 2.10.4
- Relion ver3.1

## set up environment

### set up AWS ParallelCluster

```
pcluster create -c pcluster.conf relion-cluster
```

```
pcluster ssh relion-cluster -i <KEY_NAME>
```

### build Relion for CPU and GPU

You could use `install_scripts/`.

- `01_install_requirements_ubuntu.sh`: Install requirements for Relion
- `02_install_relion.sh`: Build Relion for CPU and GPU settings
- `03_download_benchmarks.sh`: Download Benchmark data.


## using NVIDIA GPU Cloud Docker Image

- https://gitlab.com/NVHPC/ngc-examples/-/blob/master/relion/single-node/run_relion.sh
- https://ngc.nvidia.com/catalog/containers/hpc:relion

