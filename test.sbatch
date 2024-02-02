#!/bin/sh

#SBATCH --nodes=1                # Number of nodes requested
#SBATCH --time=60:00:00
#SBATCH --mail-user=r.g.stockey@soton.ac.uk
#SBATCH --mail-type=BEGIN,FAIL,END,TIME_LIMIT
#SBATCH --output=last.rscript.out


cd ~/
module purge
module load R/4.2.1

Rscript test.R

