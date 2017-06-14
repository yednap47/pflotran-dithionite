import sachFun
import PyPlot
plt = PyPlot
import DataFrames
df = DataFrames

myvar = [
"4-pH obs (1) (0.5 0.5 0.5)"                            
"5-Total A(aq) [M] obs (1) (0.5 0.5 0.5)"               
"6-Total H+ [M] obs (1) (0.5 0.5 0.5)"                  
"7-Total O2(aq) [M] obs (1) (0.5 0.5 0.5)"              
"8-Total CrO4-- [M] obs (1) (0.5 0.5 0.5)"              
"9-Total S2O4-- [M] obs (1) (0.5 0.5 0.5)"              
"10-Total S2O3-- [M] obs (1) (0.5 0.5 0.5)"             
"11-Total SO3-- [M] obs (1) (0.5 0.5 0.5)"              
"12-Total SO4-- [M] obs (1) (0.5 0.5 0.5)"              
"13-Total Fe+++ [M] obs (1) (0.5 0.5 0.5)"              
"14-Total Cr+++ [M] obs (1) (0.5 0.5 0.5)"              
"15-Total HCO3- [M] obs (1) (0.5 0.5 0.5)"              
"16-Total Ca++ [M] obs (1) (0.5 0.5 0.5)"               
"17-Total K+ [M] obs (1) (0.5 0.5 0.5)"                 
"18-Total Br- [M] obs (1) (0.5 0.5 0.5)"                
"19-Total Cl- [M] obs (1) (0.5 0.5 0.5)"                
"20-Total Mg++ [M] obs (1) (0.5 0.5 0.5)"               
"21-Total Na+ [M] obs (1) (0.5 0.5 0.5)"                
"22-Total SiO2(aq) [M] obs (1) (0.5 0.5 0.5)"           
"23-Fe(OH)3(s) VF obs (1) (0.5 0.5 0.5)"                
"24-Cr(OH)3(s) VF obs (1) (0.5 0.5 0.5)"                
"25-Calcite VF obs (1) (0.5 0.5 0.5)"                   
]

results = sachFun.readObsDataset("calcite-obs-0.tec",myvar)
results2 = sachFun.readObsDataset("initial_calcite_fullSpecies-obs-0.tec",myvar)
results2df = df.DataFrame(name=myvar,conc=results[end,2:end],ic=results2[end,2:end],error = results[end,2:end]-results2[end,2:end])

myvar = [
"4-pH obs (1) (0.5 0.5 0.5)"                            
"5-Total A(aq) [M] obs (1) (0.5 0.5 0.5)"               
"6-Total H+ [M] obs (1) (0.5 0.5 0.5)"                  
"7-Total O2(aq) [M] obs (1) (0.5 0.5 0.5)"              
"8-Total CrO4-- [M] obs (1) (0.5 0.5 0.5)"              
"9-Total S2O4-- [M] obs (1) (0.5 0.5 0.5)"              
"10-Total S2O3-- [M] obs (1) (0.5 0.5 0.5)"             
"11-Total SO3-- [M] obs (1) (0.5 0.5 0.5)"              
"12-Total SO4-- [M] obs (1) (0.5 0.5 0.5)"              
"13-Total Fe+++ [M] obs (1) (0.5 0.5 0.5)"              
"14-Total Cr+++ [M] obs (1) (0.5 0.5 0.5)"              
"15-Total HCO3- [M] obs (1) (0.5 0.5 0.5)"              
"16-Total Ca++ [M] obs (1) (0.5 0.5 0.5)"               
"17-Total K+ [M] obs (1) (0.5 0.5 0.5)"                 
"18-Total Br- [M] obs (1) (0.5 0.5 0.5)"                
"19-Total Cl- [M] obs (1) (0.5 0.5 0.5)"                
"20-Total Mg++ [M] obs (1) (0.5 0.5 0.5)"               
"21-Total Na+ [M] obs (1) (0.5 0.5 0.5)"                
"22-Total SiO2(aq) [M] obs (1) (0.5 0.5 0.5)"           
]

results3 = sachFun.readObsDataset("injectant_calcite_fullSpecies-obs-0.tec",myvar)
results3df = df.DataFrame(name=myvar,conc=results3[end,2:end])
