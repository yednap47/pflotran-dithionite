import sachFun
import PyPlot
plt = PyPlot
using LaTeXStrings

function plot_2d(basedir,myvar,mytimestep,thisrun)
    results = sachFun.readh5_2D(joinpath(basedir,rundir,"run$thisrun","src.h5"),myvar,Int(mytimestep))
    test = reshape(results[:,3]*MW_Cr*10^6,ny,nx)
    xgrid = 1:nx/dxyz
    ygrid = 1:ny/dxyz

    fig,ax = plt.subplots(figsize=(15,10))
    plt.pcolor(xgrid,ygrid,convert(Array,test))
    plt.colorbar(format="%.2f")
    ax[:set_ylabel]("y, meters")
    ax[:set_xlabel]("x, meters")
    ax[:set_xlim](1,nx/dxyz)
    ax[:set_ylim](1,ny/dxyz)
    fig[:canvas][:draw]() # Update the figure
    ax[:set_title]("$(mytimestep*2) days")
    plt.tight_layout()
    plt.savefig(joinpath(basedir,rundir,"results_$(Int(mytimestep*2))","run$thisrun.png"))
    plt.close()
end

nstart = 1
nfinish = 22
rundir =  "corr1_sig1"
permfieldbasename = "rand_100x75_corr10_sig1_20mpd_n"
basedir = "/lclscratch/sach/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/permeability"
mytimestep = 102/2
nx = 100
ny = 75
dxyz = 1
MW_Cr = 52.0
plotresults = false

plotobs = true
fobsname = "src-obs-7.tec"
fobsname_norxn = "src_norxn-obs-7.tec"
obstimes = 0.0:1.0:200
std_skipfactor = 17
mysize = 9
linewidth = 1

# make run directory
if !isdir(joinpath(basedir,rundir,"results_$(Int(mytimestep*2))"))
    mkdir(joinpath(basedir,rundir,"results_$(Int(mytimestep*2))"))
end


results = Dict()
if plotobs
    fig,ax = plt.subplots(figsize=(6,4))
    obsresults = Array{Float64}(length(obstimes),nfinish-nstart+1)
end
for thisrun in nstart:1:nfinish
    # Get the simulation times
    results["run $thisrun"] = Dict()
    f = open(joinpath(basedir,rundir,"run$(thisrun)","src.out"))
    temp = readlines(f)
    close(f)
    results["run $thisrun"]["Simulation Time"] = float(split(temp[end]," ")[end-1])
    
    # Plot at a certain timestep
    if plotresults
        myvar = ["Total_CrO4-- [M]"]
        plot_2d(basedir,myvar,mytimestep,thisrun)
    end
    
    if plotobs
        myvar = ["Total CrO4-- [M] obs1"]
        obsresults[:,thisrun] = sachFun.readObsDataset(joinpath(basedir,rundir,"run$(thisrun)",fobsname),myvar,dataframe=false)[:,2]*MW_Cr*10^6
        ax[:plot](obstimes,obsresults[:,thisrun],"0.75",lw=linewidth,zorder=-32)
    end
end

# calculate mean and standard deviation of observation breakthrough
obsmean = Array{Float64}(length(obstimes))
obsstd = Array{Float64}(length(obstimes))
if plotobs
    for i in 1:length(obstimes)
        obsmean[i] = mean(obsresults[i,:])
        obsstd[i] = sqrt(var(obsresults[i,:]))
    end
    ax[:plot](obstimes,obsmean,"k",lw=linewidth)
    pe = ax[:errorbar](obstimes[5:std_skipfactor:end],obsmean[5:std_skipfactor:end],yerr=obsstd[5:std_skipfactor:end],fmt="ko",lw=linewidth,markeredgewidth=linewidth)
    ax[:tick_params](labelsize=mysize)
    ax[:set_xlabel](L"\mathrm{Time\, [day]}",size=mysize)  
    ax[:set_ylabel](L"\mathrm{CrO_4^{-2}\, [\mu g\,l^-]}")
    plt.draw()
    plt.savefig("results.png",dpi=600)
end
