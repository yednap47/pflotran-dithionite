#!/bin/bash


cd $scratch/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/velocity/v1
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src_checkpoint.in
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src.in
cd $scratch/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/velocity/v2
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src_checkpoint.in
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src.in
cd $scratch/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/velocity/v3
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src_checkpoint.in
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src.in
cd $scratch/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/velocity/v4
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src_checkpoint.in
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src.in
cd $scratch/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/velocity/v5
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src_checkpoint.in
mpirun -np 16 /lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran -pflotranin src.in

