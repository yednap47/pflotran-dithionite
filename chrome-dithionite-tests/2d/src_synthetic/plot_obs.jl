import sachFun
import PyPlot
plt = PyPlot

fname = "src-obs-7.tec"
fname2 = "src_norxn-obs-7.tec"
myvar = ["Total CrO4-- [M] obs1", "Total Na+ [M] obs1"]

MW_Cr = 52.00

results = sachFun.readObsDataset(fname,myvar,dataframe=true)
results2 = sachFun.readObsDataset(fname2,myvar,dataframe=true)

fig, ax = plt.subplots(1,2,figsize=(10,7))

for i in 1:length(myvar)
    if contains(myvar[i],"CrO4--")
        ax[i][:plot](results[:Time],results[Symbol(myvar[i])]*MW_Cr*10^6)
        ax[i][:plot](results[:Time],results2[Symbol(myvar[i])]*MW_Cr*10^6,ls="--")
    else
        ax[i][:plot](results[:Time],results[Symbol(myvar[i])])
        ax[i][:plot](results[:Time],results2[Symbol(myvar[i])],ls="--")
    end
    ax[i][:set_title](myvar[i])
end

plt.tight_layout()
plt.savefig("breakthrough.png")
