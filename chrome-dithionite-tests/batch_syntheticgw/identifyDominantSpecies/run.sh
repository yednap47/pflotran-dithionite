#!/bin/bash

$pfle_dithionite -pflotranin initial_ph7.in
$pfle_dithionite -pflotranin initial_ph9.in
$pfle_dithionite -pflotranin initial_ph11.in

julia cheminfo.jl
