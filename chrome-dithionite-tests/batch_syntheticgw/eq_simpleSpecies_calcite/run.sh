#!/bin/bash

$pfle_dithionite -pflotranin calcite.in
$pfle_dithionite -pflotranin initial_calcite_simpleSpecies.in
$pfle_dithionite -pflotranin injectant_calcite_simpleSpecies.in
$pfle_dithionite -pflotranin injectant_calcite_simpleSpecies_cleanWater.in
$pfle_dithionite -pflotranin injectant_calcite_simpleSpecies_cleanWater_check.in
