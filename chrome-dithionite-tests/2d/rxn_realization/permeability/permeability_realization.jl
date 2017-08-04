import ExcelReaders
xlr = ExcelReaders

# Mads.writeparametersviatemplate(parameters, templatefilename, outputfilename)
# parameters = Dict("is2o4"=>0.1,"ina"=>0.2,"k_fe2_o2_fast"=>10.0,"k_s2o4_disp"=>3.60994e-6,"q"=>0.150003,"fraction"=>0.500035,"k_s2o4_o2"=>1.0,"ifeoh3"=>0.00385834,"k_fe2_cr6_fast"=>10.0,"k_fe2_o2_slow"=>0.1,"k_fe2_cr6_slow"=>0.1,"k_s2o4_fe3"=>1.0e-5)
# templatefilename = "1d-allReactions-10m-uniformVelocity.in.tpl"
# outputfilename = "/lclscratch/sach/Programs/pflotran-dithionite/chrome-dithionite-tests/sensitivity/singleParameter/attemptx/k_s2o4_disp/run1/1d-allReactions-10m-uniformVelocity.in"

function writeparametersviatemplate(parameters, templatefilename, outputfilename; respect_space::Bool=false)
	tplfile = open(templatefilename) # open template file
	line = readline(tplfile) # read the first line that says "template $separator\n"
	if length(line) >= 10 && line[1:9] == "template "
		separator = line[10] # template separator
		lines = readlines(tplfile)
	else
		#it doesn't specify the separator -- assume it is '#'
		separator = '#'
		lines = [line; readlines(tplfile)]
	end
	close(tplfile)
	outfile = open(outputfilename, "w")
	for line in lines
		splitline = split(line, separator) # two separators are needed for each parameter
		if rem(length(splitline), 2) != 1
			error("The number of separators (\"$separator\") is not even in template file $templatefilename on line:\n$line")
		end
		for i = 1:div(length(splitline)-1, 2)
			write(outfile, splitline[2 * i - 1]) # write the text before the parameter separator
			varname = strip(splitline[2 * i])
			if respect_space
				l = length(splitline[2 * i])
				s = Mads.sprintf("%.$(l)g", parameters[varname])
			else
				s = string(parameters[varname])
			end
			write(outfile, s)
			# madsinfo("Replacing " * varname * " -> " * s, 1)
		end
		write(outfile, splitline[end]) # write the rest of the line after the last separator
		if VERSION >= v"0.6.0-dev.2283" # julia PR #20203
			write(outfile, "\n")
		end
	end
	close(outfile)
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
sensparam = "permfname"



# pflotran information
rundir =  "corr1_sig1" # where the simulations are going
permfieldbasename = "rand_100x75_corr10_sig1_20mpd_n"
basedir = "/lclscratch/sach/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/rxn_realization/permeability" # working directory
permfielddir = "/lclscratch/sach/Programs/pflotran-dithionite/chrome-dithionite-tests/2d/fieldGeneration/multirealization/corr1_sig1" 
pfle = "/lclscratch/sach/Programs/pflotran-dithionite/src/pflotran/pflotran"
np = 16
maxruntime = 5.0 * 60.0 * 60.0 # seconds from hours
nrealizations = 1:1:100

# make run directory
if !isdir(joinpath(basedir,rundir))
    mkdir(joinpath(basedir,rundir))
end

# The loop goes here
for nrealization in nrealizations
    if !isdir(joinpath(basedir,rundir,"run$(nrealization)"))
        mkdir(joinpath(basedir,rundir,"run$(nrealization)"))
    end

    parameters = Dict(sensparam=>nrealization)

    # STEP 1: run the checkpointfile
    templatefilename = "src_checkpoint.in.tpl"
    simname = split(templatefilename,".tpl")[1]
    outputfilename = joinpath(basedir,rundir,"run$(nrealization)",simname)
    writeparametersviatemplate(parameters, templatefilename, outputfilename)
    cd(joinpath(basedir,rundir,"run$nrealization"))
    try
        println("starting checkpoint run $nrealization")
        runforabit(`mpirun -np $np $pfle -pflotranin $(simname) > $(simname).txt`, maxruntime)
    catch
        warn("run $(nrealization) checkpoint failed :(")
    end
    cd(basedir)

    # STEP 2: run the checkpointfile
    templatefilename = "src.in.tpl"
    simname = split(templatefilename,".tpl")[1]
    outputfilename = joinpath(basedir,rundir,"run$(nrealization)",simname)
    writeparametersviatemplate(parameters, templatefilename, outputfilename)
    cd(joinpath(basedir,rundir,"run$nrealization"))
    try
        println("starting rxn run $nrealization")
        runforabit(`mpirun -np $np $pfle -pflotranin $(simname) > $(simname).txt`, maxruntime)
    catch
        warn("run $(nrealization) rxn failed :(")
    end
    cd(basedir)

    # STEP 3: run the norxn
    templatefilename = "src_norxn.in.tpl"
    simname = split(templatefilename,".tpl")[1]
    outputfilename = joinpath(basedir,rundir,"run$(nrealization)",simname)
    writeparametersviatemplate(parameters, templatefilename, outputfilename)
    cd(joinpath(basedir,rundir,"run$nrealization"))
    try
        println("starting norxn run $nrealization")
        runforabit(`mpirun -np $np $pfle -pflotranin $(simname) > $(simname).txt`, maxruntime)
    catch
        warn("run $(nrealization) norxn failed :(")
    end
    cd(basedir)
end
