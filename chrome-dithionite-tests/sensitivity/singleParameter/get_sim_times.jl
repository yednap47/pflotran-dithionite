basedir = "/lclscratch/sach/Programs/pflotran-dithionite-git/chrome-dithionite-tests/sensitivity/singleParameter"
rundir = "attempt2"
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
nstops = 7

simtimes = Dict() # minutes
for sensparam in sensparams
    temp = Array{Float64}(0)
    for i in 1:nstops
        outfile = open(joinpath(basedir,rundir,sensparam,"run$(i)","$(simbasename).out"))
        temp2 = readlines(outfile)
        close(outfile)
        append!(temp,float(split(split(temp2[end],"   ")[2], )[1]))
    end
    simtimes[sensparam] = temp
end
