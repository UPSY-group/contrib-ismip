#! /bin/sh -f

export Ncores=6

rm -rf ../results/ufespin

mpirun -n $Ncores ../../UPSY-models/UFEMISM_program ../config/ufespin.cfg
