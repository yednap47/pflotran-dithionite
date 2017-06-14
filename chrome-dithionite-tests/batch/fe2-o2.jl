import sachFun
import PyPlot
plt = PyPlot

myvar = [
"pH obs (1)",
"Total H+ [M]",
"Total O2(aq) [M]",
"Total HCO3- [M]",
"Total Fe+++ [M]",
"slow_Fe++ [mol/m^3]",
"fast_Fe++ [mol/m^3]",
"Fe(OH)3(s) VF",
]

timeunits = sachFun.readObsHeaders("fe2-o2-obs-0.tec")[1]
results = sachFun.readObsDataset("fe2-o2-obs-0.tec",myvar,dataframe=true)
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
plt.savefig("fe2-o2.png")
plt.close()
