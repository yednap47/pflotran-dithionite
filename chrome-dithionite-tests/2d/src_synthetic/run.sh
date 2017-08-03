#!/bin/bash

mpirun -np 16 $pfle_dithionite -pflotranin src_checkpoint.in
mpirun -np 16 $pfle_dithionite -pflotranin src.in
mpirun -np 16 $pfle_dithionite -pflotranin src_norxn.in
