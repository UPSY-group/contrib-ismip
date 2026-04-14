#!/bin/bash
#SBATCH --job-name=calib
#SBATCH --qos=nf
#SBATCH --ntasks=64
#SBATCH --mem=128G
#SBATCH --time=48:00:00
#SBATCH --output=calib.%j.out
#SBATCH --error=calib.%j.out

for P1 in 06 02 12 04 08 10; do
    for FORC in climatology Mathiot_NEMO_cold_v2 Mathiot_NEMO_warm_v2 Naughten_FESOM_ACCESS_cold Naughten_FESOM_ACCESS_warm ; do
	rm -rf /scratch/nld8942/calib/$FORC_$P1
	cp ../config/calib/tmpl3.cfg ../config/calib/config.cfg
	sed -i -e "s/FFFF/$FORC/g" ../config/calib/config.cfg
	sed -i -e "s/PPPP/$P1/g" ../config/calib/config.cfg 

        srun $HOME/projects/UPSY-models/LADDIE_program ../config/calib/config.cfg
    done
done
