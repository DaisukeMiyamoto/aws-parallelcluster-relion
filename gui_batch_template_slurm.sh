#!/bin/bash
#SBATCH --ntasks=XXXmpinodesXXX
#SBATCH --cpus-per-task=XXXthreadsXXX
#SBATCH --partition=XXXqueueXXX
#SBATCH --output=XXXoutfileXXX
#SBATCH --error=XXXerrfileXXX
#SBATCH --open-mode=append
#SBATCH --time=XXXextra1XXX
#SBATCH --mem-per-cpu=XXXextra2XXX
#SBATCH --gres=XXXextra3XXX
#SBATCH XXXextra4XXX
#SBATCH XXXextra5XXX
#SBATCH XXXextra6XXX

srun --mpi=pmix XXXcommandXXX
