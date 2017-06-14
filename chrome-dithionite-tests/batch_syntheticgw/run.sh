#!/bin/bash

$pfle_dithionite -pflotranin initial_ph.in
$pfle_dithionite -pflotranin injectant_ph.in

julia cheminfo.jl initial_ph-obs-0.tec
julia cheminfo.jl injectant_ph-obs-0.tec

