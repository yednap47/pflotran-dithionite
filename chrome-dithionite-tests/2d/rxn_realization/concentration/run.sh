#!/bin/bash


cd $scratch/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/concentration/s1
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src.in
cd $scratch/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/concentration/s2
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src.in
cd $scratch/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/concentration/s3
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src.in
cd $scratch/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/concentration/s4
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src.in
cd $scratch/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/concentration/s5
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src.in
cd $scratch/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/concentration/s6
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src.in
cd $scratch/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/concentration/s7
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src.in
cd $scratch/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/concentration/s8
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src.in
cd $scratch/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/concentration/s9
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src.in
cd $scratch/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/concentration/s10
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src.in

