using sachFun
using HDF5
using PyPlot

fig = figure("pyplot",figsize=(15,7))
filename = "1d-allReactions.h5"
# myvar = [
# "pH",
# "Total H+ [M]",
# "Total S2O4-- [M]",
# "Total S2O3-- [M]",
# "Total SO3-- [M]",
# "Total SO4-- [M]",
# "Total Fe+++ [M]",
# "Total HCO3- [M]",
# "Total O2(aq)",
# "Fe(OH)3(s) VF",
# "bound_Fe++ [mol/m^3]"
# ]

# myvar = [
# "pH",
# "Total_A(aq) [M]",
# "Total_S2O4-- [M]",
# "Fe(OH)3(s)_VF",
# "bound_Fe++ [mol_m^3]",
# "Total_O2(aq)",
# ]

myvar = [
"pH",
"Total_O2(aq) [M]",
"Total_CrO4-- [M]",
"Fe(OH)3(s)_VF",
"Cr(OH)3(s)_VF",
"slow_Fe++ [mol_m^3]",
"fast_Fe++ [mol_m^3]",
]

coord_name = "X"
# mytime = [1,2,3,4,5]
mytime = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9]
timeunits = "years"
mysize = 11

mylabel = ["$(time) $(timeunits)" for time in mytime]
mycmap = get_cmap("Paired",length(mytime)+1)


# majorFormatter = matplotlib[:ticker][:FormatStrFormatter]("%0.4e")
for i in 1:length(myvar)
  subplot(2,4,i)
  for j in 1:length(mytime)
    results = sachFun.readh5_1D(filename,[myvar[i]],coord_name,mytime[j])
    plot(results[:,1],(results[:,2]),label=mylabel[j],c=mycmap(j))
    ax = gca()
    ax[:tick_params](labelsize=mysize)
    ax[:set_xlabel](L"\mathrm{Distance\; from\; inlet\;[m]}",size=mysize+2)
    # ax[:yaxis][:set_major_formatter](majorFormatter)
    ax[:set_ylabel]("$(myvar[i])",size=mysize+2)  
    ax[:set_xlim]([0,maximum(results[:,1])])
    ax[:set_xlim]([0,10])
    # ax[:set_ylim]([0,maximum(results[:,2])])
  end
end

legend(loc=0,frameon=false,fontsize=mysize)
tight_layout(h_pad=.1)
savefig("1d-allReactions.png",dpi=600)
# close()
