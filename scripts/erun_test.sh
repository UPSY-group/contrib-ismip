#!/bin/bash
#SBATCH --job-name=test
#SBATCH --qos=nf
#SBATCH --ntasks=32
#SBATCH --mem=128G
#SBATCH --time=00:30:00
#SBATCH --output=test.%j.out
#SBATCH --error=test.%j.out

rm -r /scratch/nld8942/test

srun $HOME/projects/UPSY/LADDIE_program ../config/htest.cfg 
