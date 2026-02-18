#! /bin/sh -f

export Ncores=6

rm -rf ../results/test

mpirun -n $Ncores ../../UPSY/main/LADDIE_program ../config/test.cfg
