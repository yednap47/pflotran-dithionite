import sachFun
import PyPlot
plt = PyPlot
using LaTeXStrings
import JLD

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
nfinish = 100
rundir =  "corr1_sig1"
permfieldbasename = "rand_100x75_corr10_sig1_20mpd_n"
basedir = "/lclscratch/sach/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/permeability"
mytimestep = 102/2
nx = 100
ny = 75
dxyz = 1
MW_Cr = 52.0
plotresults = false

plotobs = false
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
        @show thisrun
    # Get the simulation times
    results["run $thisrun"] = Dict()
    f = open(joinpath(basedir,rundir,"run$(thisrun)","src.out"))
    temp = readlines(f)
    close(f)
    try
        results["run $thisrun"]["Simulation Time"] = float(split(temp[end]," ")[end-1])
        results["run $thisrun"]["success"] = true
    catch
        println("problems reading *.out for run $thisrun")
        results["run $thisrun"]["success"] = false
    end

    try 
        # Plot at a certain timestep
        if plotresults
            myvar = ["Total_CrO4-- [M]"]
            plot_2d(basedir,myvar,mytimestep,thisrun)
            results["run $thisrun"]["success"] = true
        end
    catch
        println("problems plotting 2d results for $thisrun")
        results["run $thisrun"]["success"] = false
    end

    try
        if plotobs
            myvar = ["Total CrO4-- [M] obs1"]
            obsresults[:,thisrun] = sachFun.readObsDataset(joinpath(basedir,rundir,"run$(thisrun)",fobsname),myvar,dataframe=false)[:,2]*MW_Cr*10^6
            ax[:plot](obstimes,obsresults[:,thisrun],"0.75",lw=linewidth,zorder=-32)
            results["run $thisrun"]["success"] = true
        end
    catch
        println("problems plotting 2d results for $thisrun")
        results["run $thisrun"]["success"] = false
    end
end

if plotobs
    obsresults_success = Array{Float64}(0)
    for thisrun in nstart:1:nfinish
        if results["run $thisrun"]["success"]
            append!(obsresults_success,obsresults[:,thisrun])
        end
    end
    obsresults_success = reshape(obsresults_success,length(obstimes),Int(length(obsresults_success)/length(obstimes)))
    nsuccesses = length(obsresults_success[1,:])

    # calculate mean and standard deviation of observation breakthrough
    obsmean = Array{Float64}(length(obstimes))
    obsstd = Array{Float64}(length(obstimes))
    if plotobs
        for i in 1:length(obstimes)
            obsmean[i] = mean(obsresults_success[i,:])
            obsstd[i] = sqrt(var(obsresults_success[i,:]))
        end
        ax[:plot](obstimes,obsmean,"k",lw=linewidth)
        pe = ax[:errorbar](obstimes[5:std_skipfactor:end],obsmean[5:std_skipfactor:end],yerr=obsstd[5:std_skipfactor:end],fmt="ko",lw=linewidth,markeredgewidth=linewidth)
        ax[:tick_params](labelsize=mysize)
        ax[:set_xlabel](L"\mathrm{Time\, [day]}",size=mysize)  
        ax[:set_ylabel](L"\mathrm{CrO_4^{-2}\, [ppb]}")
        plt.draw()
        plt.savefig("res_low/results_2d_realization.png",dpi=100)
        plt.savefig("res_high/results_2d_realization.png",dpi=600)
    end

    savedata = Dict()
    savedata["obsresults"] = obsresults_success
    savedata["obstimes"] =  obstimes
    savedata["obsmean"] =  obsmean
    savedata["obsstd"] =  obsstd
    JLD.save("results_2d_realization.jld","dictionary",savedata)
end
