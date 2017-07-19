import sachFun
using PyPlot
plt = PyPlot


timeunits = sachFun.readObsHeaders("fe2-o2_fe2-cr6-obs-0.tec")[1]
majorFormatter = plt.matplotlib[:ticker][:FormatStrFormatter]("%0.1e")

# Compare with simulation without disproportionation
myvar = [
"pH",
"Total O2(aq) [M]",
"Total CrO4-- [M]",
"Fe(OH)3(s) VF",
"Cr(OH)3(s) VF",
"slow_Fe++ [mol/m^3]",
"fast_Fe++ [mol/m^3]",
]

results = sachFun.readObsDataset("fe2-o2_fe2-cr6-obs-0.tec",myvar,dataframe=true)


# FIRST PLOT
tempvar = [
"Total O2(aq) [M]",
"Total CrO4-- [M]",
]

coolnames = [
L"\mathrm{O_2(aq)}",
L"\mathrm{CrO_4^{-2}}",
]

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
ax[1][:set_xlim](0,1)
ax[1][:tick_params](labelsize=mysize)
ax[1][:set_title]("(A)",fontsize=mysize)
ax[1][:yaxis][:set_major_formatter](majorFormatter)

#
# SECOND PLOT
tempvar = [
"Fe(OH)3(s) VF",
"Cr(OH)3(s) VF",
]

coolnames = [
L"\mathrm{Fe(OH)_3(s)}",
L"\mathrm{Cr(OH)_3(s)}",
]

rho_bulk = 1200 # kg/m^3
mv_feoh3 = 34.36 # cm^3/mole
mw_feoh3 = 106.87 # g/mole
mv_croh3 = 33.1 # cm^3/mole
mw_croh3 = 103.0181 # g/mole


ax[2][:plot](results[:Time],results[Symbol(tempvar[1])]*100*(mw_feoh3/1000)/rho_bulk*100^3/mv_feoh3,color="k",lw=linewidth,linestyle=linestyles[1], label = coolnames[1])
ax[2][:plot](results[:Time],results[Symbol(tempvar[2])]*100*(mw_croh3/1000)/rho_bulk*100^3/mv_croh3,color="k",lw=linewidth,linestyle=linestyles[2], label = coolnames[2])
ax[2][:set_xlim](0,1)
ax[2][:yaxis][:set_major_formatter](majorFormatter)
ax[2][:set_xlabel]("Time [day]",fontsize=mysize)
ax[2][:tick_params](labelsize=mysize)
ax[2][:set_title]("(B)",fontsize=mysize)
ax[2][:legend](loc=0,frameon=false, fontsize=mysize-2)

# ax2 = ax[2][:twinx]() # Create another axis on top of the current axis
# ax2[:plot](results[:Time],results[Symbol(tempvar[2])]/(rho_bulk*1000),color="k",lw=linewidth,linestyles[2], label = coolnames[2])
# ax2[:plot](results[:Time],results[Symbol(tempvar[3])]/(rho_bulk*1000),color="k",lw=linewidth,linestyles[3], label = coolnames[3])
#
ax[2][:set_ylabel](L"\mathrm{wt\%\, [g\,g_{sediment}^{-}]}",fontsize=mysize)
# ax2[:set_ylabel](L"\mathrm{Fe(II)\, [mol\, g_{sediment}^{-}]}",fontsize=mysize)
# ax2[:yaxis][:set_major_formatter](majorFormatter)
#
#
# # sort both labels and handles by labels
#  #labels, handles = zip(*sorted(zip(labels, handles), key=lambda t: t[0]))
# handles, labels = ax[2][:get_legend_handles_labels]()
# handles2, labels2 = ax2[:get_legend_handles_labels]()
# append!(handles,handles2)
# append!(labels,labels2)
# ax2[:legend](handles,labels,loc=0, frameon=false, fontsize=mysize-2)
#
# THIRD PLOT
# SECOND PLOT
tempvar = [
"slow_Fe++ [mol/m^3]",
"fast_Fe++ [mol/m^3]",
]

coolnames = [
L"\mathrm{Fe(II)\, slow}",
L"\mathrm{Fe(II)\, fast}",
]

ax[3][:plot](results[:Time],results[Symbol(tempvar[1])]/(rho_bulk*1000),color="k",lw=linewidth,linestyles[1], label = coolnames[1])
ax[3][:plot](results[:Time],results[Symbol(tempvar[2])]/(rho_bulk*1000),color="k",lw=linewidth,linestyles[2], label = coolnames[2])
ax[3][:yaxis][:set_major_formatter](majorFormatter)

# ax[3][:plot](results[:Time]*24,results[Symbol(tempvar[1])],color="k",lw=linewidth,linestyle=linestyles[1], label = coolnames[1])
ax[3][:legend](loc=0,frameon=false, fontsize=mysize-2)
ax[3][:set_xlim](0,1)
ax[3][:set_xlabel]("Time [day]",fontsize=mysize)
ax[3][:yaxis][:set_major_formatter](majorFormatter)
ax[3][:set_ylabel](L"\mathrm{Fe(II)\, [mol\, g_{sediment}^{-}]}",fontsize=mysize)
ax[3][:tick_params](labelsize=mysize)
ax[3][:set_title]("(C)",fontsize=mysize)
#
plt.tight_layout()

savefig("batch_step2.png",dpi=100)
