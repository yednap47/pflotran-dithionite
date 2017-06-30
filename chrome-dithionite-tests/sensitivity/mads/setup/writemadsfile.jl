import ExcelReaders
xlr = ExcelReaders
using PyCall
@pyimport numpy.random as nr
import PyPlot
plt = PyPlot
import sachConvert
import sachFun
import DataFrames
df = DataFrames

function madstargets(outfile::IOStream, basedir::String, myvar::Array{String,1}, timeUnits::String; plotresults::Bool=false, h5::Bool=false)
    filename = joinpath(basedir,"sensitivity","mads","setup","$(simbasename)-mas.dat")
    if h5
        # put code for reading h5 file here
    else
        results = sachFun.readObsDataset(filename,myvar)
    end
    x = results[:,1]
    y1 = -results[:,2]
    obstimes = x[1:skipfactor:end]
    targets = -results[1:skipfactor:end,2]
    targets_noisy = targets + nr.normal(0,mystd,length(targets))
    
    # non-negative values only
    targets_noisy_nn = targets_noisy[targets_noisy.>0]
    obstimes_nn = obstimes[targets_noisy.>0]

    if plotresults
        fig = plt.figure("pyplot_fig",figsize=(15,10))
        p = plt.plot(x,y1,linestyle="-",
                marker=" ",
                label= "simulation",
                color = "blue") # Plot a basic line

        plt.scatter(obstimes_nn,targets_noisy_nn, c="b", label = "targets, noisy, nn")

        plt.title(myvar)
        plt.legend()
        plt.savefig("./targets.png")
        plt.close()
    end
    
    for i in 1:length(obstimes_nn)
         write(outfile, "- $(caltag)_t$(i): ")
         @printf(outfile, "{target: %0.5e, ", targets_noisy_nn[i])
         @printf(outfile, "weight: 100.0, ")
         @printf(outfile, "time: %.2f}\n", obstimes_nn[i])
    end
    
    # print observation times
    # outfile2 = open("obstimes.txt", "w")
    # write(outfile2, "  TIMES $(timeUnits) ")
    # for t in obstimes_nn
    #     @printf(outfile2,"%.1f ", t)
    # end
    # println(outfile2)
    # println(outfile2,"ncalibrationTargets = $(length(obstimes_nn))")
    # close(outfile2)
    return obstimes_nn
end

#------------------------------------------------------------------------------
# Initialize
#------------------------------------------------------------------------------
# general info
basedir = "/lclscratch/sach/Programs/pflotran-dithionite-git/chrome-dithionite-tests"
simbasename = "1d-allReactions-10m-uniformVelocity"

# User info for making synthetic data
plotresults = true # for plotting targets
myvar = ["east CrO4-- [mol/d]"]
mystd = 2.e-6 # standard deviation
skipfactor = 7 # resolution of targets vs simulation output
caltag = "Cr6_Obs"
timeUnits = "d"

# Default parameters for writing MADS file
paramfilename = "../../parameters.xlsx"
sheetname = "mads_efast_tightened"
jcommand = "read_data.jl"
soltype = "external"
startover = "false"

#------------------------------------------------------------------------------
# The code
#------------------------------------------------------------------------------
# write the mads file
f = xlr.openxl(paramfilename)
paraminfo = xlr.readxl(paramfilename, "$(sheetname)!A2:D12")
outfile = open(joinpath(".","$(simbasename).mads"), "w")
println(outfile,"Julia command: $(jcommand)")

println(outfile,"Observations:")
newtimes = madstargets(outfile,basedir,myvar,timeUnits,plotresults=true)

println(outfile,"Parameters:")
for i in 1:length(paraminfo[:,1])
    write(outfile, "- log_$(paraminfo[i,1]): ")
    @printf(outfile, "{init: %0.4f, ", paraminfo[i,2])
    @printf(outfile, "min: %0.4f, ", paraminfo[i,3])
    @printf(outfile, "max: %0.4f, ", paraminfo[i,4])
    write(outfile, "type: opt}\n")
        if paraminfo[i,1] != "factor_k_fe2_o2_slow" && paraminfo[i,1] != "factor_k_fe2_cr6_slow"
            println(outfile, "- $(paraminfo[i,1]): {exp: \"10^log_$(paraminfo[i,1])\"}")
        end
end

# Do the tranformations for slow site kinetic constants
write(outfile, "- k_fe2_o2_slow: {exp: \"10^log_k_fe2_o2_fast*10^log_factor_k_fe2_o2_slow\"}\n")
write(outfile, "- k_fe2_cr6_slow: {exp: \"10^log_k_fe2_cr6_fast*10^log_factor_k_fe2_cr6_slow\"}\n")

println(outfile,"Solution: $(soltype)")
println(outfile,"Templates:")
println(outfile,"- tmp1: {tpl: $(simbasename).in.tpl, write: $(simbasename).in}")
println(outfile,"Restart: $(startover)")
    
close(outfile)

println("finished writing mads file")

# Open the template file and put the new times in
outfile3 = open(joinpath(".","$(simbasename).in.tpl"))
tempstrings = readlines(outfile3)
close(outfile3)
timeindex = find(map(x->contains(x,"  TIMES d"),tempstrings))
for ti in timeindex
    tempstrings[ti] = "  TIMES d " * join(newtimes, " ") * "\n"
end
outfile4 = open(joinpath(".","$(simbasename).in.tpl"), "w")
for tempstring in tempstrings
    print(outfile4,tempstring)
end
close(outfile4)
