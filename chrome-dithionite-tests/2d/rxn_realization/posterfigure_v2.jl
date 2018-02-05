import JLD
using PyPlot
plt = PyPlot
using LaTeXStrings

results_wellspacing = JLD.load("./wellspacing/sens_2d_wellspacing.jld","dictionary")
results_injectionrate = JLD.load("./injectionrate/sens_2d_injectionrate.jld","dictionary")
results_concentration = JLD.load("./concentration/sens_2d_concentration.jld","dictionary")


colors = ["blue","green","red","orange","purple"]
offset = [0.0 1.1 1.35]
new_position = [0.16;0.16;0.75;0.5] # Position Method 2
mysize = 11
lw = 1
MW_Cr = 52.0
MW_s2o4 = 
rho_H2O = 997.16 # kg/m^3

fig = figure("pyplot_multiaxis",figsize=(4,3))
ax = gca()
# title(wellName)


i = 1
font = Dict("color"=>colors[i])
xlabel(L"\mathrm{Injection\, rate\, [gpm]}",fontdict=font,size=mysize)
ylabel(L"\mathrm{Cr(VI)\, [kg]}",size=mysize)
p = plt.plot(results_injectionrate["value"]/rho_H2O*1000*60/3.78541,results_injectionrate["cr6"]*MW_Cr/1000, color=colors[i], marker="o",linewidth=lw, markersize = 0)
setp(ax[:get_xticklabels](),color=colors[i]) # Y Axis font formatting
ax[:spines]["bottom"][:set_color](colors[i])
# ax[:set_ylim](minimum(waterLevelData[:waterlevels])-0.1,maximum(waterLevelData[:waterlevels])+0.1)
ax[:set_position](new_position) # Position Method 2: Change the size and position of the axis
ax[:tick_params](labelsize=mysize)
[t[:set_color](colors[i]) for t in ax[:xaxis][:get_ticklines]()]
ax[:set_xlim](minimum(results_injectionrate["value"]/rho_H2O*1000*60/3.78541),maximum(results_injectionrate["value"]/rho_H2O*1000*60/3.78541))


i=2
font = Dict("color"=>colors[i])
ax2 = ax[:twiny]() # Create another axis on top of the current axis
ax2[:set_position](new_position) # Position Method 2: Change the size and position of the axis
setp(ax2[:get_yticklabels](),color="black") # Y Axis font formatting
p = ax2[:plot](results_wellspacing["value"],results_wellspacing["cr6"]*MW_Cr/1000, color=colors[i],marker="o",linewidth=lw, markersize = 0)
ax2[:set_xlabel](L"\mathrm{Well\; spacing\, [m]}",fontdict=font,size=mysize)
setp(ax2[:get_xticklabels](),color=colors[i]) # Y Axis font formatting
ax2[:spines]["top"][:set_color](colors[i])
ax2[:set_frame_on](true) # Make the entire frame visible
ax2[:patch][:set_visible](false) # Make the patch (background) invisible so it doesn't cover up the other axes' plots
ax2[:spines]["right"][:set_visible](false) # Hide the top edge of the axis
ax2[:spines]["bottom"][:set_visible](false) # Hide the bottom edge of the axis
ax2[:tick_params](labelsize=mysize)
ax2[:set_xlim](minimum(results_wellspacing["value"]),maximum(results_wellspacing["value"]))
[t[:set_color](colors[i]) for t in ax2[:xaxis][:get_ticklines]()]

i=3
font = Dict("color"=>colors[i])
ax3 = ax[:twiny]() # Create another axis on top of the current axis
ax3[:set_position](new_position) # Position Method 2: Change the size and position of the axis
ax3[:spines]["top"][:set_position](("axes",offset[i])) # Offset the y-axis label from the axis itself so it doesn't overlap the second axis
p = ax3[:plot](results_concentration["value"]*128.13,results_concentration["cr6"]*MW_Cr/1000, color=colors[i],marker="o",linewidth=lw, markersize = 0)
ax3[:set_xlabel](L"\mathrm{Injection\, concentration\, [g/l]}",fontdict=font,size=mysize)
setp(ax3[:get_xticklabels](),color=colors[i]) # Y Axis font formatting
ax3[:spines]["top"][:set_color](colors[i])

ax3[:set_frame_on](true) # Make the entire frame visible
ax3[:patch][:set_visible](false) # Make the patch (background) invisible so it doesn't cover up the other axes' plots
ax3[:spines]["right"][:set_visible](false) # Hide the top edge of the axis
ax3[:spines]["bottom"][:set_visible](false) # Hide the bottom edge of the axis
ax3[:tick_params](labelsize=mysize)
ax3[:set_xlim](minimum(results_concentration["value"]*128.13),maximum(results_concentration["value"]*128.13))

# ax3[:tick_params](axis='x', colors=colors[i])
[t[:set_color](colors[i]) for t in ax3[:xaxis][:get_ticklines]()]

fig[:canvas][:draw]() # Update the figure

savefig("results_2d_sens_wellparams.png",dpi=600)
