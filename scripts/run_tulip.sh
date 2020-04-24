#!/bin/bash
#SBATCH -a 1-44
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=16G
#SBATCH --time=4:00:00
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=mathieu.tanneau@polymtl.ca


# Absolute path to root directory
# Must be changed if used on another machine
LPBDIR="/home/mtanneau/projects/def-alodi/mtanneau/LPBenchmarks"

# Read list of instances
mapfile -t inst < $LPBDIR/scripts/plato.txt

# Run Clp on each instance
julia --sysimage=$LPBDIR/JuliaLP.so --project=$LPBDIR $LPBDIR/src/tulip.jl $LPBDIR/dat/plato/${inst[${SLURM_ARRAY_TASK_ID}-1]} > $LPBDIR/logs/tulip/${inst[${SLURM_ARRAY_TASK_ID}-1]}.tlp 2>&1