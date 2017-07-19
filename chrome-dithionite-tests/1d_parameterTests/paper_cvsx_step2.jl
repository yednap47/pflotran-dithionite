using sachFun
using HDF5
using PyPlot
plt = PyPlot

filename = "1d-allReactions-10m-uniformVelocity"

# myvar = [
# "pH",
# "Total_O2(aq) [M]",
# "Total_CrO4-- [M]",
# "Fe(OH)3(s)_VF",
# "Cr(OH)3(s)_VF",
# "Calcite_VF",
# "slow_Fe++ [mol_m^3]",
# "fast_Fe++ [mol_m^3]",
# ]

myvar = [
"Total_O2(aq) [M]",
"Total_CrO4-- [M]",
"Fe(OH)3(s)_VF",
"Cr(OH)3(s)_VF",
"slow_Fe++ [mol_m^3]",
"fast_Fe++ [mol_m^3]",
]

coord_name = "X"
mytime = [115,215,315]

# get the results first
results = Dict()
for i in 1:length(myvar)
    results[myvar[i]] = Dict()
  for j in 1:length(mytime)
    results[myvar[i]][string(mytime[j])] = sachFun.readh5_1D("$(filename).h5",[myvar[i]],coord_name,mytime[j])
  end
end

# PLOT RESULTS
coolnames = [
L"\mathrm{O_2(aq)\, [M]}",
L"\mathrm{CrO_4^{-2}\, [M]}",
L"\mathrm{Fe(OH)_3(s)\, [wt\%]}",
L"\mathrm{Cr(OH)_3(s)\, [wt\%]}",
L"\mathrm{Fe(II)\, slow\, [mol\, g_{sediment}^-]}",
L"\mathrm{Fe(II)\, fast\, [mol\, g_{sediment}^-]}",
]

timeunits = "day"
mysize = 9
linewidth = 1.0

mylabel = ["$(time) $(timeunits)" for time in mytime]
# mycmap = get_cmap("Paired",length(mytime)+1)
mycmap = get_cmap("Paired",5)
linestyles = ["-",":","--","-."]
majorFormatter = matplotlib[:ticker][:FormatStrFormatter]("%0.1e")
majorFormatter2 = matplotlib[:ticker][:FormatStrFormatter]("%0.1f")

fig, ax = plt.subplots(2,3,figsize=(6.5,3.75), sharex=true)
for i in 1:length(myvar)
  for j in 1:length(mytime)
    # ax[i][:plot](results[myvar[i]][string(mytime[j])][:,1],results[myvar[i]][string(mytime[j])][:,2],label=mylabel[j],c="k",lw=linewidth,ls = linestyles[j])
    ax[i][:plot](results[myvar[i]][string(mytime[j])][:,1],results[myvar[i]][string(mytime[j])][:,2],label=mylabel[j],c=mycmap(j),lw=linewidth,ls = "-")
    ax[i][:tick_params](labelsize=mysize)
    ax[i][:set_ylabel]("$(coolnames[i])",size=mysize)  
    ax[i][:set_xlim]([0,maximum(results[myvar[i]][string(mytime[j])][:,1])])
    ax[i][:set_xlim]([0,10])
    ax[i][:set_xlim]([0,4])
  end
end
ax[1][:yaxis][:set_major_formatter](majorFormatter)
ax[2][:yaxis][:set_major_formatter](majorFormatter)
ax[3][:yaxis][:set_major_formatter](majorFormatter)
ax[4][:yaxis][:set_major_formatter](majorFormatter)
ax[5][:yaxis][:set_major_formatter](majorFormatter2)
ax[6][:yaxis][:set_major_formatter](majorFormatter2)

ax[6][:legend](loc=1,frameon=false,fontsize=mysize-2)

labeledxaxes = [2,4,6]
for i in 1:length(labeledxaxes)
    ax[labeledxaxes[i]][:set_xlabel](L"\mathrm{Distance\; from\; inlet\;[m]}",size=mysize)
    ax[labeledxaxes[i]][:set_xticks](0:4)
end

tight_layout(pad = 0.1, w_pad=0.0, h_pad = 1.0)

for i in 5:6
box = ax[i][:get_position]()
ax[i][:set_position]([box[:x0]-0.025, box[:y0], box[:width], box[:height]])
end

fig[:canvas][:draw]() # Update the figure
savefig("paper_cvsx_step2.png",dpi=100)
close()
