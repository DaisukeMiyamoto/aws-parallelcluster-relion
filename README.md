# aws-parallelcluster-relion

set up example for Relion on AWS ParallelCluster

- AWS ParallelCluster 3.1.3
- Relion ver3.1

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

```


### benchmark Relion with compile optimization


### Clean up Environments

```
aws s3 rm s3://${BUCKET_NAME} --recursive
aws s3 rb s3://${BUCKET_NAME}
aws ec2 delete-key-pair --key-name ${SSH_KEY}
```
