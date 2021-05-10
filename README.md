# aws-parallelcluster-relion

set up example for Relion on AWS ParallelCluster

- AWS ParallelCluster 2.10.3
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


### download benchmark set

## using AWS ParallelCluster with Relion GUI

- `RELION_QSUB_TEMPLATE`
- `RELION_QSUB_COMMAND`

## Benchmarking Class2D/Class3d

- modify PATH variable to 

```
sbatch -p g4dn-12x run_benchmark_g4dn-12x-mpi5.sh
```
