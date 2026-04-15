#!/bin/bash
#SBATCH --job-name=calib
#SBATCH --qos=nf
#SBATCH --ntasks=64
#SBATCH --mem=128G
#SBATCH --time=2:00:00
#SBATCH --output=calib.%j.out
#SBATCH --error=calib.%j.out

for P1 in 06 02 12 04 08 10; do
    for FORC in Dutrieux_2007 Dutrieux_2014; do
	rm -rf /scratch/nld8942/calib/$FORC_$P1
	cp ../config/calib/tmpl_pig.cfg ../config/calib/config.cfg
	sed -i -e "s/FFFF/$FORC/g" ../config/calib/config.cfg
	sed -i -e "s/PPPP/$P1/g" ../config/calib/config.cfg 

        srun $HOME/projects/UPSY-models/LADDIE_program ../config/calib/config.cfg
    done
done
