import sachFun
import PyPlot
plt = PyPlot

myvar = [
"pH obs (1)",
"Total H+ [M]",
"Total S2O4-- [M]",
"Total SO3-- [M]",
"Total SO4-- [M]",
"Total HCO3- [M]",
"Total O2(aq) [M]",
]

timeunits = sachFun.readObsHeaders("s2o4-o2-obs-0.tec")[1]
results = sachFun.readObsDataset("s2o4-o2-obs-0.tec",myvar,dataframe=true)
fig,ax = plt.subplots(2,4,figsize=(15,10))
majorFormatter = plt.matplotlib[:ticker][:FormatStrFormatter]("%0.2e")

for i in 1:length(myvar)
    ax[i][:plot](results[:Time],results[Symbol(myvar[i])])
    ax[i][:set_ylabel](myvar[i])
    ax[i][:set_xlabel](timeunits)
    if myvar[i] != "pH obs (1)"
        ax[i][:yaxis][:set_major_formatter](majorFormatter)
    end
    # ax[i][:set_ylim](0,maximum(results[Symbol(myvar[i])]))
end

plt.tight_layout()
plt.savefig("s2o4-o2.png")
plt.close()
