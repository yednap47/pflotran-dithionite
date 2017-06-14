import sachFun
import PyPlot
plt = PyPlot

myvar = [
"pH obs (1)",
"Total H+ [M]",
"Total S2O4-- [M]",
"Total SO3-- [M]",
"Total Fe+++ [M]",
"Total HCO3- [M]",
"Fe(OH)3(s) VF",
"slow_Fe++ [mol/m^3]",
"fast_Fe++ [mol/m^3]",
]

timeunits = sachFun.readObsHeaders("s2o4-fe3-obs-0.tec")[1]
results = sachFun.readObsDataset("s2o4-fe3-obs-0.tec",myvar,dataframe=true)
fig,ax = plt.subplots(3,3,figsize=(15,10))
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
plt.savefig("s2o4-fe3.png")
plt.close()

# Check to see if the total moles of Fe_bound equals the moles of Fe(OH)3 lost
mv_feoh3 = 3.436e-5 # m^3/mole
feoh3_consumed = results[Symbol("Fe(OH)3(s) VF")][1]-results[Symbol("Fe(OH)3(s) VF")][end] # m^3/m^3_bulk
fe2_produced = results[Symbol("slow_Fe++ [mol/m^3]")][end]+results[Symbol("fast_Fe++ [mol/m^3]")][end]

println("$(feoh3_consumed/mv_feoh3) mol/m^3_bulk fe(III) dissolved, $fe2_produced mol/m^3_bulk fe(II) produced")
