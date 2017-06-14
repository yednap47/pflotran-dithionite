import sachFun
import PyPlot
plt = PyPlot
import DataFrames
df = DataFrames

myvar = [
"4-pH obs (1) (0.5 0.5 0.5)"                            
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
"18-Fe(OH)3(s) VF obs (1) (0.5 0.5 0.5)"                
"19-Cr(OH)3(s) VF obs (1) (0.5 0.5 0.5)"                
"20-Calcite VF obs (1) (0.5 0.5 0.5)"    
]

# results = sachFun.readObsDataset("calcite-obs-0.tec",myvar,dataframe=true)
results = sachFun.readObsDataset("calcite-obs-0.tec",myvar)
results2 = sachFun.readObsDataset("initial_calcite_simpleSpecies-obs-0.tec",myvar)
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
]

results3 = sachFun.readObsDataset("injectant_calcite_simpleSpecies-obs-0.tec",myvar)
results3df = df.DataFrame(name=myvar,conc=results3[end,2:end])

results4 = sachFun.readObsDataset("injectant_calcite_simpleSpecies_cleanWater-obs-0.tec",myvar)
results4df = df.DataFrame(name=myvar,conc=results4[end,2:end])

# results5 = sachFun.readObsDataset("injectant_calcite_simpleSpecies_cleanWater_check-obs-0.tec",myvar)
# results5df = df.DataFrame(name=myvar,conc=results5[end,2:end])
# results5df = df.DataFrame(name=myvar,conc=results4[end,2:end],ic=results5[end,2:end],error = results4[end,2:end]-results5[end,2:end])
