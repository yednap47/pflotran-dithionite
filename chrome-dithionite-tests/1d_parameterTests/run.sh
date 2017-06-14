#!/bin/bash

mpirun -np 8 $pfle_dithionite -pflotranin 1d-allReactions-10m-checkpoint.in
mpirun -np 8 $pfle_dithionite -pflotranin 1d-allReactions-10m-fullspecies-checkpoint.in
mpirun -np 8 $pfle_dithionite -pflotranin 1d-allReactions-10m.in
mpirun -np 8 $pfle_dithionite -pflotranin 1d-allReactions-10m-fullspecies.in
mpirun -np 8 $pfle_dithionite -pflotranin 1d-allReactions-10m-uniformVelocity.in

julia plot.jl 1d-allReactions-10m
julia plot.jl 1d-allReactions-10m-fullspecies
julia plot.jl 1d-allReactions-10m-uniformVelocity
julia plot_breakthrough.jl
