# aws-parallelcluster-relion

set up example for Relion on AWS ParallelCluster

- AWS ParallelCluster 3.1.3
- Relion ver3.1

## Architecture Overview

![Architecture Overview](images/relion_architecture.png)

## set by step guide

### set up AWS ParallelCluster

On AWS CloudShell,

```
git clone https://github.com/DaisukeMiyamoto/aws-parallelcluster-relion
cd aws-parallelcluster-relion/01_setup_cluster
./create_relion_cluster.sh
source ~/.bashrc
```

Check cluster status with
```
pcluster describe-cluster --cluster-name ${PCLUSTER_CLUSTER_NAME}
```

If the `clusterStatus` become `CREATE_COMPLETE`, you could go to next step.


### Run Relion with GUI via NICE-DCV

Login ParallelCluster via NICE-DCV

```
pcluster dcv-connect --cluster-name ${PCLUSTER_CLUSTER_NAME} --key-path ~/.ssh/${SSH_KEY}
```



On GUI terminal, 

```
git clone https://github.com/DaisukeMiyamoto/aws-parallelcluster-relion
cd aws-parallelcluster-relion/02_relion_gui
./setup_relion_v31_gui.sh
source ~/.bashrc
```

- This figure show how relion job submission works with GUI and template files.
![How relion job works](images/how_relion_job_works.png)

:warning: **This compilation settings are not optimized. You need to customize for appropriate benchmarkings.**


#### Use public data for demonstration

- Download datasets
```
cd /shared
wget ftp://ftp.mrc-lmb.cam.ac.uk/pub/scheres/relion30_tutorial_precalculated_results.tar.gz
tar xvf relion30_tutorial_precalculated_results.tar.gz
cd relion30_tutorial_precalculated_results/
relion &
```


### benchmark Relion with compile optimization

TBU

### Clean up Environments

```
aws s3 rm s3://${BUCKET_NAME} --recursive
aws s3 rb s3://${BUCKET_NAME}
aws ec2 delete-key-pair --key-name ${SSH_KEY}
```
