# Id: getTotalCr3.jl, Mon 05 Jun 2017 10:54:45 AM MDT pandeys #
# Created by Sachin Pandey, LANL
# Description: For an multiple runs, read the h5 file and calculate total 
#   number of moles of Cr(III) produced at a certain timestep. Also grab information
#   from mads file so we no which parameter/value corresponds to which run
#------------------------------------------------------------------------------
import sachFun
import Mads
import PyPlot
plt = PyPlot

function getTotalCr3(istop,filename)
    # calculate moles using m^3/m^3_bulk, dxyz and molar volume
    results = sachFun.readh5_1D(filename,myvar,coord_name,mytime)
    volumes = dx*dy*dz
    moles = results[:,2].*volumes/MV
    total_moles = sum(moles)
    return total_moles
end

function transformmadsdata(logparamsval,logparamkeys)
    paramkeys = Array{String}(length(logparamkeys))
    paramsval = Array{Float64}(length(logparamsval))
    for i in 1:length(paramsval)
        if contains(logparamkeys[1],"log_")
            paramkeys[i] = split(logparamkeys[i],"log_")[2]
            paramsval[i] = 10^logparamsval[i]
        else
            paramkeys[i] = logparamkeys[i]
            paramsval[i] = logparamsval[i]
        end
    end
    return paramkeys, paramsval
end

#------------------------------------------------------------------------------
# User info
#------------------------------------------------------------------------------
basedir = "/lclscratch/sach/Programs/pflotran-dithionite-git/chrome-dithionite-tests/sensitivity/singleParameter"
rundir = "attempt4"
simbasename = "1d-allReactions-10m-uniformVelocity"
sensparams = ["d",
              "ifeoh3",
              "is2o4",
              "k_fe2_cr6_fast",
              "k_fe2_cr6_slow",
              "k_fe2_o2_fast",
              "k_fe2_o2_slow",
              "k_s2o4_disp",
              "k_s2o4_fe3",
              "k_s2o4_o2",
              "q"]
nstops = 5 # number of sensitivity runs
mytime = 0.99
myvar = ["Cr(OH)3(s)_VF"]
MV = 33.1/(100)^3 # m^3/mol
coord_name = "X"


# Get grid information for calculating volumes
dx= vcat(0.01*ones(200),0.1*ones(40),0.2*ones(20))
dy = 0.1
dz = 0.1

#------------------------------------------------------------------------------
# Get parameter info from madsfile
#------------------------------------------------------------------------------
madsdata = Mads.loadmadsfile(joinpath(rundir,"$(simbasename).mads"))

# get param names (non-log) and param ranges
logparams_init = Mads.getparamsinit(madsdata)
logparamkeys = Mads.getparamkeys(madsdata)
logparams_min = Mads.getparamsmin(madsdata)
logparams_max = Mads.getparamsmax(madsdata)

paramkeys,params_init = transformmadsdata(logparams_init,logparamkeys)
paramkeys,params_min = transformmadsdata(logparams_min,logparamkeys)
paramkeys,params_max = transformmadsdata(logparams_max,logparamkeys)

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
    results[sensparam]["sensvals"] = sensvals = 10.^linspace(logparams_min[iparamloc],logparams_max[iparamloc],nstops)

    # loop for each sensitivity run
    success = Array{String}(0)
    sensresults = Array{Float64}(0)
    for istop in 1:nstops
        filename = joinpath(basedir,rundir,sensparam,"run$istop","$(simbasename).h5")
        try
            totalCr3 = getTotalCr3(istop,filename)
            sensresults = append!(sensresults,[totalCr3])
            success = append!(success,["yes"])
        catch
            success = append!(success,["no"])
        end
        results[sensparam]["success"] = success
        results[sensparam]["totCr3"] = sensresults
    end
end

#------------------------------------------------------------------------------
# Spider plots
#------------------------------------------------------------------------------
f, ax = plt.subplots(3, 4, figsize=(15,12))
majorFormatter = plt.matplotlib[:ticker][:FormatStrFormatter]("%0.2e")
plotindex = 1
for sensparam in sensparams
    # find the index of sensparam in paramkeys to get base value in params_init
    i = find(x -> x == sensparam,paramkeys)[1]
    basevalue = params_init[i]
    
    # plot loop
    success_summary = results[sensparam]["success"]
    if length(success_summary[success_summary.=="no"])>0
        warn("$sensparam sensitivity analysis failed!")
    else
        ax[plotindex][:plot](results[sensparam]["sensvals"]/basevalue,results[sensparam]["totCr3"],marker="x")
        ax[plotindex][:set_xlim](minimum(results[sensparam]["sensvals"])/basevalue,maximum(results[sensparam]["sensvals"])/basevalue)
        ax[plotindex][:yaxis][:set_major_formatter](majorFormatter)
        ax[plotindex][:set_title](sensparam)
        ax[plotindex][:set_xscale]("log")
        ax[plotindex][:set_xlabel]("Fraction of base value")
        ax[plotindex][:set_ylabel]("total moles Cr(VI) reduced")
        plotindex += 1
    end
end
plt.tight_layout()
f[:canvas][:draw]() # Update the figure


f2, ax2 = plt.subplots(figsize=(8,7))
mycmap = plt.get_cmap("Paired",length(sensparams)+1)
for sensparam in sensparams
    # find the index of sensparam in paramkeys to get base value in params_init
    i = find(x -> x == sensparam,paramkeys)[1]
    basevalue = params_init[i]

    # plot loop
    success_summary = results[sensparam]["success"]
    if length(success_summary[success_summary.=="no"])>0
        warn("$sensparam sensitivity analysis failed!")
    else
        ax2[:plot](results[sensparam]["sensvals"]/basevalue,results[sensparam]["totCr3"],marker="x",color=mycmap(i),label=sensparam)
        ax2[:set_xlim](minimum(results[sensparam]["sensvals"])/basevalue,maximum(results[sensparam]["sensvals"])/basevalue)
        ax2[:yaxis][:set_major_formatter](majorFormatter)
        ax2[:set_title](sensparam)
        ax2[:set_xscale]("log")
        ax2[:set_xlabel]("Fraction of base value")
        ax2[:set_ylabel]("total moles Cr(VI) reduced")
        ax2[:legend](loc=0)
        ax2[:set_xlim](10.0^-1.0,10.0^1.0)
    end
end
plt.tight_layout()
f2[:canvas][:draw]() # Update the figure
