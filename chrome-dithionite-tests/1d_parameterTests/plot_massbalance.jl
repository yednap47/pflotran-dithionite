import sachFun
import PyPlot
plt = PyPlot

myvar = ["Global fast_Fe++", "Global slow_Fe++", "east A(aq) [mol]","east CrO4-- [mol]","east S2O4-- [mol]","east O2(aq) [mol]"]
filename = "1d-allReactions-10m-uniformVelocity-mas.dat"

results = sachFun.readObsDataset(filename,myvar,dataframe=true)

fig, ax = plt.subplots(2,3,figsize=(10,7))

for i in 1:length(myvar)
    ax[i][:plot](results[:Time],abs(results[Symbol(myvar[i])]))
    ax[i][:set_title](myvar[i])
end

plt.tight_layout()
