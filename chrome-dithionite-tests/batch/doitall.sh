#!/bin/bash

/lclscratch/sach/Programs/pflotran-dithionite-git/src/pflotran/pflotran -pflotranin fe2-cr6.in
/lclscratch/sach/Programs/pflotran-dithionite-git/src/pflotran/pflotran -pflotranin fe2-o2.in
/lclscratch/sach/Programs/pflotran-dithionite-git/src/pflotran/pflotran -pflotranin s2o4-disp.in
/lclscratch/sach/Programs/pflotran-dithionite-git/src/pflotran/pflotran -pflotranin s2o4-fe3.in
/lclscratch/sach/Programs/pflotran-dithionite-git/src/pflotran/pflotran -pflotranin s2o4-fe3_s2o4-disp.in
/lclscratch/sach/Programs/pflotran-dithionite-git/src/pflotran/pflotran -pflotranin s2o4-fe3_s2o4-o2_s2o4-disp.in
/lclscratch/sach/Programs/pflotran-dithionite-git/src/pflotran/pflotran -pflotranin s2o4-o2.in

julia fe2-cr6.jl
julia fe2-o2.jl
julia s2o4-o2.jl
julia s2o4-fe3.jl
julia s2o4-disp.jl
julia s2o4-fe3_s2o4-disp.jl
julia s2o4-fe3_s2o4-o2_s2o4-disp.jl
