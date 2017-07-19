using sachFun
using HDF5
using PyPlot

fig = figure("pyplot",figsize=(3.0,3.0))
filename = ["c1","c2","c3","c4"]

myvar = ["Total_CrO4-- [M]"]
coord_name = "X"
majorFormatter = matplotlib[:ticker][:FormatStrFormatter]("%0.1e")
mysize = 9
cnvFactor = 1
linewidth=1.0

# PLOT CONCENTRATION VS TIME AT OUTFLOW
distance = 8 # meters

# mylabel = [L"\mathrm{[S_2O_4^{2-}] = 1x10^{-1}\; M}",
#            L"\mathrm{[S_2O_4^{2-}] = 1x10^{-2}\; M}",
#            L"\mathrm{[S_2O_4^{2-}] = 1x10^{-3}\; M}",
#            L"\mathrm{[S_2O_4^{2-}] = 1x10^{-4}\; M}",
#            ]

# mylabel = [L"\mathrm{10^{-1}\, M\, S_2O_4^{2-}}",
#            L"\mathrm{10^{-2}\, M\, S_2O_4^{2-}}",
#            L"\mathrm{10^{-3}\, M\, S_2O_4^{2-}}",
#            L"\mathrm{10^{-4}\, M\, S_2O_4^{2-}}",
#            ]

mylabel = [L"\mathrm{10^{-1}\, M\, S_2O_4^{-2}}",
           L"\mathrm{10^{-2}\, M\, S_2O_4^{-2}}",
           L"\mathrm{10^{-3}\, M\, S_2O_4^{-2}}",
           L"\mathrm{10^{-4}\, M\, S_2O_4^{-2}}",
           ]

mycmap = get_cmap("Paired",length(filename)+1)

for j in 1:length(filename)
results = sachFun.readh5_1D_obs("$(filename[j]).h5",myvar,coord_name,distance)
for i in 1:length(myvar)
  ax = gca()
  new_position = [0.21,0.15,.75,.75] # Position Method 2
  ax[:set_position](new_position) # Position Method 2: Change the size and position of the axis
  plot(results[:,1],results[:,i+1]*cnvFactor,label=mylabel[j],c=mycmap(j),lw=linewidth)
  ax[:tick_params](labelsize=mysize)
  ax[:set_xlabel](L"\mathrm{Time\, [year]}",size=mysize+2)
  ax[:set_ylabel](L"\mathrm{Cr(VI)\, [M]}",size=mysize+2)
  ax[:set_xlim]([0,maximum(results[:,1])])
  ax[:yaxis][:set_major_formatter](majorFormatter)
  # ax[:set_title](L"\mathrm{(A)}")
end
end

legend(loc=0,frameon=false,fontsize=mysize-2)
# tight_layout(h_pad=.1)
savefig("1d-allReactions-10m-CvsT.png",dpi=100)
close()
