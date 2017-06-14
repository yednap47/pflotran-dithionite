using sachFun
using HDF5
using PyPlot

fig = figure("pyplot",figsize=(15,7))
filename = "1d-fe2-o2_fe2-cr6.h5"
# myvar = [
# "pH",
# "Total_H+ [M]",
# "Total_O2(aq) [M]",
# "Total_HCrO4- [M]",
# "Total_HCO3- [M]",
# "Total_Fe+++ [M]",
# "Total_Cr+++ [M]",
# "bound_Fe++ [mol_m^3]",
# "Fe(OH)3(s)_VF",
# "Cr(OH)3(s)_VF",
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
mytime = [1,3,5,7,9]
timeunits = "years"
mysize = 12

mylabel = ["$(time) $(timeunits)" for time in mytime]
mycmap = get_cmap("Paired",length(mytime)+1)

majorFormatter = matplotlib[:ticker][:FormatStrFormatter]("%0.2e")
for i in 1:length(myvar)
  subplot(2,4,i)
  # subplot(2,5,i)
  for j in 1:length(mytime)
    results = sachFun.readh5_1D(filename,[myvar[i]],coord_name,mytime[j])
    plot(results[:,1],(results[:,2]),label=mylabel[j],c=mycmap(j))
    ax = gca()
    ax[:tick_params](labelsize=mysize)
    ax[:set_xlabel](L"\mathrm{Distance\; from\; inlet\;[m]}",size=mysize+2)
    if i == 5 || i == 2 || i == 3
        ax[:yaxis][:set_major_formatter](majorFormatter)
    end
    ax[:set_ylabel]("$(myvar[i])",size=mysize+2)  
    ax[:set_xlim]([0,maximum(results[:,1])])
    # ax[:set_xlim]([0,10])
    # ax[:set_ylim]([0,maximum(results[:,2])])
  end
end

legend(loc=0,frameon=false,fontsize=mysize)
tight_layout(h_pad=.1)
savefig("1d-fe2-o2_fe2-cr6.png",dpi=600)
close()
