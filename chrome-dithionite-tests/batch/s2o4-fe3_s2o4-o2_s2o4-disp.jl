import sachFun
import PyPlot
plt = PyPlot

myvar = [
"pH",
"Total H+ [M]",
"Total S2O4-- [M]",
"Total S2O3-- [M]",
"Total SO3-- [M]",
"Total SO4-- [M]",
"Total Fe+++ [M]",
"Total HCO3- [M]",
"Total O2(aq)",
"Fe(OH)3(s) VF",
"slow_Fe++ [mol/m^3]",
"fast_Fe++ [mol/m^3]",
]

timeunits = sachFun.readObsHeaders("s2o4-fe3_s2o4-o2_s2o4-disp-obs-0.tec")[1]
results = sachFun.readObsDataset("s2o4-fe3_s2o4-o2_s2o4-disp-obs-0.tec",myvar,dataframe=true)
fig,ax = plt.subplots(3,4,figsize=(15,10))
majorFormatter = plt.matplotlib[:ticker][:FormatStrFormatter]("%0.2e")

for i in 1:length(myvar)
    ax[i][:plot](results[:Time],results[Symbol(myvar[i])])
    ax[i][:set_ylabel](myvar[i])
    ax[i][:set_xlabel](timeunits)
    # ax[i][:yaxis][:set_major_formatter](majorFormatter)
end

plt.tight_layout()
plt.savefig("s2o4-fe3_s2o4-o2_s2o4-disp.png")
plt.close()

# Compare with simulation without disproportionation
myvar = [
"pH",
"Total S2O4-- [M]",
"Fe(OH)3(s) VF",
"slow_Fe++ [mol/m^3]",
"fast_Fe++ [mol/m^3]",
]

results = sachFun.readObsDataset("s2o4-fe3-obs-0.tec",myvar,dataframe=true)
fig2,ax2 = plt.subplots(2,3,figsize=(10,10))
for i in 1:length(myvar)
    ax2[i][:plot](results[:Time],results[Symbol(myvar[i])],color="red",linestyle="--")
end
ax2[2][:plot]([0,0],[0,0],color="red",linestyle="--",label="s2o4-fe3")

results = sachFun.readObsDataset("s2o4-fe3_s2o4-disp-obs-0.tec",myvar,dataframe=true)
for i in 1:length(myvar)
    ax2[i][:plot](results[:Time],results[Symbol(myvar[i])],color="blue",linestyle="--")
end
ax2[2][:plot]([0,0],[0,0],color="blue",linestyle="--",label="s2o4-fe3_s2o4-disp")

results = sachFun.readObsDataset("s2o4-fe3_s2o4-o2_s2o4-disp-obs-0.tec",myvar,dataframe=true)
for i in 1:length(myvar)
    ax2[i][:plot](results[:Time],results[Symbol(myvar[i])],color="green",linestyle="--")
    ax2[i][:set_ylabel](myvar[i])
    ax2[i][:set_xlabel](timeunits)
    if myvar[i] != "pH obs (1)"
        ax[i][:yaxis][:set_major_formatter](majorFormatter)
    end
end
ax2[2][:plot]([0,0],[0,0],color="green",linestyle="--",label="s2o4-fe3_s2o4-o2_s2o4-disp")
ax2[2][:legend](loc=0,fontsize=11)
plt.suptitle("Comparison of Fe(OH)3 reduction\nwith and without S2O4-- disproportionation")
plt.tight_layout(pad=1.0, w_pad=1.0, h_pad=1.0)
plt.subplots_adjust(top=0.92)
plt.savefig("s2o4-fe3_s2o4-o2_s2o4-disp_compare.png")
plt.close()
