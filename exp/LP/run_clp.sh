#!/bin/bash
#SBATCH -a 1-43
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=16G
#SBATCH --time=4:00:00
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=mathieu.tanneau@polymtl.ca


# Absolute path to root directory
# Must be changed if used on another machine
LPBDIR="/home/mtanneau/projects/def-alodi/mtanneau/LPBenchmarks"

# Read list of instances
mapfile -t inst < $LPBDIR/exp/plato.txt

# Run Clp on each instance
julia --sysimage=$LPBDIR/JuliaLP.so --project=$LPBDIR $LPBDIR/src/LP/clp.jl $LPBDIR/dat/plato/${inst[${SLURM_ARRAY_TASK_ID}-1]} > $LPBDIR/logs/mittelman/clp/${inst[${SLURM_ARRAY_TASK_ID}-1]}.clp 2>&1