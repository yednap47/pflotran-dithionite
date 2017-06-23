# Id: test.jl, Mon 19 Jun 2017 05:10:27 PM MDT pandeys #
# Created by Sachin Pandey, LANL
# Description: Use information about Cr(III) from h5 file and bound Fe(II) in
#    mass balance file to create spider plot metrics
#------------------------------------------------------------------------------
import sachFun
import Mads
import PyPlot
plt = PyPlot
using LaTeXStrings

function getTotalCr3_fromh5(istop,filename,myvar)
    # calculate moles using m^3/m^3_bulk, dxyz and molar volume
    results = sachFun.readh5_1D(filename,myvar,coord_name,mytime)
    volumes = dx*dy*dz
    moles = results[:,2].*volumes/MV
    total_moles = sum(moles)
    return total_moles
end

#------------------------------------------------------------------------------
# User info
#------------------------------------------------------------------------------
basedir = "/lclscratch/sach/Programs/pflotran-dithionite-git/chrome-dithionite-tests/sensitivity/singleParameter"
rundir = "attempt1"
simbasename = "1d-allReactions-10m-uniformVelocity"
sensparams = [
              "k_s2o4_disp",
              "k_s2o4_o2",
              "k_s2o4_fe3",
              "fraction",
              "k_fe2_o2_fast",
              "factor_k_fe2_o2_slow",
              "k_fe2_cr6_fast",
              "factor_k_fe2_cr6_slow",
              "is2o4",
              "ifeoh3",
              "d",
              "q",
              ]

coolnames =  [
              L"\mathrm{k_{S_2O_4^{-2}-disp}}",
              L"\mathrm{k_{S_2O_4^{-2}-O_2(aq)}}",
              L"\mathrm{k_{S_2O_4^{-2}-Fe(OH)_3(s)}}",
              L"\mathrm{\phi_{fast}}",
              L"\mathrm{k_{\equiv Fe(II)-O_2(aq)^-}}",
              L"\mathrm{f_{\equiv Fe(II)-O_2(aq)^-}}",
              L"\mathrm{k_{\equiv Fe(II)-HCrO_4^-}}",
              L"\mathrm{f_{\equiv Fe(II)-HCrO_4^-}}",
              L"\mathrm{[Na_2S_2O_4]}",
              L"\mathrm{Wt.\%_{Fe(OH)_3(s)}}",
              L"\mathrm{D}",
              L"\mathrm{q}",
              ]

nstops = 3 # number of sensitivity runs
mytime = 0.99
MV = 33.1/(100)^3 # m^3/mol
coord_name = "X"

# Get grid information for calculating volumes
dx= vcat(0.01*ones(200),0.1*ones(40),0.2*ones(20))
dy = 0.1
dz = 0.1

# For plotting
mysize = 11
linewidth = 2

#------------------------------------------------------------------------------
# Get parameter info from madsfile
#------------------------------------------------------------------------------
madsdata = Mads.loadmadsfile(joinpath(rundir,"$(simbasename).mads"))

# get param names (non-log) and param ranges
logparams_init = Mads.getparamsinit(madsdata)
logparams_min = Mads.getparamsmin(madsdata)
logparams_max = Mads.getparamsmax(madsdata)
logparamkeys = Mads.getparamkeys(madsdata)
paramkeys = map(x->split(x,"log_")[2],logparamkeys)

#------------------------------------------------------------------------------
# Build dictionary of results
#------------------------------------------------------------------------------
# loop for parameters we are interested
results = Dict()
for sensparam in sensparams
    @show sensparam
    results[sensparam] = Dict()

    # make range for sensitivity analysis
    iparamloc = find(x -> x == sensparam,paramkeys)[1]

    sensvals = Array{Float64}(0)
    sensvals = append!(sensvals,logparams_init[iparamloc])

    # append param values below base value
    smallparams = collect(linspace(logparams_min[iparamloc],logparams_init[iparamloc],nstops+1)[1:end-1])
    largeparams = collect(linspace(logparams_init[iparamloc],logparams_max[iparamloc],nstops+1)[2:end])
    sensvals = append!(smallparams,sensvals)
    sensvals = append!(sensvals,largeparams)
    sensvals = 10.^sensvals
    results[sensparam]["sensvals"] = sensvals

    # Get total moles of Cr(OH)3 from h5 file
    # Also figure out whether or not the simulation was a completed
    myvar = ["Cr(OH)3(s)_VF"]
    completed = Array{String}(0)
    sensresults = Array{Float64}(0)
    for istop in 1:nstops*2+1
        filename = joinpath(basedir,rundir,sensparam,"run$istop","$(simbasename).h5")
        try
            totalCr3 = getTotalCr3_fromh5(istop,filename,myvar)
            sensresults = append!(sensresults,[totalCr3])
            completed = append!(completed,["yes"])
        catch
            completed = append!(completed,["no"])
        end
        results[sensparam]["success"] = completed
        results[sensparam]["final Cr(III)"] = sensresults
    end

    # Get the MAXIMUM amount of Fe reduced using the mass balance file
    # Get the TOTA amount of s2o4 consumed using the mass balance file
    myvar = ["Global fast_Fe++", "Global slow_Fe++", "east CrO4-- [mol]", "east CrO4-- [mol/y]", "east Cr+++ [mol]"]
    sensresults_fe2 = Array{Float64}(0) # maximum surface bound fe2
    sensresults_cr6 = Array{Float64}(0) # moles of cr6 that reach the outflow
    for istop in 1:nstops*2+1
        if completed[istop] == "yes"
            filename = joinpath(basedir,rundir,sensparam,"run$istop","$(simbasename)-mas.dat")
            obsresults = sachFun.readObsDataset(filename,myvar,dataframe=true)
            total_sboundfe2 = obsresults[Symbol("Global fast_Fe++")] + obsresults[Symbol("Global slow_Fe++")]
            sensresults_fe2 = append!(sensresults_fe2,[maximum(total_sboundfe2)])
            sensresults_cr6 = append!(sensresults_cr6,-(obsresults[Symbol("east CrO4-- [mol]")][end]))
        end
        results[sensparam]["max Fe(II)"] = sensresults_fe2
        results[sensparam]["tot Cr(VI)"] = sensresults_cr6
    end
end

#------------------------------------------------------------------------------
# Spider plots v2
#------------------------------------------------------------------------------
f, ax = plt.subplots(1,2,figsize=(10.0,4.5))
majorFormatter = plt.matplotlib[:ticker][:FormatStrFormatter]("%0.2e")
# mycmap = plt.get_cmap("hsv",length(sensparams)+1)
mycmap = plt.get_cmap("Paired",length(sensparams)+1)
for sensparam in sensparams
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
        ax[1][:plot](results[sensparam]["sensvals"]/basevalue, results[sensparam]["tot Cr(VI)"], marker="x", color=mycmap(i), label=coolnames[i])
        ax[1][:set_xlim](minimum(results[sensparam]["sensvals"])/basevalue,maximum(results[sensparam]["sensvals"])/basevalue)
        ax[1][:yaxis][:set_major_formatter](majorFormatter)
        ax[1][:set_title](L"\mathrm{(A)}")
        ax[1][:set_xscale]("log")
        ax[1][:set_yscale]("log")
        ax[1][:set_xlabel](L"\mathrm{Fraction\, of\, base\, value}")
        ax[1][:set_ylabel](L"\mathrm{\Sigma\, Cr(VI),\, [mol]}")
        ax[1][:set_xlim](10.0^-1.0,10.0^1.0)
        
        # maximum surface bound Fe(II)
        ax[2][:plot](results[sensparam]["sensvals"]/basevalue, results[sensparam]["max Fe(II)"], marker="x", color=mycmap(i), label=coolnames[i])
        ax[2][:set_xlim](minimum(results[sensparam]["sensvals"])/basevalue,maximum(results[sensparam]["sensvals"])/basevalue)
        ax[2][:yaxis][:set_major_formatter](majorFormatter)
        ax[2][:set_title](L"\mathrm{(B)}")
        ax[2][:set_xscale]("log")
        ax[2][:set_yscale]("log")
        ax[2][:set_xlabel](L"\mathrm{Fraction\, of\, base\, value}")
        ax[2][:set_ylabel](L"\mathrm{\equiv Fe(II)\, [mol]}")
        ax[2][:set_xlim](10.0^-1.0,10.0^1.0)
    end
end
box = ax[1][:get_position]()
ax[1][:set_position]([box[:x0]-0.02, box[:y0]+0.035, box[:width] * 0.82, box[:height]])

box = ax[2][:get_position]()
ax[2][:set_position]([box[:x0]-0.05, box[:y0]+0.035, box[:width] * 0.82, box[:height]])

ax[2][:legend](loc=0,fontsize=mysize,loc=4, bbox_to_anchor=(1.7, 0.0))
f[:canvas][:draw]() # Update the figure
plt.savefig("results_full_$(rundir).png")
plt.close()