using sachFun
using HDF5
using PyPlot

fig = figure("pyplot",figsize=(15,7))
filename = ARGS[1]
# filename = "1d-allReactions-10m"
# filename = "1d-allReactions-10m-fullspecies"

myvar = [
"pH",
"Total_O2(aq) [M]",
"Total_CrO4-- [M]",
"Fe(OH)3(s)_VF",
"Cr(OH)3(s)_VF",
"slow_Fe++ [mol_m^3]",
"fast_Fe++ [mol_m^3]",
"Total_S2O4-- [M]",
# "Total_A(aq) [M]",
]

coord_name = "X"
# mytime = [1,2,3,4,5]
mytime = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9]
# mytime = [0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08]
timeunits = "years"
mysize = 11

mylabel = ["$(time) $(timeunits)" for time in mytime]
mycmap = get_cmap("Paired",length(mytime)+1)


majorFormatter = matplotlib[:ticker][:FormatStrFormatter]("%0.2e")
for i in 1:length(myvar)
  subplot(2,4,i)
  for j in 1:length(mytime)
    results = sachFun.readh5_1D("$(filename).h5",[myvar[i]],coord_name,mytime[j])
    plot(results[:,1],(results[:,2]),label=mylabel[j],c=mycmap(j))
    ax = gca()
    ax[:tick_params](labelsize=mysize)
    ax[:set_xlabel](L"\mathrm{Distance\; from\; inlet\;[m]}",size=mysize+2)
    ax[:yaxis][:set_major_formatter](majorFormatter)
    ax[:set_ylabel]("$(myvar[i])",size=mysize+2)  
    ax[:set_xlim]([0,maximum(results[:,1])])
    ax[:set_xlim]([0,10])
    # ax[:set_ylim]([0,maximum(results[:,2])])
  end
end

legend(loc=0,frameon=false,fontsize=mysize)
tight_layout(h_pad=.1)
savefig("$(filename).png",dpi=600)
# close()

myvar = [
# "pH",
# "Total_O2(aq) [M]",
# "Total_CrO4-- [M]",
"Fe(OH)3(s)_VF",
# "Cr(OH)3(s)_VF",
"slow_Fe++ [mol_m^3]",
"fast_Fe++ [mol_m^3]",
# "Total_S2O4-- [M]",
]

results = sachFun.readh5_1D("$(filename).h5",myvar,coord_name,0.1)
