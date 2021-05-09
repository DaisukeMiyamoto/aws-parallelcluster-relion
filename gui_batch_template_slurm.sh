#!/bin/bash
#SBATCH --nodes=XXXmpinodesXXX
#--SBATCH --ntasks-per-node=XXXextra1XXX
#SBATCH --cpus-per-task=XXXthreadsXXX
#SBATCH --partition=XXXqueueXXX
#SBATCH --error=XXXerrfileXXX
#SBATCH --output=XXXoutfileXXX
#SBATCH --open-mode=append
##SBATCH XXXextra4XXX
##SBATCH XXXextra5XXX
##SBATCH XXXextra6XXX
##SBATCH --time=XXXextra1XXX
##SBATCH --mem-per-cpu=XXXextra2XXX
##SBATCH --gres=XXXextra3XXX

#export OMPI_MCA_btl_tcp_if_exclude="docker0,lo,virbr0"
time srun --mpi=pmix XXXcommandXXX
