#!/bin/bash -xe
#SBATCH --nodes 8
#SBATCH --ntasks-per-node 2
#SBATCH --cpus-per-task 24
#SBATCH --job-name cpu8x2x24
#SBATCH --output=result-%x.%j.out
#SBATCH --error=result-%x.%j.err

# set relion path
export PATH=$PATH:/lustre/cryoem/relion-v31/build-cpu/bin

# CPU
COMPUTE_OPTIONS="--j ${SLURM_CPUS_PER_TASK} --cpu --pool 100 --dont_combine_weights_via_disc"
# GPU
#COMPUTE_OPTIONS="--j ${SLURM_CPUS_PER_TASK} --gpu --pool 30 --dont_combine_weights_via_disc"

# non-MPI
#RELION_REFINE="`which relion_refine`"
# MPI
RELION_REFINE="mpirun -np ${SLURM_NTASKS} `which relion_refine_mpi`"

##################################################################
RESULT_DIR="${SLURM_JOB_NAME}_${SLURM_JOB_ID}"
mkdir ${RESULT_DIR}

##################################################################
# Class2D
#RELION_OPTIONS="--i Particles/shiny_2sets.star --ctf --iter 25 --tau2_fudge 2 --particle_diameter 360 --K 200 --zero_mask --oversampling 1 --psi_step 6 --offset_range 5 --offset_step 2 --norm --scale --random_seed 0 --o ${RESULT_DIR}/run"
# Class3D
RELION_OPTIONS="--i Particles/shiny_2sets.star --ref emd_2660.map:mrc --firstiter_cc --ini_high 60 --ctf --ctf_corrected_ref --iter 25 --tau2_fudge 4 --particle_diameter 360 --K 6 --flatten_solvent --zero_mask --oversampling 1 --healpix_order 2 --offset_range 5 --offset_step 2 --sym C1 --norm --scale --random_seed 0 --o ${RESULT_DIR}/run"

module load intelmpi
time ${RELION_REFINE} ${RELION_OPTIONS} ${COMPUTE_OPTIONS}
