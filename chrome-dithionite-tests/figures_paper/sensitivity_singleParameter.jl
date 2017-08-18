# Id: test.jl, Mon 19 Jun 2017 05:10:27 PM MDT pandeys #
# Created by Sachin Pandey, LANL
# Description: Use information about Cr(III) from h5 file and bound Fe(II) in
#    mass balance file to create spider plot metrics
#------------------------------------------------------------------------------
import PyPlot
plt = PyPlot
using LaTeXStrings
import DataStructures
import JLD

coolnames  = JLD.load("./datafiles/coolnames.jld","dictionary")
savedata = JLD.load("./datafiles/results_sensitivity_singleparam.jld","dictionary")
results = savedata["results"]
sensparams = savedata["sensparams"]
logsensparams = savedata["logsensparams"]
logparams_init = savedata["logparams_init"]
paramkeys = savedata["paramkeys"]

#------------------------------------------------------------------------------
# Spider plots v2
#------------------------------------------------------------------------------
mysize = 9
linewidth = 1
f, ax = plt.subplots(1,2,figsize=(6.5,2.75))
majorFormatter = plt.matplotlib[:ticker][:FormatStrFormatter]("%0.2e")
mycmap = plt.get_cmap("Paired",length(sensparams)); extracolor = "0.5"; colorparam = "is2o4"
# mycmap = plt.get_cmap("nipy_spectral",length(sensparams)+1); extracolor = "brown"; colorparam = "q"
for sensparam in sensparams
    if sensparam != "d"
    # find the index of sensparam in paramkeys to get base value in params_init
    i = find(x -> x == sensparam,paramkeys)[1]
    basevalue = 10^logparams_init[i]

    # plot loop
    success_summary = results[sensparam]["success"]
    if length(success_summary[success_summary.=="no"])>0
    else
        # # Cr(III)
        # ax[1][:plot](results[sensparam]["sensvals"]/basevalue, results[sensparam]["final Cr(III)"], marker="x", color=mycmap(i), label=sensparam)
        # ax[1][:set_xlim](minimum(results[sensparam]["sensvals"])/basevalue,maximum(results[sensparam]["sensvals"])/basevalue)
        # ax[1][:yaxis][:set_major_formatter](majorFormatter)
        # ax[1][:set_title]("total reduced chromium")
        # ax[1][:set_xscale]("log")
        # ax[1][:set_yscale]("log")
        # ax[1][:set_xlabel]("Fraction of base value")
        # ax[1][:set_ylabel]("total moles Cr(VI) reduced")
        # # ax[1][:legend](loc=0,frameon=false,fontsize=mysize-2)
        # ax[1][:set_xlim](10.0^-1.0,10.0^1.0)
        # # ax[:set_ylim](0.0,4e-2)

        # cumulative Cr(VI) at the outflow
        if sensparam == colorparam
            ax[1][:plot](results[sensparam]["sensvals"]/basevalue, results[sensparam]["tot Cr(VI)"], marker="x", color=extracolor, label=coolnames[logsensparams[i]])
        else
            ax[1][:plot](results[sensparam]["sensvals"]/basevalue, results[sensparam]["tot Cr(VI)"], marker="x", color=mycmap(i), label=coolnames[logsensparams[i]])
        end
        ax[1][:set_xlim](minimum(results[sensparam]["sensvals"])/basevalue,maximum(results[sensparam]["sensvals"])/basevalue)
        ax[1][:yaxis][:set_major_formatter](majorFormatter)
        ax[1][:set_title](L"\mathrm{(A)}",fontsize = mysize)
        ax[1][:set_xscale]("log")
        ax[1][:set_yscale]("log")
        ax[1][:set_xlabel](L"\mathrm{Fraction\, of\, base\, value}",fontsize = mysize)
        ax[1][:set_ylabel](L"\mathrm{Cr(VI)\, [mol]}",fontsize = mysize)
        ax[1][:set_xlim](10.0^-1.0,10.0^1.0)
        ax[1][:tick_params](labelsize=mysize)
        
        # maximum surface bound Fe(II)
        if sensparam == colorparam
            ax[2][:plot](results[sensparam]["sensvals"]/basevalue, results[sensparam]["max Fe(II)"], marker="x", color=extracolor, label=coolnames[logsensparams[i]])
        else
            ax[2][:plot](results[sensparam]["sensvals"]/basevalue, results[sensparam]["max Fe(II)"], marker="x", color=mycmap(i), label=coolnames[logsensparams[i]])
        end
        ax[2][:set_xlim](minimum(results[sensparam]["sensvals"])/basevalue,maximum(results[sensparam]["sensvals"])/basevalue)
        ax[2][:yaxis][:set_major_formatter](majorFormatter)
        ax[2][:set_title](L"\mathrm{(B)}",fontsize = mysize)
        ax[2][:set_xscale]("log")
        ax[2][:set_yscale]("log")
        ax[2][:set_xlabel](L"\mathrm{Fraction\, of\, base\, value}",fontsize = mysize)
        ax[2][:set_ylabel](L"\mathrm{\equiv Fe(II)\, [mol]}",fontsize = mysize)
        ax[2][:set_xlim](10.0^-1.0,10.0^1.0)
        ax[2][:set_ylim](10.0^-1.4,10.0^1.0)
        ax[2][:tick_params](labelsize=mysize)
    end
    end
end
box = ax[1][:get_position]()
ax[1][:set_position]([box[:x0]-0.02, box[:y0]+0.09, box[:width] * 0.8, box[:height] * 0.9])

box = ax[2][:get_position]()
ax[2][:set_position]([box[:x0]-0.05, box[:y0]+0.09, box[:width] * 0.8, box[:height] * 0.9])

ax[2][:legend](loc=0,fontsize=mysize-2,loc=2, bbox_to_anchor=(1.1, 1.03), frameon = false)
f[:canvas][:draw]() # Update the figure
plt.savefig("res_low/sensitivity_singleparameter.png",dpi=100)
plt.savefig("res_high/sensitivity_singleparameter.png",dpi=600)
plt.close()
