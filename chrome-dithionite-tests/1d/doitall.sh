#!/bin/bash

mpirun -np 8 /lclscratch/sach/Programs/pflotran-dithionite-git/src/pflotran/pflotran -pflotranin 1d-s2o4-fe3_s2o4-o2_s2o4-disp.in
mpirun -np 8 /lclscratch/sach/Programs/pflotran-dithionite-git/src/pflotran/pflotran -pflotranin 1d-fe2-o2_fe2-cr6.in
mpirun -np 8 /lclscratch/sach/Programs/pflotran-dithionite-git/src/pflotran/pflotran -pflotranin 1d-allReactions.in

julia 1d-fe2-o2_fe2-cr6.jl
julia 1d-s2o4-fe3_s2o4-o2_s2o4-disp.jl
julia 1d-allReactions.jl
