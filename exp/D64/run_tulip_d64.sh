#!/bin/bash
#SBATCH -a 1-6
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=16G
#SBATCH --time=1:00:00
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=mathieu.tanneau@polymtl.ca


# Absolute path to root directory
# Must be changed if used on another machine
LPBDIR="/home/mtanneau/projects/def-alodi/mtanneau/LPBenchmarks"

# Read list of instances
mapfile -t inst < $LPBDIR/exp/D64/failures.txt

# Run Tulip on each instance
julia --sysimage=$LPBDIR/JuliaLP.so --project=$LPBDIR $LPBDIR/src/D64/tulip.jl $LPBDIR/dat/plato/${inst[${SLURM_ARRAY_TASK_ID}-1]} 1e-8 > $LPBDIR/logs/double64/${inst[${SLURM_ARRAY_TASK_ID}-1]}.d64.tlp 2>&1