using sachFun
using HDF5
using PyPlot

fig = figure("pyplot",figsize=(3.25,3))

# filename = ARGS[1]
filename = ["1d-allReactions-10m"]
# filename = "1d-allReactions-10m-fullspecies"

myvar = ["Total_CrO4-- [M]"]
coord_name = "X"
majorFormatter = matplotlib[:ticker][:FormatStrFormatter]("%0.0e")
mysize = 8
cnvFactor = 1*117.016*10^6

# PLOT CONCENTRATION VS TIME AT OUTFLOW
distance = 8 # meters

mylabel = [L"\mathrm{[NaS_2O_4^{2-}] = 1x10^{-1}\; M}",
           L"\mathrm{[NaS_2O_4^{2-}] = 1x10^{-4}\; M}",
           L"\mathrm{[NaS_2O_4^{2-}] = 1x10^{-3}\; M}",
           L"\mathrm{[NaS_2O_4^{2-}] = 1x10^{-2}\; M}"]

mycolor = ["r","b","g","m"]

for j in 1:length(filename)
results = sachFun.readh5_1D_obs("$(filename[j]).h5",myvar,coord_name,distance)
for i in 1:length(myvar)
   plot(results[:,1],results[:,i+1]*cnvFactor,label=mylabel[j],mycolor[j])
  ax = gca()
  new_position = [0.2,0.13,.77,.83] # Position Method 2
  ax[:set_position](new_position) # Position Method 2: Change the size and position of the axis
#   ax[:yaxis][:set_major_formatter](majorFormatter)
  ax[:tick_params](labelsize=mysize)
  ax[:set_xlabel](L"\mathrm{Time\; [day]}",size=mysize+2)
  ax[:set_ylabel](L"\mathrm{Cr(VI)\; [ppb]}",size=mysize+2)
  ax[:set_xlim]([0,maximum(results[:,1])])
end
end

legend(loc=0,frameon=false,fontsize=mysize)
# tight_layout(h_pad=.1)
savefig("1d-allReactions-10m-CvsT.png",dpi=600)
close()
