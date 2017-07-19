import sachFun
using PyPlot
plt = PyPlot


timeunits = sachFun.readObsHeaders("s2o4-fe3_s2o4-o2_s2o4-disp-obs-0.tec")[1]
majorFormatter = plt.matplotlib[:ticker][:FormatStrFormatter]("%0.1e")

# Compare with simulation without disproportionation
myvar = [
"pH",
"Total O2(aq) [M]",
"Total S2O4-- [M]",
"Total S2O3-- [M]",
"Total SO3-- [M]",
"Total SO4-- [M]",
"Fe(OH)3(s) VF",
"slow_Fe++ [mol/m^3]",
"fast_Fe++ [mol/m^3]",
]

# FIRST PLOT
tempvar = [
"Total S2O4-- [M]",
"Total S2O3-- [M]",
"Total SO3-- [M]",
"Total SO4-- [M]",
]

coolnames = [
L"\mathrm{S_2O_4^{-2}}",
L"\mathrm{S_2O_3^{-2}}",
L"\mathrm{SO_3^{-2}}",
L"\mathrm{SO_4^{-2}}",
]

results = sachFun.readObsDataset("s2o4-fe3_s2o4-o2_s2o4-disp-obs-0.tec",myvar,dataframe=true)
fig,ax = plt.subplots(3,1,figsize=(4.5,7.5))

mycmap = plt.get_cmap("Paired",6)
linestyles = ["-","-.","--",":"]
linewidth = 1.5
mysize = 10


for i in 1:length(tempvar)
    ax[1][:plot](results[:Time],results[Symbol(tempvar[i])],color="k",lw=linewidth,linestyle=linestyles[i], label = coolnames[i])
end
ax[1][:set_ylabel](L"\mathrm{Concentration\, [M]}",fontsize=mysize)
ax[1][:legend](loc=0,frameon=false, fontsize=mysize-2)
ax[1][:set_xlabel]("Time [day]",fontsize=mysize)
ax[1][:tick_params](labelsize=mysize)
ax[1][:set_title]("(A)",fontsize=mysize)

# SECOND PLOT
tempvar = [
"Fe(OH)3(s) VF",
"slow_Fe++ [mol/m^3]",
"fast_Fe++ [mol/m^3]",
]

coolnames = [
L"\mathrm{Fe(OH)_3(s)}",
L"\mathrm{Fe(II)\, slow}",
L"\mathrm{Fe(II)\, fast}",
]

rho_bulk = 1200 # kg/m^3
mv_feoh3 = 34.36 # cm^3/mole
mw_feoh3 = 106.87 # g/mole

ax[2][:plot](results[:Time],results[Symbol(tempvar[1])]*100*(mw_feoh3/1000)/rho_bulk*100^3/mv_feoh3,color="k",lw=linewidth,linestyle=linestyles[1], label = coolnames[1])
ax2 = ax[2][:twinx]() # Create another axis on top of the current axis
ax2[:plot](results[:Time],results[Symbol(tempvar[2])]/(rho_bulk*1000),color="k",lw=linewidth,linestyles[2], label = coolnames[2])
ax2[:plot](results[:Time],results[Symbol(tempvar[3])]/(rho_bulk*1000),color="k",lw=linewidth,linestyles[3], label = coolnames[3])

ax[2][:set_ylabel](L"\mathrm{wt\%\, Fe(OH)_3(s)\, [g\,g_{sediment}^{-}]}",fontsize=mysize)
ax2[:set_ylabel](L"\mathrm{Fe(II)\, [mol\, g_{sediment}^{-}]}",fontsize=mysize)
ax2[:yaxis][:set_major_formatter](majorFormatter)
ax[2][:set_xlabel]("Time [day]",fontsize=mysize)
ax[2][:tick_params](labelsize=mysize)
ax2[:tick_params](labelsize=mysize)
ax[2][:set_title]("(B)",fontsize=mysize)


# sort both labels and handles by labels
 #labels, handles = zip(*sorted(zip(labels, handles), key=lambda t: t[0]))
handles, labels = ax[2][:get_legend_handles_labels]()
handles2, labels2 = ax2[:get_legend_handles_labels]()
append!(handles,handles2)
append!(labels,labels2)
ax2[:legend](handles,labels,loc=0, frameon=false, fontsize=mysize-2)

# THIRD PLOT
tempvar = [
"Total O2(aq) [M]",
]

coolnames = [
L"\mathrm{O_2(aq)}",
]

ax[3][:plot](results[:Time]*24,results[Symbol(tempvar[1])],color="k",lw=linewidth,linestyle=linestyles[1], label = coolnames[1])
ax[3][:legend](loc=0,frameon=false, fontsize=mysize-2)
ax[3][:set_xlim](0,0.1)
ax[3][:set_xlabel]("Time [hr]",fontsize=mysize)
ax[3][:yaxis][:set_major_formatter](majorFormatter)
ax[3][:set_ylabel](L"\mathrm{Concentration\, [M]}",fontsize=mysize)
ax[3][:tick_params](labelsize=mysize)
ax[3][:set_title]("(C)",fontsize=mysize)

plt.tight_layout()

savefig("batch_step1.png",dpi=100)
