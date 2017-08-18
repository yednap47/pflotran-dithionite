import PyPlot
plt = PyPlot
using LaTeXStrings
import JLD

linewidth = 1
std_skipfactor = 17
mysize = 9

savedata = JLD.load("./datafiles/results_2d_realization.jld","dictionary")
obstimes = savedata["obstimes"]
obsmean = savedata["obsmean"]
obsresults = savedata["obsresults"]
obsstd = savedata["obsstd"]
fig,ax = plt.subplots(figsize=(4,3))
for i in 1:length(obsresults[1,:])
    ax[:plot](obstimes,obsresults[:,i],"0.75",lw=linewidth,zorder=-32)
end
ax[:plot](obstimes,obsmean,"k",lw=linewidth)
pe =  ax[:errorbar](obstimes[5:std_skipfactor:end],obsmean[5:std_skipfactor:end],yerr=obsstd[5:std_skipfactor:end],fmt="ko",lw=linewidth,markeredgewidth=linewidth)
ax[:tick_params](labelsize=mysize)
ax[:set_xlabel](L"\mathrm{Time\, [day]}",size=mysize)  
ax[:set_ylabel](L"\mathrm{CrO_4^{-2}\, [ppb]}")
plt.plot([0,0],[0,0],color = "0.75", label = "realizations")
plt.plot([0,0],[0,0],color = "k", label = "mean and error")
plt.tight_layout()
plt.legend(loc=0,fontsize=mysize-2,frameon=false)
plt.draw()
plt.savefig("./res_low/results_2d_realization.png",dpi=100)
plt.savefig("./res_high/results_2d_realization.png",dpi=600)
plt.close()
