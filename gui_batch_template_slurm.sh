#!/bin/bash
#SBATCH --ntasks=XXXmpinodesXXX
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

export PATH=$PATH:/lustre/relion/build-gpu/bin/
time srun --mpi=pmix XXXcommandXXX
