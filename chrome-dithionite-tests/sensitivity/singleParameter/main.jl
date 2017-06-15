import Mads
import ExcelReaders
xlr = ExcelReaders

function transformmadsdata(logparamsval,logparamkeys)
    # Transforms log parameters in madsdict to non-log 
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

function runforabit(command, timelimit, pollinterval=1)
    # kills terminal command if time limit is exceeded
    # note, all times are in seconds
    starttime = now()
    process = spawn(command)
    while !process_exited(process) && float(now() - starttime) / 1000 < timelimit
        sleep(pollinterval)
    end
    if !process_exited(process)
        kill(process)
        return false
    else
        return true
    end
end

# User info
sensparams = [
              "k_s2o4_disp",
              "k_s2o4_o2",
              "k_s2o4_fe3",
              "k_fe2_o2_slow",
              "k_fe2_o2_fast",
              "k_fe2_cr6_slow",
              "k_fe2_cr6_fast",
              "is2o4",
              "ifeoh3",
              "d",
              "q",
              ]

rundir =  "attempt4"
nstops = 5

# Default parameters for writing MADS file
fname = "../parameters.xlsx"
jcommand = "read_data.jl"
soltype = "external"
simbasename = "1d-allReactions-10m-uniformVelocity"
startover = "false"

# pflotran information
basedir = "/lclscratch/sach/Programs/pflotran-dithionite-git/chrome-dithionite-tests/sensitivity/singleParameter"
pfle = "/lclscratch/sach/Programs/pflotran-dithionite-git/src/pflotran/pflotran"
np = 8
maxruntime = 15 * 60 # seconds from minutes

# write the mads file
f = xlr.openxl(fname)
paraminfo = xlr.readxl(fname, "mads!A2:D12")

# make run directory
if !isdir(joinpath(basedir,rundir))
    mkdir(joinpath(basedir,rundir))
end

outfile = open(joinpath(rundir,"$(simbasename).mads"), "w")
println(outfile,"Julia command: $(jcommand)")
println(outfile,"Parameters:")

for i in 1:length(paraminfo[:,1])
    write(outfile, "- log_$(paraminfo[i,1]): ")
    @printf(outfile, "{init: %0.4f, ", paraminfo[i,2])
    @printf(outfile, "min: %0.4f, ", paraminfo[i,3])
    @printf(outfile, "max: %0.4f, ", paraminfo[i,4])
    write(outfile, "type: opt}\n")
    println(outfile, "- $(paraminfo[i,1]): {exp: \"10^log_$(paraminfo[i,1])\"} ")
end

close(outfile)

# read the mads file
madsdata = Mads.loadmadsfile(joinpath(rundir,"$(simbasename).mads"))

# get param names (non-log) and param ranges
logparams_init = Mads.getparamsinit(madsdata)
logparamkeys = Mads.getparamkeys(madsdata)
paramkeys,params_init = transformmadsdata(logparams_init,logparamkeys)

logparams_min = Mads.getparamsmin(madsdata)
paramkeys,params_min = transformmadsdata(logparams_min,logparamkeys)

logparams_max = Mads.getparamsmax(madsdata)
paramkeys,params_max = transformmadsdata(logparams_max,logparamkeys)

# sensitivity analysis
for sensparam in sensparams
    # make range for sensitivity analysis
    iparamloc = find(x -> x == sensparam,paramkeys)[1]
    sensvals = 10.^linspace(logparams_min[iparamloc],logparams_max[iparamloc],nstops)

    # make a matrix [parameters, sensitivity run]
    paramarray = Array{Float64}(length(paramkeys),length(sensvals))
    for i in 1:length(sensvals)
        paramarray[:,i] = params_init
        paramarray[iparamloc,i] = sensvals[i]
    end

    # now lets make the inputfiles
    if !isdir(joinpath(basedir,rundir,sensparam))
        mkdir(joinpath(basedir,rundir,sensparam))
    end

    for i in 1:length(sensvals)
        if !isdir(joinpath(basedir,rundir,sensparam,"run$i"))
            mkdir(joinpath(basedir,rundir,sensparam,"run$i"))
        end
        parameters = Dict(zip(paramkeys, paramarray[:,i]))
        templatefilename = "../templateFiles/$simbasename.in.tpl"
        outputfilename = joinpath(basedir,rundir,sensparam,"run$i/$simbasename.in")
        Mads.writeparametersviatemplate(parameters, templatefilename, outputfilename)
        cd(joinpath(basedir,rundir,sensparam,"run$i"))
        try
            println("starting $sensparam run $i")
            runforabit(`mpirun -np $np $pfle -pflotranin $(simbasename).in > $(simbasename).txt`, maxruntime)
        catch
            warn("$(rundir)/$(sensparam)/run$(i) failed :()")
        end
        cd(basedir)
    end
end
