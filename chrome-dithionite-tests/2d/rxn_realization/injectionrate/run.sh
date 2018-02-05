#!/bin/bash


cd $scratch/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/injectionrate/s1
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src.in
cd $scratch/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/injectionrate/s2
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src.in
cd $scratch/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/injectionrate/s3
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src.in
cd $scratch/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/injectionrate/s4
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src.in
cd $scratch/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/injectionrate/s5
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src.in
cd $scratch/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/injectionrate/s6
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src.in
cd $scratch/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/injectionrate/s7
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src.in
cd $scratch/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/injectionrate/s8
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src.in
cd $scratch/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/injectionrate/s9
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src.in
cd $scratch/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/injectionrate/s10
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src.in
